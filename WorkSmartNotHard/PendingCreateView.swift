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
    @Query(sort: \AppCategory.sortOrder) private var categories: [AppCategory]

    @State private var customerName = ""
    @State private var mobilePhone = ""
    @State private var landlinePhone = ""
    @State private var phone = "" // για συμβατότητα
    @State private var afm = ""
    @State private var details = ""
    @State private var selectedCategoryId: UUID? = nil
    @State private var selectedPendingType: PendingType = .none

    private var isValid: Bool {
        !customerName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        (!mobilePhone.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || !landlinePhone.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty) &&
        !afm.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !details.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        (selectedCategoryId != nil || selectedPendingType != .none)
    }

    var body: some View {
        Form {
            Section {
                TextField("Όνομα πελάτη", text: $customerName)
                TextField("Κινητό (προαιρετικό)", text: $mobilePhone)
                    .keyboardType(.phonePad)
                TextField("Σταθερό (προαιρετικό)", text: $landlinePhone)
                    .keyboardType(.phonePad)
                TextField("ΑΦΜ", text: $afm)
                    .keyboardType(.numberPad)
                TextField("Περιγραφή εκκρεμότητας", text: $details, axis: .vertical)
                    .lineLimit(4...8)
            } header: {
                Text("Νέα εκκρεμότητα")
            }

            Section("Κατηγορία ή Τύπος εκκρεμότητας") {
                Picker("Κατηγορία (προαιρετικό)", selection: $selectedCategoryId) {
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
                Button("Αποθήκευση") {
                    let catName = categories.first(where: { $0.id == selectedCategoryId })?.name
                    let item = PendingCustomerTask(
                        customerName: customerName.trimmingCharacters(in: .whitespacesAndNewlines),
                        mobilePhone: mobilePhone.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : mobilePhone.trimmingCharacters(in: .whitespacesAndNewlines),
                        landlinePhone: landlinePhone.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : landlinePhone.trimmingCharacters(in: .whitespacesAndNewlines),
                        phone: (mobilePhone.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? landlinePhone : mobilePhone).trimmingCharacters(in: .whitespacesAndNewlines),
                        afm: afm.trimmingCharacters(in: .whitespacesAndNewlines),
                        details: details.trimmingCharacters(in: .whitespacesAndNewlines),
                        categoryId: selectedCategoryId,
                        categoryName: catName,
                        pendingType: selectedPendingType != .none ? selectedPendingType.rawValue : nil
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
                    .foregroundColor(AccentColorOption(rawValue: UserDefaults.standard.string(forKey: "accentColor") ?? AccentColorOption.blue.rawValue)?.color ?? .blue)
            }
        }
    }
}
