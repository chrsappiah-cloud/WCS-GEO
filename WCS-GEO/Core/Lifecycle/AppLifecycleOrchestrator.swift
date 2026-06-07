import Foundation
import OSLog
import UIKit

enum AppLifecycleEvent: Equatable {
    case launched
    case becameActive
    case willResignActive
    case enteredBackground
    case willEnterForeground
    case willTerminate
    case memoryWarning
}

struct AppStateSnapshot: Equatable {
    var lastSyncAt: Date?
    var hasUnsavedChanges = false
    var activeTaskCount = 0
    var isUserAuthenticated = false
    var lastErrorMessage: String?
}

protocol PersistenceCoordinating {
    func saveIfNeeded() async throws
}

protocol SyncCoordinating {
    func refreshIfStale(since lastSyncAt: Date?) async throws
    func cancelNonCriticalTasks()
}

protocol BackgroundTaskCoordinating {
    func begin(name: String) -> UUID
    func end(_ id: UUID?)
}

@MainActor
@Observable
final class AppLifecycleOrchestrator {
    private(set) var state = AppStateSnapshot()

    private let persistence: PersistenceCoordinating
    private let sync: SyncCoordinating
    private let backgroundTasks: BackgroundTaskCoordinating
    private let logger = Logger(subsystem: "com.worldclassscholars.wcsgeo", category: "lifecycle")

    init(
        persistence: PersistenceCoordinating = AppPersistenceCoordinator(),
        sync: SyncCoordinating = AppSyncCoordinator(),
        backgroundTasks: BackgroundTaskCoordinating = AppBackgroundTaskCoordinator()
    ) {
        self.persistence = persistence
        self.sync = sync
        self.backgroundTasks = backgroundTasks
    }

    func handle(_ event: AppLifecycleEvent) async {
        logger.info("Lifecycle event: \(String(describing: event))")
        switch event {
        case .launched:
            await onLaunch()
        case .becameActive:
            await onBecomeActive()
        case .willResignActive:
            sync.cancelNonCriticalTasks()
        case .enteredBackground:
            await onEnteredBackground()
        case .willEnterForeground:
            logger.info("App will enter foreground")
        case .willTerminate:
            await persistBeforeTermination()
        case .memoryWarning:
            sync.cancelNonCriticalTasks()
            logger.warning("Memory warning received")
        }
    }

    func markDirty() {
        state.hasUnsavedChanges = true
    }

    func updateAuth(_ isAuthenticated: Bool) {
        state.isUserAuthenticated = isAuthenticated
    }

    private func onLaunch() async {
        logger.info("Cold launch started")
        guard state.isUserAuthenticated else { return }
        await refreshIfNeeded(reason: "launch")
    }

    private func onBecomeActive() async {
        logger.info("App became active")
        guard state.isUserAuthenticated else { return }
        await refreshIfNeeded(reason: "resume")
    }

    private func onEnteredBackground() async {
        logger.info("App entered background")
        let taskID = backgroundTasks.begin(name: "save-and-flush")
        state.activeTaskCount += 1
        defer {
            backgroundTasks.end(taskID)
            state.activeTaskCount = max(0, state.activeTaskCount - 1)
        }

        do {
            try await persistence.saveIfNeeded()
            state.hasUnsavedChanges = false
            state.lastErrorMessage = nil
            logger.info("Background save succeeded")
        } catch {
            state.lastErrorMessage = error.localizedDescription
            logger.error("Background save failed: \(error.localizedDescription)")
        }
    }

    private func persistBeforeTermination() async {
        do {
            try await persistence.saveIfNeeded()
            state.hasUnsavedChanges = false
            state.lastErrorMessage = nil
            logger.info("Termination save succeeded")
        } catch {
            state.lastErrorMessage = error.localizedDescription
            logger.error("Termination save failed: \(error.localizedDescription)")
        }
    }

    private func refreshIfNeeded(reason: String) async {
        do {
            try await sync.refreshIfStale(since: state.lastSyncAt)
            state.lastSyncAt = Date()
            state.lastErrorMessage = nil
            logger.info("Refresh completed, reason: \(reason)")
        } catch {
            state.lastErrorMessage = error.localizedDescription
            logger.error("Refresh failed, reason: \(reason), error: \(error.localizedDescription)")
        }
    }
}

struct AppPersistenceCoordinator: PersistenceCoordinating {
    func saveIfNeeded() async throws {
        // WCS-GEO currently keeps demo/session state in memory. This coordinator is
        // the lifecycle seam for future SwiftData, file, or secure-cache persistence.
    }
}

struct AppSyncCoordinator: SyncCoordinating {
    func refreshIfStale(since lastSyncAt: Date?) async throws {
        // Remote refresh work is intentionally opt-in here so launch and resume stay
        // fast until a concrete data source needs lifecycle-driven sync.
    }

    func cancelNonCriticalTasks() {
        // Add cancellable imports, map tile prefetches, or analytics flushes here.
    }
}

struct AppBackgroundTaskCoordinator: BackgroundTaskCoordinating {
    func begin(name: String) -> UUID {
        UUID()
    }

    func end(_ id: UUID?) {}
}
