//
//  MeshGradientView.swift
//  Lumen
//
//  Created by Codex on 2026/4/29.
//

import SwiftUI

struct MeshGradientView: View {
    let defaultTheme: Theme?
    let isAnimating: Bool
    let frameInterval: TimeInterval
    
    @Environment(WeatherLocationService.self) private var weatherAndLocation
    private var theme: Theme { defaultTheme ?? Theme.current(date: Date(), weather: weatherAndLocation.weatherInfo) }

    init(theme defaultTheme: Theme? = nil, isAnimating: Bool = true, frameInterval: TimeInterval = 1.0 / 24.0) {
        self.defaultTheme = defaultTheme
        self.isAnimating = isAnimating
        self.frameInterval = frameInterval
    }

    var body: some View {
        TimelineView(.periodic(from: .now, by: isAnimating ? frameInterval : Double.infinity)) { timeline in
            MeshGradient(
                width: 4,
                height: 4,
                points: meshPoints(at: timeline.date.timeIntervalSinceReferenceDate),
                colors: meshColors(at: timeline.date.timeIntervalSinceReferenceDate)
            )
        }
    }

    private func meshPoints(at time: TimeInterval) -> [SIMD2<Float>] {
        let phase = Float(time * 0.38)

        return [
            [0, 0],
            [0.33 + wave(phase, 0.08, 0.4), 0],
            [0.67 + wave(phase, 0.08, 2.1), 0],
            [1, 0],
            [0, 0.34 + wave(phase, 0.1, 0.8)],
            [0.34 + wave(phase, 0.16, 2.4), 0.34 + wave(phase, 0.14, 4.1)],
            [0.66 + wave(phase, 0.16, 5.2), 0.34 + wave(phase, 0.14, 1.7)],
            [1, 0.34 + wave(phase, 0.1, 3.3)],
            [0, 0.66 + wave(phase, 0.1, 2.2)],
            [0.34 + wave(phase, 0.16, 5.6), 0.66 + wave(phase, 0.14, 2.8)],
            [0.66 + wave(phase, 0.16, 1.2), 0.66 + wave(phase, 0.14, 5.1)],
            [1, 0.66 + wave(phase, 0.1, 4.7)],
            [0, 1],
            [0.33 + wave(phase, 0.08, 4.8), 1],
            [0.67 + wave(phase, 0.08, 1.5), 1],
            [1, 1]
        ]
    }

    private func wave(_ phase: Float, _ amplitude: Float, _ offset: Float) -> Float {
        sin(phase + offset) * amplitude
    }

    private func meshColors(at time: TimeInterval) -> [Color] {
        let phase = time * 0.48
        let brightCenter = CGPoint(
            x: 0.5 + 0.38 * sin(phase),
            y: 0.5 + 0.32 * cos(phase * 0.82)
        )
        let darkCenter = CGPoint(
            x: 0.5 + 0.42 * sin(phase + .pi),
            y: 0.5 + 0.36 * cos(phase * 0.76 + 1.4)
        )

        return colorGrid.map { point in
            let bright = influence(from: point, to: brightCenter, radius: 0.68)
            let shadow = influence(from: point, to: darkCenter, radius: 0.56)
            let flow = (sin(phase * 1.4 + Double(point.x * 5 + point.y * 3)) + 1) * 0.5

            return theme.ambientMeshColor(bright: bright, shadow: shadow, flow: flow)
        }
    }

    private var colorGrid: [CGPoint] {
        [
            CGPoint(x: 0, y: 0),
            CGPoint(x: 0.33, y: 0),
            CGPoint(x: 0.67, y: 0),
            CGPoint(x: 1, y: 0),
            CGPoint(x: 0, y: 0.33),
            CGPoint(x: 0.33, y: 0.33),
            CGPoint(x: 0.67, y: 0.33),
            CGPoint(x: 1, y: 0.33),
            CGPoint(x: 0, y: 0.67),
            CGPoint(x: 0.33, y: 0.67),
            CGPoint(x: 0.67, y: 0.67),
            CGPoint(x: 1, y: 0.67),
            CGPoint(x: 0, y: 1),
            CGPoint(x: 0.33, y: 1),
            CGPoint(x: 0.67, y: 1),
            CGPoint(x: 1, y: 1)
        ]
    }

    private func influence(from point: CGPoint, to center: CGPoint, radius: Double) -> Double {
        let distance = hypot(point.x - center.x, point.y - center.y)
        return max(0, 1 - distance / radius)
    }
}

#Preview("Theme Meshes") {
    TabView {
        ForEach(Theme.allCases) { theme in
            MeshGradientView(theme: theme)
                .ignoresSafeArea()
                .overlay(alignment: .bottomLeading) {
                    Text(theme.title)
                        .font(.headline)
                        .foregroundStyle(.white)
                        .padding()
                }
                .tag(theme)
        }
    }
}
