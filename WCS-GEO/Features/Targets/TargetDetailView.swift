import SwiftUI

struct TargetDetailView: View {
    let target: TargetSummary

    var body: some View {
        TabView {
            summaryTab
                .tabItem { Label("Summary", systemImage: "chart.bar") }

            driversTab
                .tabItem { Label("Drivers", systemImage: "list.bullet.rectangle") }

            narrativeTab
                .tabItem { Label("Narrative", systemImage: "text.book.closed") }

            evidenceTab
                .tabItem { Label("Evidence", systemImage: "doc.text.magnifyingglass") }
        }
        .navigationTitle(target.name)
        .navigationBarTitleDisplayMode(.inline)
        .preferredColorScheme(.dark)
    }

    private var summaryTab: some View {
        List {
            Section("Ranking") {
                LabeledContent("Prospectivity", value: String(format: "%.0f%%", target.score * 100))
                LabeledContent("Confidence", value: target.confidence)
                LabeledContent("Commodity", value: target.commodity)
                LabeledContent("Depth band", value: target.depthBand)
                LabeledContent("Status", value: target.decisionStatus)
            }
            Section("Model") {
                LabeledContent("Version", value: target.modelVersion)
                LabeledContent("Last rescore", value: target.lastRescore ?? "—")
                LabeledContent("Data completeness", value: String(format: "%.0f%%", target.dataCompleteness * 100))
            }
        }
    }

    private var driversTab: some View {
        List {
            Section("Top feature drivers") {
                ForEach(target.topDrivers) { driver in
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(driver.label)
                            Spacer()
                            Text(driver.source.rawValue)
                                .font(.caption)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(sourceColor(driver.source).opacity(0.15))
                                .foregroundStyle(sourceColor(driver.source))
                                .clipShape(Capsule())
                        }
                        ProgressView(value: driver.contribution, total: 0.3)
                            .tint(.orange)
                        Text(String(format: "Contribution %.0f%%", driver.contribution * 100))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 4)
                }
            }
            Section("Analogue deposits") {
                ForEach(target.analogDeposits, id: \.self) { analog in
                    Label(analog, systemImage: "mappin.and.ellipse")
                }
            }
        }
    }

    private var narrativeTab: some View {
        ScrollView {
            Text(target.narrative)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private var evidenceTab: some View {
        List {
            Section("Provenance") {
                Label("Public layers: tenements, magnetics, DEA indices", systemImage: "globe")
                Label("Private layers: company assays (demo)", systemImage: "lock.fill")
            }
            Section("Nearby drillholes") {
                Label("DDH-1042 — 1.2 km", systemImage: "circle.grid.cross")
                Label("RC-887 — 2.4 km", systemImage: "circle.grid.cross")
            }
        }
    }

    private func sourceColor(_ source: FeatureDriver.EvidenceSource) -> Color {
        switch source {
        case .publicData: .blue
        case .privateData: .purple
        case .blended: .orange
        }
    }
}

#Preview {
    NavigationStack {
        TargetDetailView(target: TargetSummary.demoList[0])
    }
}
