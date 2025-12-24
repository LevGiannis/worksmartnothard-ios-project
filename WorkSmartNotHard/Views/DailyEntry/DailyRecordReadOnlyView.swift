import SwiftUI

struct DailyRecordReadOnlyView: View {
    let plan: MonthPlan
    let record: DailyRecord

    var body: some View {
        List {
            Section {
                Text(record.date.formatted(.dateTime.day().month(.wide).year().locale(Locale(identifier: "el_GR"))))
                    .font(.headline)
                Text("Σύνολο ημέρας: \(total)")
                    .foregroundStyle(.secondary)
            } header: {
                Text("ΗΜΕΡΟΜΗΝΙΑ")
            }

            Section {
                if displayedValues.isEmpty {
                    Text("Δεν υπάρχουν τιμές για αυτή την ημέρα.")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(displayedValues, id: \.id) { v in
                        HStack {
                            if v.categoryName == SalesCategory.vodafoneHomeWF.rawValue, let subtype = v.subtype, !subtype.isEmpty {
                                Text("\(v.categoryName) [\(subtype)]")
                            } else {
                                Text(v.categoryName)
                            }
                            Spacer()
                            Text("\(v.value)")
                                .font(.headline)
                        }
                        .padding(.vertical, 4)
                    }
                }
            } header: {
                Text("ΠΟΣΟΤΗΤΕΣ ΑΝΑ ΚΑΤΗΓΟΡΙΑ")
            } footer: {
                Text("Μόνο προβολή — δεν επιτρέπονται τροποποιήσεις από το ιστορικό.")
            }
        }
        .navigationTitle("Ημέρα")
    }

    private var total: Int {
        record.values.reduce(0) { $0 + $1.value }
    }

    // Μόνο όσα έχουν value > 0 για καθαρότητα
    private var displayedValues: [DailyValue] {
        record.values
            .filter { $0.value > 0 }
            .sorted { $0.categoryName.localizedCaseInsensitiveCompare($1.categoryName) == .orderedAscending }
    }
}
