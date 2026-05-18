import SwiftUI

struct SignInView: View {
    @Environment(AppSession.self) private var session

    var body: some View {
        ZStack {
            SparkleOverlay().opacity(0.5)

            VStack(spacing: 28) {
                ZStack {
                    Circle()
                        .fill(WCSTheme.goldGradient)
                        .frame(width: 100, height: 100)
                        .shadow(color: WCSTheme.gold.opacity(0.5), radius: 16)
                    Image(systemName: "diamond.fill")
                        .font(.system(size: 44))
                        .foregroundStyle(WCSTheme.obsidian)
                        .symbolEffect(.pulse, options: .repeating)
                }

                VStack(spacing: 10) {
                    Text("WCS Mining AI")
                        .wcsGoldTitle()
                    Text("Sparkling intelligence for gold & critical minerals")
                        .font(.subheadline)
                        .foregroundStyle(WCSTheme.diamond)
                        .multilineTextAlignment(.center)
                }

                Button {
                    session.signIn()
                } label: {
                    Label("Continue with Supabase", systemImage: "sparkles")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(WCSTheme.gold)
                .controlSize(.large)

                Text("Premium exploration copilot · Field-ready · Explainable AI")
                    .font(.caption)
                    .foregroundStyle(WCSTheme.diamond.opacity(0.75))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .padding(32)
            .wcsCard()
            .padding()
        }
        .wcsScreenBackground()
        .preferredColorScheme(.dark)
    }
}

#Preview {
    SignInView()
        .environment(AppSession())
}
