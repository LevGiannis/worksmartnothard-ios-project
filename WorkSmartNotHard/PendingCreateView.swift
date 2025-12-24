//
//  PendingCreateView.swift
//  WorkSmartNotHard
//
//  Created by Ioannis Levakos on 24/12/25.
//

import SwiftUI
import SwiftData

struct PendingCreateView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var customerName = ""
    @State private var phone = ""
    @State private var afm = ""
    @State private var details = ""

    private var isValid: Bool {
        !customerName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !phone.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !afm.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !details.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        Form {
            Section {
                TextField("Όνομα πελάτη", text: $customerName)
                TextField("Κινητό", text: $phone)
                    .keyboardType(.phonePad)
                TextField("ΑΦΜ", text: $afm)
                    .keyboardType(.numberPad)
                TextField("Περιγραφή εκκρεμότητας", text: $details, axis: .vertical)
                    .lineLimit(4...8)
            } header: {
                Text("Νέα εκκρεμότητα")
            }

            Section {
                Button("Αποθήκευση") {
                    let item = PendingCustomerTask(
                        customerName: customerName.trimmingCharacters(in: .whitespacesAndNewlines),
                        phone: phone.trimmingCharacters(in: .whitespacesAndNewlines),
                        afm: afm.trimmingCharacters(in: .whitespacesAndNewlines),
                        details: details.trimmingCharacters(in: .whitespacesAndNewlines)
                    )
                    modelContext.insert(item)
                    do { try modelContext.save() } catch {}
                    dismiss()
                }
                .disabled(!isValid)
            }
        }
        .navigationTitle("Προσθήκη")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Άκυρο") { dismiss() }
            }
        }
    }
}
