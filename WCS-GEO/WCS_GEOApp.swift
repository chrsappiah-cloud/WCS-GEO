//
//  WCS_GEOApp.swift
//  WCS-GEO
//

import SwiftUI

@main
struct WCS_GEOApp: App {
    @State private var session = AppSession()

    var body: some Scene {
        WindowGroup {
            AppShellView()
                .environment(session)
        }
    }
}
