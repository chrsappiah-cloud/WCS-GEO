import SwiftUI

struct LayerManagerView: View {
    @State private var layers: [MapLayerToggle] = MapLayerToggle.defaults

    var body: some View {
        List {
            Section("Vector layers") {
                ForEach(vectorLayerIndices, id: \.self) { index in
                    layerRow(at: index)
                }
            }
            Section("Raster / satellite") {
                ForEach(rasterLayerIndices, id: \.self) { index in
                    layerRow(at: index)
                }
            }
        }
        .navigationTitle("Layers")
    }

    private var vectorLayerIndices: [Int] {
        layers.indices.filter { !layers[$0].isRaster }
    }

    private var rasterLayerIndices: [Int] {
        layers.indices.filter { layers[$0].isRaster }
    }

    private func layerRow(at index: Int) -> some View {
        Toggle(isOn: $layers[index].isEnabled) {
            VStack(alignment: .leading, spacing: 2) {
                Text(layers[index].name)
                Text(layers[index].source)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

struct MapLayerToggle: Identifiable {
    let id: String
    let name: String
    let source: String
    let isRaster: Bool
    var isEnabled: Bool

    static let defaults: [MapLayerToggle] = [
        MapLayerToggle(id: "tenements", name: "Tenements", source: "State portal", isRaster: false, isEnabled: true),
        MapLayerToggle(id: "occurrences", name: "Mineral occurrences", source: "Geoscience Australia", isRaster: false, isEnabled: true),
        MapLayerToggle(id: "drillholes", name: "Drillholes", source: "National catalogue", isRaster: false, isEnabled: false),
        MapLayerToggle(id: "geology", name: "Geology units", source: "1:500k", isRaster: false, isEnabled: false),
        MapLayerToggle(id: "mag", name: "Magnetics (TMI)", source: "Public geophysics", isRaster: true, isEnabled: true),
        MapLayerToggle(id: "dea", name: "DEA alteration index", source: "Digital Earth Australia", isRaster: true, isEnabled: false),
        MapLayerToggle(id: "targets", name: "AI-ranked targets", source: "WCS model v0.3", isRaster: false, isEnabled: true),
    ]
}

#Preview {
    NavigationStack {
        LayerManagerView()
    }
}
