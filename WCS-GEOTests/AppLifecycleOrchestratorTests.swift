import Foundation
import Testing
@testable import WCS_GEO

@MainActor
struct AppLifecycleOrchestratorTests {
    @Test func backgroundEventSavesChangesAndEndsTask() async {
        let persistence = MockPersistenceCoordinator()
        let sync = MockSyncCoordinator()
        let background = MockBackgroundTaskCoordinator()
        let orchestrator = AppLifecycleOrchestrator(
            persistence: persistence,
            sync: sync,
            backgroundTasks: background
        )

        orchestrator.markDirty()
        await orchestrator.handle(.enteredBackground)

        #expect(persistence.saveCallCount == 1)
        #expect(background.beginCallCount == 1)
        #expect(background.endCallCount == 1)
        #expect(orchestrator.state.hasUnsavedChanges == false)
        #expect(orchestrator.state.activeTaskCount == 0)
    }

    @Test func resumeRefreshesWhenAuthenticated() async {
        let persistence = MockPersistenceCoordinator()
        let sync = MockSyncCoordinator()
        let background = MockBackgroundTaskCoordinator()
        let orchestrator = AppLifecycleOrchestrator(
            persistence: persistence,
            sync: sync,
            backgroundTasks: background
        )

        orchestrator.updateAuth(true)
        await orchestrator.handle(.becameActive)

        #expect(sync.refreshCallCount == 1)
        #expect(orchestrator.state.lastSyncAt != nil)
    }

    @Test func launchDoesNotRefreshWhenSignedOut() async {
        let persistence = MockPersistenceCoordinator()
        let sync = MockSyncCoordinator()
        let background = MockBackgroundTaskCoordinator()
        let orchestrator = AppLifecycleOrchestrator(
            persistence: persistence,
            sync: sync,
            backgroundTasks: background
        )

        await orchestrator.handle(.launched)

        #expect(sync.refreshCallCount == 0)
        #expect(orchestrator.state.lastSyncAt == nil)
    }

    @Test func persistenceFailureKeepsDirtyStateAndEndsTask() async {
        let persistence = MockPersistenceCoordinator()
        persistence.errorToThrow = LifecycleTestError.persistenceFailed
        let sync = MockSyncCoordinator()
        let background = MockBackgroundTaskCoordinator()
        let orchestrator = AppLifecycleOrchestrator(
            persistence: persistence,
            sync: sync,
            backgroundTasks: background
        )

        orchestrator.markDirty()
        await orchestrator.handle(.enteredBackground)

        #expect(persistence.saveCallCount == 1)
        #expect(background.endCallCount == 1)
        #expect(orchestrator.state.hasUnsavedChanges == true)
        #expect(orchestrator.state.lastErrorMessage != nil)
    }

    @Test func memoryWarningCancelsNonCriticalWork() async {
        let persistence = MockPersistenceCoordinator()
        let sync = MockSyncCoordinator()
        let background = MockBackgroundTaskCoordinator()
        let orchestrator = AppLifecycleOrchestrator(
            persistence: persistence,
            sync: sync,
            backgroundTasks: background
        )

        await orchestrator.handle(.memoryWarning)

        #expect(sync.cancelCallCount == 1)
    }
}

private enum LifecycleTestError: Error {
    case persistenceFailed
}

private final class MockPersistenceCoordinator: PersistenceCoordinating {
    var saveCallCount = 0
    var errorToThrow: Error?

    func saveIfNeeded() async throws {
        saveCallCount += 1
        if let errorToThrow {
            throw errorToThrow
        }
    }
}

private final class MockSyncCoordinator: SyncCoordinating {
    var refreshCallCount = 0
    var cancelCallCount = 0

    func refreshIfStale(since lastSyncAt: Date?) async throws {
        refreshCallCount += 1
    }

    func cancelNonCriticalTasks() {
        cancelCallCount += 1
    }
}

private final class MockBackgroundTaskCoordinator: BackgroundTaskCoordinating {
    var beginCallCount = 0
    var endCallCount = 0

    func begin(name: String) -> UUID {
        beginCallCount += 1
        return UUID()
    }

    func end(_ id: UUID?) {
        endCallCount += 1
    }
}
