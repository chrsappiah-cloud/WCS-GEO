//
//  WCS_GEOUITests.swift
//  WCS-GEOUITests
//

import XCTest

final class WCS_GEOUITests: XCTestCase {
    private let demoOrganizationName = "World Class Scholars — Demo"

    override func setUpWithError() throws {
        continueAfterFailure = false
        XCUIDevice.shared.orientation = .portrait
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
        app.tapOrganization(named: demoOrganizationName)

        app.assertMainNavigationVisible()
    }

    @MainActor
    func testTargetsListOpensDetailTabs() throws {
        let app = XCUIApplication()
        app.launchAndSignIn(organizationName: demoOrganizationName)

        app.openTargets()
        app.openTarget(named: "Boulder Ridge")

        XCTAssertTrue(app.navigationBars["Boulder Ridge"].waitForExistence(timeout: 5) || app.staticTexts["Prospectivity"].waitForExistence(timeout: 5))
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
        tapOrganization(named: organizationName)
        _ = tabBars.buttons["Dashboard"].waitForExistence(timeout: 3) || navigationBars["Projects"].waitForExistence(timeout: 3)
    }

    func tapOrganization(named organizationName: String) {
        let exactButton = buttons[organizationName]
        if exactButton.waitForExistence(timeout: 2) {
            exactButton.tap()
            return
        }

        let predicate = NSPredicate(format: "label BEGINSWITH %@", organizationName)
        let matchingButton = buttons.matching(predicate).firstMatch
        XCTAssertTrue(matchingButton.waitForExistence(timeout: 5))
        matchingButton.tap()
    }

    func assertMainNavigationVisible() {
        if tabBars.buttons["Dashboard"].waitForExistence(timeout: 5) {
            XCTAssertTrue(tabBars.buttons["Map"].exists)
            XCTAssertTrue(tabBars.buttons["Targets"].exists)
            XCTAssertTrue(tabBars.buttons["Field"].exists)
            XCTAssertTrue(tabBars.buttons["Settings"].exists)
            return
        }

        XCTAssertTrue(navigationBars["Projects"].waitForExistence(timeout: 5))
        XCTAssertTrue(staticTexts["Ranked targets"].exists || staticTexts["Boulder Ridge"].exists)
    }

    func openTargets() {
        let targetsTab = tabBars.buttons["Targets"]
        if targetsTab.waitForExistence(timeout: 3) {
            targetsTab.tap()
            return
        }

        XCTAssertTrue(navigationBars["Projects"].waitForExistence(timeout: 5))
    }

    func openTarget(named targetName: String) {
        let targetText = staticTexts[targetName]
        XCTAssertTrue(targetText.waitForExistence(timeout: 5))
        targetText.tap()
    }
}
