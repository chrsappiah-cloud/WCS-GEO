import SwiftUI

struct iPadRootView: View {
    @Environment(AppSession.self) private var session
    @State private var selectedTarget: TargetSummary?
    @State private var columnVisibility: NavigationSplitViewVisibility = .all

    private let sampleTargets = TargetSummary.demoList

    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            sidebar
        } content: {
            ProjectMapView(selectedTarget: $selectedTarget, targets: sampleTargets)
        } detail: {
            if let selectedTarget {
                TargetDetailView(target: selectedTarget)
            } else {
                ContentUnavailableView(
                    "Select a target",
                    systemImage: "scope",
                    description: Text("Choose a ranked target from the list or map.")
                )
            }
        }
        .navigationDestination(for: TargetSummary.self) { target in
            TargetDetailView(target: target)
        }
        .navigationSplitViewStyle(.balanced)
    }

    private var sidebar: some View {
        List(selection: $selectedTarget) {
            if let org = session.selectedOrganization {
                Section(org.name) {
                    ForEach(org.projects) { project in
                        Label(project.name, systemImage: "folder")
                    }
                }
            }

            Section("Ranked targets") {
                ForEach(sampleTargets) { target in
                    NavigationLink(value: target) {
                        TargetRow(target: target)
                    }
                }
            }
        }
        .navigationTitle("Projects")
    }
}

#Preview {
    iPadRootView()
        .environment({
            let s = AppSession()
            s.signIn()
            s.selectOrganization(.demo)
            return s
        }())
}
