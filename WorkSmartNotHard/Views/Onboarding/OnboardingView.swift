//
//  OnboardingView.swift
//  WorkSmartNotHard
//
//  Created by Ioannis Levakos on 24/12/25.
//

import SwiftUI
import SwiftData

struct OnboardingView: View {
    @Environment(\.modelContext) private var modelContext

    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var nickname = ""
    @State private var storeCode = ""

    private var isValid: Bool {
        let basicEmailOk = email.contains("@") && email.contains(".")
        return !firstName.trimmingCharacters(in: .whitespaces).isEmpty &&
               !lastName.trimmingCharacters(in: .whitespaces).isEmpty &&
               basicEmailOk &&
               !nickname.trimmingCharacters(in: .whitespaces).isEmpty &&
               !storeCode.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Στοιχεία χρήστη") {
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
                }

                Section {
                    Button {
                        let profile = UserProfile(
                            firstName: firstName.trimmingCharacters(in: .whitespacesAndNewlines),
                            lastName: lastName.trimmingCharacters(in: .whitespacesAndNewlines),
                            email: email.trimmingCharacters(in: .whitespacesAndNewlines),
                            nickname: nickname.trimmingCharacters(in: .whitespacesAndNewlines),
                            storeCode: storeCode.trimmingCharacters(in: .whitespacesAndNewlines)
                        )
                        modelContext.insert(profile)
                        // Δεν χρειάζεται navigation — το AppEntryView θα “δει” ότι υπάρχει profile και θα πάει Home.
                    } label: {
                        Text("Συνέχεια")
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    .disabled(!isValid)
                } footer: {
                    Text("Συμπλήρωσε όλα τα πεδία. Το email χρειάζεται να είναι σε σωστή μορφή.")
                }
            }
            .navigationTitle("WorkSmartNotHard")
        }
    }
}
