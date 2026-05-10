//
//  LiquidGlassOrbFieldView.swift
//  Lumen
//
//  Created by Codex on 2026/4/30.
//

import SwiftUI

struct LiquidGlassOrbFieldView: View {
    private let orbs: [Orb] = [
        Orb(id: 0, diameterRatio: 0.38, origin: CGPoint(x: 0.24, y: 0.28), velocity: CGVector(dx: 18, dy: 24), tint: .clear.opacity(0.24)),
        Orb(id: 1, diameterRatio: 0.27, origin: CGPoint(x: 0.68, y: 0.18), velocity: CGVector(dx: -26, dy: 16), tint: .clear.opacity(0.22)),
        Orb(id: 2, diameterRatio: 0.21, origin: CGPoint(x: 0.78, y: 0.62), velocity: CGVector(dx: -18, dy: -28), tint: .clear.opacity(0.18)),
        Orb(id: 3, diameterRatio: 0.16, origin: CGPoint(x: 0.36, y: 0.72), velocity: CGVector(dx: 32, dy: -18), tint: .clear.opacity(0.2)),
        Orb(id: 4, diameterRatio: 0.12, origin: CGPoint(x: 0.18, y: 0.58), velocity: CGVector(dx: 24, dy: -34), tint: .clear.opacity(0.18)),
        Orb(id: 5, diameterRatio: 0.09, origin: CGPoint(x: 0.86, y: 0.36), velocity: CGVector(dx: -34, dy: 26), tint: .clear.opacity(0.22))
    ]

    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size

            TimelineView(.animation) { timeline in
                let time = timeline.date.timeIntervalSinceReferenceDate

                ZStack {
                    MeshGradientView()
                        .ignoresSafeArea()
                        .overlay {
                            LinearGradient(
                                colors: [
                                    .white.opacity(0.11),
                                    .clear,
                                    .cyan.opacity(0.06)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                            .ignoresSafeArea()
                        }

                    GlassEffectContainer(spacing: 18) {
                        ForEach(orbs) { orb in
                            let diameter = orb.diameter(in: size)
                            let position = orb.position(in: size, at: time)

                            Circle()
                                .fill(.clear)
                                .overlay {
                                    Circle()
                                        .stroke(.white.opacity(0.2), lineWidth: 1)
                                }
                                .frame(width: diameter, height: diameter)
                                .shadow(color: orb.tint.opacity(0.42), radius: diameter * 0.32)
                                .glassEffect(.regular.tint(orb.tint), in: .circle)
                                .position(position)
                        }
                    }
                }
            }
        }
    }
}

private struct Orb: Identifiable {
    let id: Int
    let diameterRatio: CGFloat
    let origin: CGPoint
    let velocity: CGVector
    let tint: Color

    func diameter(in size: CGSize) -> CGFloat {
        min(size.width, size.height) * diameterRatio
    }

    func position(in size: CGSize, at time: TimeInterval) -> CGPoint {
        let elapsed = CGFloat(time)
        let diameter = diameter(in: size)
        let radius = diameter / 2
        let bounds = CGRect(
            x: radius,
            y: radius,
            width: max(1, size.width - diameter),
            height: max(1, size.height - diameter)
        )
        let start = CGPoint(
            x: bounds.minX + bounds.width * origin.x,
            y: bounds.minY + bounds.height * origin.y
        )

        return CGPoint(
            x: reflectedValue(start.x + velocity.dx * elapsed, minimum: bounds.minX, maximum: bounds.maxX),
            y: reflectedValue(start.y + velocity.dy * elapsed, minimum: bounds.minY, maximum: bounds.maxY)
        )
    }

    private func reflectedValue(_ value: CGFloat, minimum: CGFloat, maximum: CGFloat) -> CGFloat {
        let distance = maximum - minimum

        guard distance > 0 else {
            return minimum
        }

        let cycle = distance * 2
        let shifted = (value - minimum).truncatingRemainder(dividingBy: cycle)
        let normalized = shifted >= 0 ? shifted : shifted + cycle

        if normalized <= distance {
            return minimum + normalized
        } else {
            return maximum - (normalized - distance)
        }
    }
}

#Preview {
    LiquidGlassOrbFieldView()
}
