//
//  MonthDetailReadOnlyView.swift
//  WorkSmartNotHard
//
//  Created by Ioannis Levakos on 24/12/25.
//

import SwiftUI

struct MonthDetailReadOnlyView: View {
    let plan: MonthPlan


    @State private var showingExporter = false
    @State private var exportURL: URL? = nil

    var body: some View {
        List {
            Section {
                if goalsWithTarget.isEmpty {
                    Text("Δεν υπάρχουν στόχοι σε αυτόν τον μήνα.")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(goalsWithTarget, id: \.id) { g in
                        let produced = producedForCategory(g.categoryId)
                        let pct = percent(produced: produced, target: g.target)

                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(g.categoryName).font(.headline)
                                Spacer()
                                Text("\(pct)%").bold()
                            }
                            ProgressView(value: Double(min(produced, g.target)), total: Double(g.target))
                            HStack {
                                Text("Παραγωγή: \(produced)")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                Spacer()
                                Text("Στόχος: \(g.target)")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .padding(.vertical, 6)
                    }
                }
            } header: {
                Text("ΣΥΝΟΨΗ ΑΝΑ ΚΑΤΗΓΟΡΙΑ")
            }

            Section {
                if sortedRecords.isEmpty {
                    Text("Δεν υπάρχουν καταχωρίσεις ημερών.")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(sortedRecords) { rec in
                        NavigationLink {
                            DailyRecordReadOnlyView(plan: plan, record: rec)
                        } label: {
                            VStack(alignment: .leading, spacing: 6) {
                                Text(rec.date.formatted(.dateTime.day().month(.wide).year().locale(Locale(identifier: "el_GR")))).font(.headline)
                                Text("Σύνολο ημέρας: \(totalForRecord(rec))")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.vertical, 6)
                        }
                    }
                }
            } header: {
                Text("ΗΜΕΡΕΣ")
            } footer: {
                Text("Οι ημέρες ανοίγουν μόνο για προβολή (χωρίς επεξεργασία).")
            }
        }
        .navigationTitle("\(plan.monthStart.monthTitleGR)")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: exportCSV) {
                    Image(systemName: "square.and.arrow.up")
                }
            }
        }
        .sheet(isPresented: $showingExporter) {
            if let exportURL = exportURL {
                ShareSheet(activityItems: [exportURL])
            }
        }
    }

    private func exportCSV() {
        let header = "Κατηγορία,Παραγωγή,Στόχος,Ποσοστό"
        let rows = goalsWithTarget.map { g in
            let produced = producedForCategory(g.categoryId)
            let pct = percent(produced: produced, target: g.target)
            return "\(g.categoryName),\(produced),\(g.target),\(pct)%"
        }
        let csv = ([header] + rows).joined(separator: "\n")
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("Export-\(plan.monthStart.monthKey).csv")
        do {
            try csv.write(to: tempURL, atomically: true, encoding: .utf8)
            exportURL = tempURL
            showingExporter = true
        } catch {
            // handle error αν θες
        }
    }

    struct ShareSheet: UIViewControllerRepresentable {
        let activityItems: [Any]
        func makeUIViewController(context: Context) -> UIActivityViewController {
            UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        }
        func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
    }

    // MARK: - Helpers

    private var goalsWithTarget: [Goal] {
        plan.goals
            .filter { $0.target > 0 }
            .sorted { $0.categoryName.localizedCaseInsensitiveCompare($1.categoryName) == .orderedAscending }
    }

    private var sortedRecords: [DailyRecord] {
        plan.records.sorted { $0.date > $1.date }
    }

    private func producedForCategory(_ categoryId: UUID) -> Int {
        var sum = 0
        for r in plan.records {
            for v in r.values where v.categoryId == categoryId {
                sum += v.value
            }
        }
        return sum
    }

    private func totalForRecord(_ rec: DailyRecord) -> Int {
        rec.values.reduce(0) { $0 + $1.value }
    }

    private func percent(produced: Int, target: Int) -> Int {
        guard target > 0 else { return 0 }
        let p = Int((Double(produced) / Double(target)) * 100.0)
        return max(0, min(100, p))
    }
}
