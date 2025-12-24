import SwiftUI
import SwiftData

struct CategoriesView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \AppCategory.sortOrder) private var categories: [AppCategory]

    @State private var newName: String = ""

    var body: some View {
        List {
            Section {
                ForEach(categories) { c in
                    HStack {
                        Text(c.name)
                        Spacer()
                        Toggle("", isOn: Binding(
                            get: { c.isActive },
                            set: { c.isActive = $0 }
                        ))
                        .labelsHidden()
                    }
                }
                .onDelete(perform: delete)
                .onMove(perform: move)
            } header: {
                Text("Ενεργές κατηγορίες")
            } footer: {
                Text("Toggle OFF = κρύβει την κατηγορία (δεν εμφανίζεται στις φόρμες).")
            }

            Section {
                HStack {
                    TextField("Όνομα κατηγορίας", text: $newName)

                    Button("Προσθήκη") {
                        addCategory()
                    }
                    .disabled(newName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            } header: {
                Text("Προσθήκη νέας κατηγορίας")
            } footer: {
                Text("Swipe left → Delete την αφαιρεί τελείως. Με Edit → αλλάζεις σειρά.")
            }
        }
        .navigationTitle("Κατηγορίες")
        .toolbar { EditButton() }
    }

    private func addCategory() {
        let name = newName.trimmingCharacters(in: .whitespacesAndNewlines)
        let nextOrder = (categories.map(\.sortOrder).max() ?? -1) + 1
        modelContext.insert(AppCategory(name: name, isActive: true, sortOrder: nextOrder))
        newName = ""
    }

    private func delete(_ indexSet: IndexSet) {
        for i in indexSet {
            modelContext.delete(categories[i])
        }
    }

    private func move(from source: IndexSet, to destination: Int) {
        var updated = categories
        updated.move(fromOffsets: source, toOffset: destination)
        for (idx, item) in updated.enumerated() {
            item.sortOrder = idx
        }
    }
}
