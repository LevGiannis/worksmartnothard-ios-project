import SwiftUI
import SwiftData

struct MonthlyGoalsView: View {
    @Environment(\.modelContext) private var modelContext

    private let monthStart: Date
    @Query private var plans: [MonthPlan]
    @Query(sort: \AppCategory.sortOrder) private var categories: [AppCategory]

    @State private var localTargets: [UUID: Int] = [:]

    init(monthStart: Date) {
        self.monthStart = monthStart
        let key = monthStart.startOfMonth.monthKey
        _plans = Query(filter: #Predicate<MonthPlan> { $0.monthKey == key })
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

    var body: some View {
        List {
            Section {
                if activeCategories.isEmpty {
                    Text("Δεν υπάρχουν ενεργές κατηγορίες. Πήγαινε στις “Κατηγορίες”.")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(activeCategories) { cat in
                        HStack {
                            Text(cat.name)
                            Spacer()
                            TextField("0", value: Binding(
                                get: { localTargets[cat.id] ?? currentTarget(for: cat.id) },
                                set: { localTargets[cat.id] = $0 }
                            ), formatter: NumberFormatter())
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 80)
                        }
                    }
                }
            } header: {
                Text("Μήνας: \(monthStart.startOfMonth.monthTitleGR)")
            }

            Section {
                Button("Αποθήκευση στόχων") { saveGoals() }
                    .disabled(activeCategories.isEmpty)
            } footer: {
                Text("Βάλε στόχο ανά κατηγορία. Μόνο οι κατηγορίες με στόχο > 0 θα εμφανίζονται στο Dashboard.")
            }
        }
        .navigationTitle("Στόχοι μήνα")
        .onAppear {
            for g in plan.goals {
                localTargets[g.categoryId] = g.target
            }
        }
    }

    private func currentTarget(for categoryId: UUID) -> Int {
        plan.goals.first(where: { $0.categoryId == categoryId })?.target ?? 0
    }

    private func saveGoals() {
        for cat in activeCategories {
            let newTarget = max(0, localTargets[cat.id] ?? currentTarget(for: cat.id))

            if let existing = plan.goals.first(where: { $0.categoryId == cat.id }) {
                existing.target = newTarget
                existing.categoryName = cat.name
            } else {
                plan.goals.append(Goal(categoryId: cat.id, categoryName: cat.name, target: newTarget))
            }
        }

        do { try modelContext.save() } catch { }
    }
}
