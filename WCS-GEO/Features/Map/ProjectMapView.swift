import MapKit
import SwiftUI

struct ProjectMapView: View {
    @Binding var selectedTarget: TargetSummary?
    var targets: [TargetSummary] = TargetSummary.demoList

    @State private var position: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: -30.75, longitude: 121.47),
            span: MKCoordinateSpan(latitudeDelta: 2.5, longitudeDelta: 2.5)
        )
    )
    @State private var sheetTarget: TargetSummary?

    init(selectedTarget: Binding<TargetSummary?> = .constant(nil), targets: [TargetSummary] = TargetSummary.demoList) {
        _selectedTarget = selectedTarget
        self.targets = targets
    }

    var body: some View {
        NavigationStack {
            Map(position: $position) {
                UserAnnotation()
                ForEach(targets) { target in
                    Annotation(target.name, coordinate: coordinate(for: target)) {
                        Button {
                            sheetTarget = target
                            selectedTarget = target
                        } label: {
                            Image(systemName: "scope")
                                .padding(6)
                                .background(.orange)
                                .foregroundStyle(.white)
                                .clipShape(Circle())
                        }
                    }
                }
            }
            .mapStyle(.standard(elevation: .realistic))
            .navigationTitle("Map")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        LayerManagerView()
                    } label: {
                        Label("Layers", systemImage: "square.stack.3d.up")
                    }
                }
            }
            .safeAreaInset(edge: .bottom) {
                mapLegend
            }
            .sheet(item: $sheetTarget) { target in
                NavigationStack {
                    TargetDetailView(target: target)
                        .toolbar {
                            ToolbarItem(placement: .topBarTrailing) {
                                Button("Done") { sheetTarget = nil }
                            }
                        }
                }
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
            }
        }
    }

    private var mapLegend: some View {
        HStack(spacing: 12) {
            legendChip("Tenements", color: .blue)
            legendChip("Targets", color: .orange)
            legendChip("Drillholes", color: .gray)
        }
        .font(.caption)
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(.ultraThinMaterial)
    }

    private func legendChip(_ title: String, color: Color) -> some View {
        HStack(spacing: 4) {
            Circle().fill(color).frame(width: 8, height: 8)
            Text(title)
        }
    }

    private func coordinate(for target: TargetSummary) -> CLLocationCoordinate2D {
        let offset = Double(target.id.hashValue % 100) / 5000
        return CLLocationCoordinate2D(latitude: -30.75 + offset, longitude: 121.47 + offset)
    }
}

#Preview {
    ProjectMapView()
}
