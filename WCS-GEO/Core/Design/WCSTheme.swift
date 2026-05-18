import SwiftUI

enum WCSTheme {
    static let goldLight = Color(red: 0.98, green: 0.84, blue: 0.45)
    static let gold = Color(red: 0.85, green: 0.65, blue: 0.22)
    static let goldDeep = Color(red: 0.62, green: 0.45, blue: 0.12)
    static let diamond = Color(red: 0.88, green: 0.95, blue: 1.0)
    static let diamondAccent = Color(red: 0.72, green: 0.88, blue: 0.98)
    static let obsidian = Color(red: 0.06, green: 0.06, blue: 0.08)
    static let charcoal = Color(red: 0.12, green: 0.11, blue: 0.14)

    static var goldGradient: LinearGradient {
        LinearGradient(
            colors: [goldLight, gold, goldDeep],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    static var diamondGradient: LinearGradient {
        LinearGradient(
            colors: [diamond, diamondAccent.opacity(0.6), diamond.opacity(0.9)],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    static var heroBackground: LinearGradient {
        LinearGradient(
            colors: [obsidian, charcoal, obsidian],
            startPoint: .top,
            endPoint: .bottom
        )
    }
}

struct SparkleOverlay: View {
    private let seeds: [(x: CGFloat, y: CGFloat, gold: Bool)] = (0 ..< 24).map { index in
        let fi = CGFloat(index)
        return (
            x: (sin(fi * 1.7) * 0.5 + 0.5),
            y: (cos(fi * 2.1) * 0.5 + 0.5),
            gold: index % 3 != 0
        )
    }

    var body: some View {
        GeometryReader { geometry in
            Canvas { context, size in
                for seed in seeds {
                    let radius = CGFloat(1.5 + (seed.x * 2).truncatingRemainder(dividingBy: 2))
                    let rect = CGRect(
                        x: seed.x * size.width - radius,
                        y: seed.y * size.height - radius,
                        width: radius * 2,
                        height: radius * 2
                    )
                    context.fill(
                        Path(ellipseIn: rect),
                        with: .color(seed.gold ? WCSTheme.goldLight.opacity(0.85) : WCSTheme.diamond)
                    )
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .allowsHitTesting(false)
    }
}

struct WCSCardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(WCSTheme.charcoal.opacity(0.85))
                    .overlay {
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .strokeBorder(WCSTheme.gold.opacity(0.65), lineWidth: 1)
                    }
            }
    }
}

extension View {
    func wcsCard() -> some View { modifier(WCSCardStyle()) }

    func wcsScreenBackground() -> some View {
        background {
            ZStack {
                WCSTheme.heroBackground.ignoresSafeArea()
                SparkleOverlay().opacity(0.35)
            }
        }
    }

    func wcsGoldTitle() -> some View {
        font(.largeTitle.bold())
            .foregroundStyle(WCSTheme.goldGradient)
    }
}
