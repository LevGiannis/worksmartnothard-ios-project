//
//  PendingListView.swift
//  WorkSmartNotHard
//
//  Created by Ioannis Levakos on 24/12/25.
//

import SwiftUI
import SwiftData

struct PendingListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \PendingCustomerTask.createdAt, order: .reverse) private var items: [PendingCustomerTask]

    @State private var showAdd = false
    @State private var searchText = ""

    private var filtered: [PendingCustomerTask] {
        let q = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard !q.isEmpty else { return items }
        return items.filter {
            $0.customerName.lowercased().contains(q) ||
            $0.phone.lowercased().contains(q) ||
            $0.afm.lowercased().contains(q) ||
            $0.details.lowercased().contains(q)
        }
    }

    var body: some View {
        List {
            Section {
                ForEach(filtered) { item in
                    NavigationLink {
                        PendingEditView(item: item)
                    } label: {
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text(item.customerName).font(.headline)
                                Spacer()
                                Toggle("", isOn: Binding(
                                    get: { item.isDone },
                                    set: { item.isDone = $0 }
                                ))
                                .labelsHidden()
                            }

                            Text("Κινητό: \(item.phone) • ΑΦΜ: \(item.afm)")
                                .font(.caption)
                                .foregroundStyle(.secondary)

                            Text(item.details)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .lineLimit(2)
                        }
                        .padding(.vertical, 6)
                    }
                }
                .onDelete(perform: delete)
            } header: {
                Text("Εκκρεμότητες")
            } footer: {
                Text("Toggle δεξιά: ολοκληρώθηκε/εκκρεμεί. Tap για επεξεργασία.")
            }
        }
        .navigationTitle("Εκκρεμότητες")
        .searchable(text: $searchText, prompt: "Αναζήτηση (όνομα/κινητό/ΑΦΜ)")
        .toolbar {
            Button {
                showAdd = true
            } label: {
                Image(systemName: "plus")
            }
        }
        .sheet(isPresented: $showAdd) {
            NavigationStack {
                PendingCreateView()
            }
        }
    }

    private func delete(_ indexSet: IndexSet) {
        for i in indexSet {
            let item = filtered[i]
            modelContext.delete(item)
        }
    }
}
