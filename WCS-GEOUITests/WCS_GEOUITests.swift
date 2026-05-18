//
//  WCS_GEOUITests.swift
//  WCS-GEOUITests
//

import XCTest

final class WCS_GEOUITests: XCTestCase {
    private let demoOrganizationName = "World Class Scholars — Demo"

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testSignInShowsGoldBrandedWelcome() throws {
        let app = XCUIApplication()
        app.launch()

        XCTAssertTrue(app.staticTexts["WCS Mining AI"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.buttons["Continue with Supabase"].exists)
    }

    @MainActor
    func testSignInNavigatesToMainTabs() throws {
        let app = XCUIApplication()
        app.launch()

        app.buttons["Continue with Supabase"].tap()
        app.buttons[demoOrganizationName].tap()

        XCTAssertTrue(app.tabBars.buttons["Dashboard"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.tabBars.buttons["Map"].exists)
        XCTAssertTrue(app.tabBars.buttons["Targets"].exists)
        XCTAssertTrue(app.tabBars.buttons["Field"].exists)
        XCTAssertTrue(app.tabBars.buttons["Settings"].exists)
    }

    @MainActor
    func testTargetsListOpensDetailTabs() throws {
        let app = XCUIApplication()
        app.launchAndSignIn(organizationName: demoOrganizationName)

        app.tabBars.buttons["Targets"].tap()
        app.staticTexts["Boulder Ridge"].tap()

        XCTAssertTrue(app.navigationBars["Boulder Ridge"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.buttons["Summary"].exists)
        XCTAssertTrue(app.buttons["Drivers"].exists)
        XCTAssertTrue(app.buttons["Narrative"].exists)
        XCTAssertTrue(app.buttons["Evidence"].exists)
    }

    // Launch performance tracked in CI; skipped here for faster local/PR feedback.
    // @MainActor func testLaunchPerformance() throws { ... }
}

private extension XCUIApplication {
    func launchAndSignIn(organizationName: String) {
        launch()
        buttons["Continue with Supabase"].tap()
        buttons[organizationName].tap()
        _ = tabBars.buttons["Dashboard"].waitForExistence(timeout: 5)
    }
}
