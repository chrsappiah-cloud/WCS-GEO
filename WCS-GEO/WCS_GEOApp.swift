//
//  WCS_GEOApp.swift
//  WCS-GEO
//

import SwiftUI

@main
struct WCS_GEOApp: App {
    @Environment(\.scenePhase) private var scenePhase
    @State private var session = AppSession()
    @State private var lifecycle = AppLifecycleOrchestrator()

    var body: some Scene {
        WindowGroup {
            AppShellView()
                .environment(session)
                .task {
                    await lifecycle.handle(.launched)
                }
        }
        .onChange(of: scenePhase) { _, newPhase in
            Task {
                switch newPhase {
                case .active:
                    lifecycle.updateAuth(session.isSignedIn)
                    await lifecycle.handle(.becameActive)
                case .inactive:
                    await lifecycle.handle(.willResignActive)
                case .background:
                    await lifecycle.handle(.enteredBackground)
                @unknown default:
                    break
                }
            }
        }
    }
}
