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
    @Query(sort: \AppCategory.sortOrder) private var categories: [AppCategory]

    let item: PendingCustomerTask

    @State private var customerName = ""
    @State private var mobilePhone = ""
    @State private var landlinePhone = ""
    @State private var phone = ""
    @State private var afm = ""
    @State private var details = ""
    @State private var isDone = false
    @State private var selectedCategoryId: UUID? = nil
    @State private var selectedPendingType: PendingType = .none

    var body: some View {
        Form {
            Section {
                TextField("Όνομα πελάτη", text: $customerName)
                TextField("Κινητό (προαιρετικό)", text: $mobilePhone).keyboardType(.phonePad)
                TextField("Σταθερό (προαιρετικό)", text: $landlinePhone).keyboardType(.phonePad)
                TextField("ΑΦΜ (προαιρετικό)", text: $afm).keyboardType(.numberPad)
                TextField("Περιγραφή εκκρεμότητας", text: $details, axis: .vertical)
                    .lineLimit(4...8)
                Toggle("Ολοκληρώθηκε", isOn: $isDone)
            } header: {
                Text("Επεξεργασία")
            }

            Section("Κατηγορία ή Τύπος εκκρεμότητας (προαιρετικά)") {
                Picker("Κατηγορία", selection: $selectedCategoryId) {
                    Text("-").tag(UUID?.none)
                    ForEach(categories) { cat in
                        Text(cat.name).tag(UUID?.some(cat.id))
                    }
                }
                .pickerStyle(.menu)

                Picker("Τύπος εκκρεμότητας", selection: $selectedPendingType) {
                    ForEach(PendingType.allCases.filter { $0 != .none }) { t in
                        Text(t.rawValue).tag(t)
                    }
                }
                .pickerStyle(.menu)
            }

            Section {
                Button("Αποθήκευση αλλαγών") {
                    let catName = categories.first(where: { $0.id == selectedCategoryId })?.name
                    item.customerName = customerName.trimmingCharacters(in: .whitespacesAndNewlines)
                    item.mobilePhone = mobilePhone.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : mobilePhone.trimmingCharacters(in: .whitespacesAndNewlines)
                    item.landlinePhone = landlinePhone.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : landlinePhone.trimmingCharacters(in: .whitespacesAndNewlines)
                    item.phone = (mobilePhone.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? landlinePhone : mobilePhone).trimmingCharacters(in: .whitespacesAndNewlines)
                    item.afm = afm.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "" : afm.trimmingCharacters(in: .whitespacesAndNewlines)
                    item.details = details.trimmingCharacters(in: .whitespacesAndNewlines)
                    item.categoryId = selectedCategoryId
                    item.categoryName = catName
                    item.pendingType = selectedPendingType != .none ? selectedPendingType.rawValue : nil
                    item.isDone = isDone
                    do { try modelContext.save() } catch {}
                    dismiss()
                }
            }
        }
        .navigationTitle("Εκκρεμότητα")
        .onAppear {
            customerName = item.customerName
            mobilePhone = item.mobilePhone ?? ""
            landlinePhone = item.landlinePhone ?? ""
            phone = item.phone
            afm = item.afm
            details = item.details
            isDone = item.isDone
            selectedCategoryId = item.categoryId
            if let pt = item.pendingType, let t = PendingType(rawValue: pt) { selectedPendingType = t } else { selectedPendingType = .none }
        }
    }
}
