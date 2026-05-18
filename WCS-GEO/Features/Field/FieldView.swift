import SwiftUI

struct FieldView: View {
    @State private var note = ""
    @State private var observationType = "Outcrop"
    @State private var savedLocally = false

    private let observationTypes = ["Outcrop", "Soil", "Reject target", "Follow-up"]

    var body: some View {
        NavigationStack {
            Form {
                Section("Target context") {
                    Picker("Linked target", selection: .constant("T-001")) {
                        ForEach(TargetSummary.demoList) { target in
                            Text(target.name).tag(target.id)
                        }
                    }
                }

                Section("Observation") {
                    Picker("Type", selection: $observationType) {
                        ForEach(observationTypes, id: \.self) { Text($0) }
                    }
                    TextField("Field notes", text: $note, axis: .vertical)
                        .lineLimit(4 ... 8)
                    Label("Photo attachment (Phase 2)", systemImage: "camera")
                        .foregroundStyle(.secondary)
                }

                Section {
                    Button("Save locally (offline-ready)") {
                        savedLocally = true
                    }
                    .disabled(note.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }

                if savedLocally {
                    Section {
                        Label("Queued on device — background sync when online", systemImage: "icloud.and.arrow.up")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Field")
        }
    }
}

#Preview {
    FieldView()
}
