import SwiftUI

struct OrganizationPickerView: View {
    @Environment(AppSession.self) private var session

    var body: some View {
        ZStack {
            SparkleOverlay().opacity(0.35)
            List {
                Section {
                    Text("Choose your mining company tenant")
                        .font(.subheadline)
                        .foregroundStyle(WCSTheme.diamond)
                        .listRowBackground(Color.clear)
                }
                Section("Organizations") {
                    Button {
                        session.selectOrganization(.demo)
                    } label: {
                        HStack(spacing: 14) {
                            Image(systemName: "building.2.fill")
                                .font(.title2)
                                .foregroundStyle(WCSTheme.goldGradient)
                            VStack(alignment: .leading, spacing: 4) {
                                Text(Organization.demo.name)
                                    .font(.headline)
                                    .foregroundStyle(.white)
                                Text("1 project · Gold · Western Australia")
                                    .font(.subheadline)
                                    .foregroundStyle(WCSTheme.diamond.opacity(0.8))
                            }
                        }
                        .padding(.vertical, 6)
                    }
                    .listRowBackground(WCSTheme.charcoal)
                }
            }
            .scrollContentBackground(.hidden)
        }
        .navigationTitle("Organization")
        .wcsScreenBackground()
        .preferredColorScheme(.dark)
    }
}

#Preview {
    NavigationStack {
        OrganizationPickerView()
    }
    .environment(AppSession())
}
