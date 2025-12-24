//
//  SettingsView.swift
//  WorkSmartNotHard
//
//  Created by Ioannis Levakos on 24/12/25.
//

import SwiftUI

import SwiftData

struct SettingsView: View {
    @AppStorage("appTheme") private var appThemeRaw: String = AppTheme.light.rawValue
    @AppStorage("accentColor") private var accentColorRaw: String = AccentColorOption.blue.rawValue

    @Environment(\.modelContext) private var modelContext
    @Query(sort: \UserProfile.createdAt, order: .reverse) private var profiles: [UserProfile]
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var nickname: String = ""
    @State private var storeCode: String = ""
    @State private var showSaved: Bool = false

    var body: some View {
        Form {
            // --- User Profile Section ---
            Section("Στοιχεία χρήστη") {
                if let profile = profiles.first {
                    TextField("Όνομα", text: $firstName)
                        .textContentType(.givenName)
                    TextField("Επώνυμο", text: $lastName)
                        .textContentType(.familyName)
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .textContentType(.emailAddress)
                    TextField("Ψευδώνυμο", text: $nickname)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                    TextField("Κωδικός καταστήματος", text: $storeCode)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                    Button("Αποθήκευση αλλαγών") {
                        profile.firstName = firstName.trimmingCharacters(in: .whitespacesAndNewlines)
                        profile.lastName = lastName.trimmingCharacters(in: .whitespacesAndNewlines)
                        profile.email = email.trimmingCharacters(in: .whitespacesAndNewlines)
                        profile.nickname = nickname.trimmingCharacters(in: .whitespacesAndNewlines)
                        profile.storeCode = storeCode.trimmingCharacters(in: .whitespacesAndNewlines)
                        showSaved = true
                    }
                    .disabled(!isProfileValid)
                } else {
                    Text("Δεν βρέθηκε προφίλ χρήστη.")
                }
            }
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
        .onAppear {
            if let profile = profiles.first {
                firstName = profile.firstName
                lastName = profile.lastName
                email = profile.email
                nickname = profile.nickname
                storeCode = profile.storeCode
            }
        }
    }
    
    private var isProfileValid: Bool {
        let basicEmailOk = email.contains("@") && email.contains(".")
        return !firstName.trimmingCharacters(in: .whitespaces).isEmpty &&
               !lastName.trimmingCharacters(in: .whitespaces).isEmpty &&
               basicEmailOk &&
               !nickname.trimmingCharacters(in: .whitespaces).isEmpty &&
               !storeCode.trimmingCharacters(in: .whitespaces).isEmpty
    }
}
