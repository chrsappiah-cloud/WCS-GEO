import SwiftUI

struct MainTabView: View {
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(red: 0.06, green: 0.06, blue: 0.08, alpha: 1)
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some View {
        TabView {
            DashboardView()
                .tabItem {
                    Label("Dashboard", systemImage: "chart.bar.doc.horizontal.fill")
                }

            ProjectMapView()
                .tabItem {
                    Label("Map", systemImage: "map.fill")
                }

            TargetsView()
                .tabItem {
                    Label("Targets", systemImage: "scope")
                }

            FieldView()
                .tabItem {
                    Label("Field", systemImage: "binoculars.fill")
                }

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
        }
        .tint(WCSTheme.gold)
        .preferredColorScheme(.dark)
    }
}

#Preview {
    MainTabView()
        .environment({
            let s = AppSession()
            s.signIn()
            s.selectOrganization(.demo)
            return s
        }())
}
