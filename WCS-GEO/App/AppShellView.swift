import SwiftUI

struct AppShellView: View {
    @Environment(AppSession.self) private var session
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    var body: some View {
        Group {
            if !session.isSignedIn {
                NavigationStack {
                    SignInView()
                }
            } else if session.selectedOrganization == nil {
                NavigationStack {
                    OrganizationPickerView()
                }
            } else if horizontalSizeClass == .regular {
                iPadRootView()
            } else {
                MainTabView()
            }
        }
    }
}

#Preview {
    AppShellView()
        .environment(AppSession())
}
