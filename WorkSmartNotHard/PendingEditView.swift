//
//  PendingEditView.swift
//  WorkSmartNotHard
//
//  Created by Ioannis Levakos on 24/12/25.
//

import SwiftUI
import SwiftData

struct PendingEditView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    let item: PendingCustomerTask

    @State private var customerName = ""
    @State private var phone = ""
    @State private var afm = ""
    @State private var details = ""
    @State private var isDone = false

    var body: some View {
        Form {
            Section {
                TextField("Όνομα πελάτη", text: $customerName)
                TextField("Κινητό", text: $phone).keyboardType(.phonePad)
                TextField("ΑΦΜ", text: $afm).keyboardType(.numberPad)
                TextField("Περιγραφή εκκρεμότητας", text: $details, axis: .vertical)
                    .lineLimit(4...8)
                Toggle("Ολοκληρώθηκε", isOn: $isDone)
            } header: {
                Text("Επεξεργασία")
            }

            Section {
                Button("Αποθήκευση αλλαγών") {
                    item.customerName = customerName.trimmingCharacters(in: .whitespacesAndNewlines)
                    item.phone = phone.trimmingCharacters(in: .whitespacesAndNewlines)
                    item.afm = afm.trimmingCharacters(in: .whitespacesAndNewlines)
                    item.details = details.trimmingCharacters(in: .whitespacesAndNewlines)
                    item.isDone = isDone
                    do { try modelContext.save() } catch {}
                    dismiss()
                }
            }
        }
        .navigationTitle("Εκκρεμότητα")
        .onAppear {
            customerName = item.customerName
            phone = item.phone
            afm = item.afm
            details = item.details
            isDone = item.isDone
        }
    }
}
