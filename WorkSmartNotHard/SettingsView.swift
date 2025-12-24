//
//  SettingsView.swift
//  WorkSmartNotHard
//
//  Created by Ioannis Levakos on 24/12/25.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("appTheme") private var appThemeRaw: String = AppTheme.light.rawValue

    var body: some View {
        Form {
            Section {
                Picker("Theme", selection: $appThemeRaw) {
                    ForEach(AppTheme.allCases) { theme in
                        Text(theme.titleGR).tag(theme.rawValue)
                    }
                }
                .pickerStyle(.segmented)
            } header: {
                Text("Εμφάνιση")
            } footer: {
                Text("Επιλέγεις αν η εφαρμογή θα είναι λευκή ή μαύρη.")
            }
        }
        .navigationTitle("Ρυθμίσεις")
    }
}
