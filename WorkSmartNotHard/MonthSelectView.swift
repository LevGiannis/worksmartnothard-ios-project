//
//  MonthSelectView.swift
//  WorkSmartNotHard
//
//  Created by Ioannis Levakos on 24/12/25.
//

import SwiftUI

struct MonthSelectView: View {
    @State private var pickedDate: Date = Date()

    private var pickedMonthStart: Date {
        pickedDate.startOfMonth
    }

    var body: some View {
        Form {
            Section {
                DatePicker("Επίλεξε μήνα", selection: $pickedDate, displayedComponents: .date)
                Text("Επιλεγμένος μήνας: \(pickedMonthStart.monthTitleGR)")
                    .foregroundStyle(.secondary)
            } header: {
                Text("Μήνας")
            }

            Section {
                NavigationLink {
                    DailyEntryView(monthStart: pickedMonthStart)
                } label: {
                    Text("Καταχώριση ημέρας σε αυτόν τον μήνα")
                }

                NavigationLink {
                    MonthlyGoalsView(monthStart: pickedMonthStart)
                } label: {
                    Text("Στόχοι μήνα (προβολή/τροποποίηση)")
                }
            } header: {
                Text("Ενέργειες")
            } footer: {
                Text("Έτσι μπορείς να δουλέψεις σε οποιονδήποτε μήνα. Το Ιστορικό παραμένει μόνο για προβολή.")
            }
        }
        .navigationTitle("Επιλογή μήνα")
    }
}
