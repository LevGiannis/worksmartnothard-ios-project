import SwiftUI
import SwiftData

struct DailyEntryView: View {
    @Environment(\.modelContext) private var modelContext

    private let monthStart: Date
    @Query private var plans: [MonthPlan]
    @Query(sort: \AppCategory.sortOrder) private var categories: [AppCategory]

    @State private var selectedDate: Date
    @State private var localValues: [UUID: Int] = [:]
    @State private var localSubtypes: [UUID: VodafoneHomeWFSubtype] = [:]
    struct VodafoneWFEntry: Identifiable, Equatable {
        let id: UUID
        var subtype: VodafoneHomeWFSubtype
        var value: Int
        init(subtype: VodafoneHomeWFSubtype, value: Int) {
            self.id = UUID()
            self.subtype = subtype
            self.value = value
        }
    }
    @State private var vodafoneWFEntries: [VodafoneWFEntry] = []

    init(monthStart: Date, initialDate: Date? = nil) {
        let ms = monthStart.startOfMonth
        self.monthStart = ms

        let key = ms.monthKey
        _plans = Query(filter: #Predicate<MonthPlan> { $0.monthKey == key })

        // clamp initial date μέσα στον μήνα
        let initDate = initialDate ?? Date()
        if initDate.isSameMonth(as: ms) {
            _selectedDate = State(initialValue: initDate)
        } else {
            _selectedDate = State(initialValue: ms)
        }
    }

    private var plan: MonthPlan {
        if let p = plans.first { return p }
        let new = MonthPlan(monthStart: monthStart)
        modelContext.insert(new)
        do { try modelContext.save() } catch { }
        return new
    }

    private var activeCategories: [AppCategory] {
        categories.filter { $0.isActive }
    }

    private var allowedRange: ClosedRange<Date> {
        monthStart.startOfMonth...monthStart.endOfMonth
    }

    var body: some View {
        List {
            Section {
                DatePicker(
                    "Επίλεξε ημέρα",
                    selection: $selectedDate,
                    in: allowedRange,                 // ✅ μόνο μέσα στον μήνα
                    displayedComponents: .date
                )
            } header: {
                Text("Ημερομηνία")
            } footer: {
                Text("Ο μήνας είναι κλειδωμένος: \(monthStart.monthTitleGR)")
            }

            Section {
                if activeCategories.isEmpty {
                    Text("Δεν υπάρχουν ενεργές κατηγορίες. Πήγαινε στις “Κατηγορίες”.")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(activeCategories) { cat in
                        if cat.name == SalesCategory.vodafoneHomeWF.rawValue {
                            VStack(alignment: .leading) {
                                Text("Vodafone Home W/F (πολλαπλοί υποτύποι)").font(.headline)
                                ForEach($vodafoneWFEntries, id: \.id) { $entry in
                                    HStack {
                                        Picker("Υποτύπος", selection: $entry.subtype) {
                                            ForEach(VodafoneHomeWFSubtype.allCases) { subtype in
                                                Text(subtype.rawValue).tag(subtype)
                                            }
                                        }
                                        .pickerStyle(.menu)
                                        Stepper(
                                            "\(entry.value)",
                                            value: $entry.value,
                                            in: 0...10_000
                                        )
                                        Button(role: .destructive) {
                                            let entryId = entry.id
                                            DispatchQueue.main.async {
                                                if let idx = vodafoneWFEntries.firstIndex(where: { $0.id == entryId }) {
                                                    vodafoneWFEntries.remove(at: idx)
                                                }
                                            }
                                        } label: {
                                            Image(systemName: "minus.circle")
                                        }
                                    }
                                }
                                Button {
                                    vodafoneWFEntries.append(VodafoneWFEntry(subtype: .adsl, value: 0))
                                } label: {
                                    Label("Προσθήκη υποτύπου", systemImage: "plus")
                                }
                                .buttonStyle(.plain)
                            }
                        } else {
                            VStack(alignment: .leading) {
                                let valueText = "\(cat.name): \(localValues[cat.id] ?? currentValue(for: cat.id))"
                                Stepper(
                                    valueText,
                                    value: Binding(
                                        get: { localValues[cat.id] ?? currentValue(for: cat.id) },
                                        set: { localValues[cat.id] = $0 }
                                    ),
                                    in: 0...10_000
                                )
                            }
                        }
                    }
                }
            } header: {
                Text("Παραγωγή ανά κατηγορία")
            }

            Section {
                Button("Αποθήκευση ημέρας") { saveDay() }
                    .disabled(activeCategories.isEmpty)
            } footer: {
                Text("Αν υπάρχει ήδη καταχώριση για αυτή την ημέρα, θα γίνει ενημέρωση (update).")
            }
        }
        .navigationTitle("Καταχώριση ημέρας")
        .onAppear { preloadIfExists() }
        .onChange(of: selectedDate) { preloadIfExists() }
    }

    // MARK: - Helpers

    private func recordForSelectedDay() -> DailyRecord? {
        let cal = Calendar.current
        return plan.records.first(where: { cal.isDate($0.date, inSameDayAs: selectedDate) })
    }

    private func currentValue(for categoryId: UUID) -> Int {
        guard let rec = recordForSelectedDay() else { return 0 }
        return rec.values.first(where: { $0.categoryId == categoryId })?.value ?? 0
    }

    private func preloadIfExists() {
        localValues = [:]
        vodafoneWFEntries = []
        if let rec = recordForSelectedDay() {
            for v in rec.values {
                if let subtype = v.subtype, v.categoryName == SalesCategory.vodafoneHomeWF.rawValue {
                    if let st = VodafoneHomeWFSubtype(rawValue: subtype) {
                        vodafoneWFEntries.append(VodafoneWFEntry(subtype: st, value: v.value))
                    }
                } else {
                    localValues[v.categoryId] = v.value
                }
            }
        }
    }

    private func saveDay() {
        // extra safety: αν για κάποιο λόγο βγει εκτός range, το φέρνουμε πίσω
        if selectedDate < allowedRange.lowerBound || selectedDate > allowedRange.upperBound {
            selectedDate = monthStart.startOfMonth
        }

        let rec: DailyRecord
        if let existing = recordForSelectedDay() {
            rec = existing
        } else {
            rec = DailyRecord(date: selectedDate)
            plan.records.append(rec)
        }

        // Κανονικές κατηγορίες (εκτός Vodafone Home W/F)
        for cat in activeCategories where cat.name != SalesCategory.vodafoneHomeWF.rawValue {
            let newVal = max(0, localValues[cat.id] ?? currentValue(for: cat.id))
            if let existingVal = rec.values.first(where: { $0.categoryId == cat.id }) {
                existingVal.value = newVal
                existingVal.categoryName = cat.name
                existingVal.subtype = nil
            } else {
                rec.values.append(DailyValue(categoryId: cat.id, categoryName: cat.name, value: newVal, subtype: nil))
            }
        }

        // Vodafone Home W/F: διαγράφουμε παλιές και προσθέτουμε όλες τις νέες
        if let vodafoneCat = activeCategories.first(where: { $0.name == SalesCategory.vodafoneHomeWF.rawValue }) {
            rec.values.removeAll(where: { $0.categoryId == vodafoneCat.id })
            for entry in vodafoneWFEntries {
                rec.values.append(DailyValue(categoryId: vodafoneCat.id, categoryName: vodafoneCat.name, value: entry.value, subtype: entry.subtype.rawValue))
            }
        }

        do { try modelContext.save() } catch { }
    }
}
