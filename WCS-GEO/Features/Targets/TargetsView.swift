import SwiftUI

struct TargetsView: View {
    private let sampleTargets = TargetSummary.demoList

    var body: some View {
        NavigationStack {
            List(sampleTargets) { target in
                NavigationLink {
                    TargetDetailView(target: target)
                } label: {
                    TargetRow(target: target)
                }
            }
            .scrollContentBackground(.hidden)
            .navigationTitle("Targets")
        }
        .wcsScreenBackground()
        .preferredColorScheme(.dark)
    }
}

struct TargetRow: View {
    let target: TargetSummary

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(target.name)
                    .font(.headline)
                Spacer()
                Text(target.decisionStatus)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            HStack {
                Text(target.commodity)
                Text("·")
                Text(String(format: "Score %.0f%%", target.score * 100))
                Text("·")
                Text(target.confidence)
            }
            .font(.subheadline)
            .foregroundStyle(.secondary)
        }
        .padding(.vertical, 2)
    }
}

#Preview {
    TargetsView()
}
