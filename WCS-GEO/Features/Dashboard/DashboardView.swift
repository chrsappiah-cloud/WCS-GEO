import SwiftUI

struct DashboardView: View {
    @Environment(AppSession.self) private var session

    var body: some View {
        NavigationStack {
            List {
                if let org = session.selectedOrganization, let project = session.selectedProject {
                    Section("Portfolio") {
                        Label(org.name, systemImage: "building.2")
                        Label(project.name, systemImage: "folder")
                        Label("\(project.commodity) · \(project.region)", systemImage: "globe.asia.australia")
                        Label("\(TargetSummary.demoList.count) ranked targets", systemImage: "scope")
                    }
                }

                Section("Campaign") {
                    Label("3 targets under review", systemImage: "flag")
                    Label("Last batch rescore: 2026-05-10", systemImage: "clock")
                }

                Section("Status") {
                    backendStatusRow
                    NavigationLink {
                        ImportsSyncView()
                    } label: {
                        Label("Imports & sync", systemImage: "arrow.triangle.2.circlepath")
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .navigationTitle("Dashboard")
        }
        .wcsScreenBackground()
        .preferredColorScheme(.dark)
    }

    private var backendStatusRow: some View {
        HStack {
            Label("Supabase", systemImage: "server.rack")
            Spacer()
            if AppConfig.isSupabaseConfigured {
                Text("Configured")
                    .foregroundStyle(.green)
            } else {
                Text("Not configured")
                    .foregroundStyle(.orange)
            }
        }
    }
}

#Preview {
    DashboardView()
        .environment({
            let s = AppSession()
            s.signIn()
            s.selectOrganization(.demo)
            return s
        }())
}
