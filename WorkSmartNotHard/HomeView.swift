import SwiftUI
import SwiftData

struct HomeView: View {
    let profile: UserProfile
    private var currentMonthStart: Date { Date().startOfMonth }

    @Query private var plans: [MonthPlan]
    @Query(sort: \AppCategory.sortOrder) private var categories: [AppCategory]

    init(profile: UserProfile) {
        self.profile = profile
        let key = Date().startOfMonth.monthKey
        _plans = Query(filter: #Predicate<MonthPlan> { $0.monthKey == key })
    }

    private var plan: MonthPlan? { plans.first }

    private var activeCategories: [AppCategory] {
        categories.filter { $0.isActive }
    }

    // MARK: - Progress Calculations (for current month)

    private func target(for categoryId: UUID) -> Int {
        plan?.goals.first(where: { $0.categoryId == categoryId })?.target ?? 0
    }

    private func produced(for categoryId: UUID) -> Int {
        guard let plan else { return 0 }
        var sum = 0
        for rec in plan.records {
            for v in rec.values where v.categoryId == categoryId {
                sum += v.value
            }
        }
        return sum
    }

    private func percent(produced: Int, target: Int) -> Int {
        guard target > 0 else { return 0 }
        let p = Int((Double(produced) / Double(target)) * 100.0)
        return max(0, min(100, p))
    }

    private var categoriesWithTarget: [AppCategory] {
        activeCategories.filter { target(for: $0.id) > 0 }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {

                    // Header
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Κατάστημα")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                Text(profile.storeCode)
                                    .font(.title2)
                                    .bold()
                            }
                            Spacer()
                            VStack(alignment: .trailing, spacing: 4) {
                                Text("Χρήστης")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                Text(profile.nickname)
                                    .font(.title3)
                                    .bold()
                            }
                        }

                        Text("Τρέχων μήνας: \(currentMonthStart.monthTitleGR)")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                    .background(.thinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 16))

                    // Main Actions
                    VStack(spacing: 12) {
                        // ✅ Choose month for Daily Entry / Goals (any month)
                        NavigationLink {
                            MonthSelectView()
                        } label: {
                            Text("Μήνες (Καταχώριση / Στόχοι)")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)

                        // Read-only history
                        NavigationLink {
                            HistoryView()
                        } label: {
                            Text("Ιστορικό (μόνο προβολή)")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.bordered)

                        HStack(spacing: 12) {
                            NavigationLink {
                                PendingListView()
                            } label: {
                                Text("Εκκρεμότητες")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.bordered)

                            NavigationLink {
                                CategoriesView()
                            } label: {
                                Text("Κατηγορίες")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.bordered)
                        }

                        NavigationLink {
                            SettingsView()
                        } label: {
                            Text("Ρυθμίσεις")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.bordered)
                    }

                    // Current month progress (only categories with target > 0)
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Επίτευξη τρέχοντος μήνα ανά κατηγορία")
                            .font(.headline)

                        if plan == nil {
                            Text("Δεν υπάρχει πλάνο για τον τρέχοντα μήνα ακόμα. Πήγαινε στο “Μήνες (Καταχώριση / Στόχοι)” και βάλε στόχους.")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                        } else if categoriesWithTarget.isEmpty {
                            Text("Δεν έχεις βάλει στόχους σε καμία κατηγορία για τον τρέχοντα μήνα.")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                        } else {
                            ForEach(categoriesWithTarget) { cat in
                                let t = target(for: cat.id)
                                let p = produced(for: cat.id)
                                let pct = percent(produced: p, target: t)

                                VStack(alignment: .leading, spacing: 8) {
                                    HStack {
                                        Text(cat.name)
                                            .font(.subheadline)
                                            .bold()
                                        Spacer()
                                        Text("\(pct)%")
                                            .font(.subheadline)
                                            .bold()
                                    }

                                    ProgressView(value: Double(min(p, t)), total: Double(t))

                                    HStack {
                                        Text("Παραγωγή: \(p)")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                        Spacer()
                                        Text("Στόχος: \(t)")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                }
                                .padding()
                                .background(.thinMaterial)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                            }
                        }
                    }
                    .padding(.top, 4)
                }
                .padding()
            }
            .navigationTitle("Dashboard")
        }
    }
}
