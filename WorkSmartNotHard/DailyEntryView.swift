import SwiftUI
import SwiftData

struct DailyEntryView: View {
    @Environment(\.modelContext) private var modelContext

    private let monthStart: Date
    @Query private var plans: [MonthPlan]
    @Query(sort: \AppCategory.sortOrder) private var categories: [AppCategory]

    @State private var selectedDate: Date
    @State private var localValues: [UUID: Int] = [:]

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
                        Stepper(
                            "\(cat.name): \(localValues[cat.id] ?? currentValue(for: cat.id))",
                            value: Binding(
                                get: { localValues[cat.id] ?? currentValue(for: cat.id) },
                                set: { localValues[cat.id] = $0 }
                            ),
                            in: 0...10_000
                        )
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
        if let rec = recordForSelectedDay() {
            for v in rec.values {
                localValues[v.categoryId] = v.value
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

        for cat in activeCategories {
            let newVal = max(0, localValues[cat.id] ?? currentValue(for: cat.id))

            if let existingVal = rec.values.first(where: { $0.categoryId == cat.id }) {
                existingVal.value = newVal
                existingVal.categoryName = cat.name
            } else {
                rec.values.append(DailyValue(categoryId: cat.id, categoryName: cat.name, value: newVal))
            }
        }

        do { try modelContext.save() } catch { }
    }
}
