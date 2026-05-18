//
//  WCS_GEOTests.swift
//  WCS-GEOTests
//

import Testing
@testable import WCS_GEO

struct WCS_GEOTests {

    @Test func demoTargetsAreRanked() {
        let targets = TargetSummary.demoList
        #expect(targets.count == 3)
        #expect(targets[0].score >= targets[1].score)
        #expect(targets[1].score >= targets[2].score)
    }

    @Test func targetIncludesExplainabilityFields() {
        let target = TargetSummary.demoList[0]
        #expect(!target.modelVersion.isEmpty)
        #expect(!target.narrative.isEmpty)
        #expect(target.topDrivers.count >= 3)
        #expect(target.dataCompleteness > 0)
    }

    @Test func featureDriversIncludeProvenance() {
        let drivers = FeatureDriver.demoDrivers
        #expect(drivers.count == 5)
        #expect(drivers.contains { $0.source == .publicData })
        #expect(drivers.contains { $0.source == .privateData })
    }

    @Test func appConfigWithoutSecretsIsNotConfigured() {
        #expect(AppConfig.isSupabaseConfigured == false || AppConfig.supabaseURL != nil)
    }

    @Test func organizationDemoHasProject() {
        #expect(Organization.demo.projects.count >= 1)
        #expect(Organization.demo.projects[0].commodity == "Au")
    }

    @Test func sessionRequiresOrganizationAfterSignIn() {
        let session = AppSession()
        #expect(session.isReadyForMainApp == false)
        session.signIn()
        #expect(session.isSignedIn == true)
        #expect(session.isReadyForMainApp == false)
        session.selectOrganization(.demo)
        #expect(session.isReadyForMainApp == true)
    }
}
