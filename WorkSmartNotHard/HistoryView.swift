import SwiftUI
import SwiftData

struct HistoryView: View {
    @Query(sort: \MonthPlan.monthStart, order: .reverse) private var plans: [MonthPlan]

    var body: some View {
        List {
            Section {
                if plans.isEmpty {
                    Text("Δεν υπάρχουν δεδομένα ακόμα.")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(plans) { plan in
                        NavigationLink {
                            MonthDetailReadOnlyView(plan: plan)
                        } label: {
                            VStack(alignment: .leading, spacing: 6) {
                                Text(plan.monthStart.monthTitleGR)
                                    .font(.headline)
                                Text("\(plan.records.count) ημέρες καταχώρισης")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.vertical, 6)
                        }
                    }
                }
            } header: {
                Text("Μήνες")
            } footer: {
                Text("Το Ιστορικό είναι μόνο για προβολή (χωρίς τροποποιήσεις).")
            }
        }
        .navigationTitle("Ιστορικό")
    }
}
