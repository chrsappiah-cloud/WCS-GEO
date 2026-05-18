import SwiftUI

struct ImportsSyncView: View {
    private let jobs: [ImportJob] = ImportJob.demoJobs

    var body: some View {
        List {
            Section("Import jobs") {
                ForEach(jobs) { job in
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(job.name)
                                .font(.headline)
                            Spacer()
                            Text(job.status.label)
                                .font(.caption)
                                .foregroundStyle(job.status.color)
                        }
                        Text(job.sourceType)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        if let detail = job.detail {
                            Text(detail)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }

            Section {
                Button("Request project rescore", systemImage: "arrow.triangle.2.circlepath") {}
                    .disabled(true)
            } footer: {
                Text("Rescoring runs asynchronously after imports complete (Phase 2).")
            }
        }
        .navigationTitle("Imports & Sync")
    }
}

struct ImportJob: Identifiable {
    let id: String
    let name: String
    let sourceType: String
    let status: JobStatus
    let detail: String?

    enum JobStatus {
        case pending, running, completed, failed

        var label: String {
            switch self {
            case .pending: "Pending"
            case .running: "Running"
            case .completed: "Completed"
            case .failed: "Failed"
            }
        }

        var color: Color {
            switch self {
            case .pending: .secondary
            case .running: .orange
            case .completed: .green
            case .failed: .red
            }
        }
    }

    static let demoJobs: [ImportJob] = [
        ImportJob(id: "1", name: "Assay CSV — Q1 program", sourceType: "Private · CSV", status: .completed, detail: "1,240 rows · 2026-05-08"),
        ImportJob(id: "2", name: "Collar survey export", sourceType: "Private · CSV", status: .running, detail: "Validating coordinates…"),
        ImportJob(id: "3", name: "Structures GeoJSON", sourceType: "Private · GeoJSON", status: .pending, detail: nil),
    ]
}

#Preview {
    NavigationStack {
        ImportsSyncView()
    }
}
