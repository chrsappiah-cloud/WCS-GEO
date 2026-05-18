import SwiftUI

struct SettingsView: View {
    @Environment(AppSession.self) private var session

    var body: some View {
        NavigationStack {
            List {
                if let org = session.selectedOrganization {
                    Section("Organization") {
                        LabeledContent("Name", value: org.name)
                        Button("Switch organization") {
                            session.selectedOrganization = nil
                        }
                    }
                }

                Section("Backend") {
                    LabeledContent("Supabase URL", value: AppConfig.supabaseURL?.absoluteString ?? "Not set")
                    LabeledContent("API key", value: AppConfig.supabaseAnonKey == nil ? "Not set" : "••••••••")
                }

                Section("Data") {
                    NavigationLink {
                        LayerManagerView()
                    } label: {
                        Label("Layer manager", systemImage: "square.stack.3d.up")
                    }
                    NavigationLink {
                        ImportsSyncView()
                    } label: {
                        Label("Imports & sync", systemImage: "tray.and.arrow.down")
                    }
                }

                Section("Offline") {
                    Label("Map packs", systemImage: "arrow.down.circle")
                    Label("Recent targets cache", systemImage: "internaldrive")
                }

                Section("About") {
                    LabeledContent("Product", value: "WCS Mining AI")
                    LabeledContent("Spec", value: "wcs-mining-ai-single-source-spec")
                }

                Section {
                    Button("Sign out", role: .destructive) {
                        session.signOut()
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .navigationTitle("Settings")
        }
        .wcsScreenBackground()
        .preferredColorScheme(.dark)
    }
}

#Preview {
    SettingsView()
        .environment(AppSession())
}
