//
//  SettingsView.swift
//  WorkSmartNotHard
//
//  Created by Ioannis Levakos on 24/12/25.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("appTheme") private var appThemeRaw: String = AppTheme.light.rawValue
    @AppStorage("accentColor") private var accentColorRaw: String = AccentColorOption.blue.rawValue

    var body: some View {
        Form {
            Section {
                Picker("Θέμα", selection: $appThemeRaw) {
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

            Section {
                Picker("Χρώμα προφοράς", selection: $accentColorRaw) {
                    ForEach(AccentColorOption.allCases) { color in
                        Text(color.titleGR).tag(color.rawValue)
                    }
                }
                .pickerStyle(.segmented)
            } header: {
                Text("Χρώμα προφοράς")
            } footer: {
                Text("Επιλέγεις το βασικό χρώμα της εφαρμογής.")
            }
        }
        .navigationTitle("Ρυθμίσεις")
    }
}
