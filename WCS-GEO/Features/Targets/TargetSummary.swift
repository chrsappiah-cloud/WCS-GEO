import Foundation

struct TargetSummary: Identifiable, Hashable {
    let id: String
    let name: String
    let score: Double
    let commodity: String
    let confidence: String
    let depthBand: String
    let modelVersion: String
    let decisionStatus: String
    let dataCompleteness: Double
    let lastRescore: String?
    let topDrivers: [FeatureDriver]
    let analogDeposits: [String]
    let narrative: String

    static let demoList: [TargetSummary] = [
        TargetSummary(
            id: "T-001",
            name: "Boulder Ridge",
            score: 0.87,
            commodity: "Au",
            confidence: "High",
            depthBand: "0–150 m",
            modelVersion: "au-orogenic-v0.3",
            decisionStatus: "Under review",
            dataCompleteness: 0.82,
            lastRescore: "2026-05-10",
            topDrivers: FeatureDriver.demoDrivers,
            analogDeposits: ["Sunrise Dam", "Granny Smith"],
            narrative: "Ranks highly near a NE structural corridor with magnetic anomaly overlap, favorable host sequence, and nearby orogenic gold occurrences."
        ),
        TargetSummary(
            id: "T-002",
            name: "Eastern Shear",
            score: 0.79,
            commodity: "Au",
            confidence: "Medium",
            depthBand: "50–250 m",
            modelVersion: "au-orogenic-v0.3",
            decisionStatus: "Approved for follow-up",
            dataCompleteness: 0.74,
            lastRescore: "2026-05-10",
            topDrivers: Array(FeatureDriver.demoDrivers.prefix(4)),
            analogDeposits: ["Wallaby"],
            narrative: "Moderate prospectivity along interpreted shear with sparse drill support; alteration proxy elevated on satellite stack."
        ),
        TargetSummary(
            id: "T-003",
            name: "Granite Contact",
            score: 0.72,
            commodity: "Au",
            confidence: "Medium",
            depthBand: "0–100 m",
            modelVersion: "au-orogenic-v0.3",
            decisionStatus: "New",
            dataCompleteness: 0.68,
            lastRescore: "2026-05-10",
            topDrivers: Array(FeatureDriver.demoDrivers.prefix(3)),
            analogDeposits: ["Tropicana (style analog)"],
            narrative: "Granite-contact setting with pathfinder anomalies; lower drill density reduces confidence."
        ),
    ]
}

struct FeatureDriver: Identifiable, Hashable {
    let id: String
    let label: String
    let contribution: Double
    let source: EvidenceSource

    enum EvidenceSource: String, Hashable {
        case publicData = "Public"
        case privateData = "Private"
        case blended = "Blended"
    }

    static let demoDrivers: [FeatureDriver] = [
        FeatureDriver(id: "d1", label: "Proximity to structure", contribution: 0.24, source: .publicData),
        FeatureDriver(id: "d2", label: "Magnetic anomaly", contribution: 0.19, source: .publicData),
        FeatureDriver(id: "d3", label: "Alteration proxy (satellite)", contribution: 0.16, source: .publicData),
        FeatureDriver(id: "d4", label: "Analog deposit similarity", contribution: 0.14, source: .blended),
        FeatureDriver(id: "d5", label: "Drill-supported geochemistry", contribution: 0.11, source: .privateData),
    ]
}
