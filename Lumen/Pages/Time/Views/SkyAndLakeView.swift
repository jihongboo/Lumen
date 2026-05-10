//
//  LockScreenHorizonBackground.swift
//  Lumen
//
//  Created by Codex on 2026/4/30.
//

import SwiftUI

struct SkyAndLakeView: View {
    let defaultTheme: Theme?
    let isAnimating: Bool
    let frameInterval: TimeInterval

    @Environment(WeatherLocationService.self) private var weatherAndLocation
    private var theme: Theme { defaultTheme ?? Theme.current(date: Date(), weather: weatherAndLocation.weatherInfo) }
    
    init(
        theme defaultTheme: Theme? = nil,
        isAnimating: Bool = true,
        frameInterval: TimeInterval = 1.0 / 24.0
    ) {
        self.defaultTheme = defaultTheme
        self.isAnimating = isAnimating
        self.frameInterval = frameInterval
    }

    var body: some View {
        TimelineView(.periodic(from: .now, by: isAnimating ? frameInterval : Double.infinity)) { timeline in
            scene(time: timeline.date.timeIntervalSinceReferenceDate)
        }
    }

    private func scene(time: TimeInterval) -> some View {
        let shimmer = (sin(time * 0.72) + 1) * 0.5
        let slowFlow = sin(time * 0.32)
        let counterFlow = cos(time * 0.24 + 1.8)
        let drift = sin(time * 0.18)
        let glowCenter = UnitPoint(
            x: theme.glowCenter.x + drift * 0.08,
            y: theme.glowCenter.y + counterFlow * 0.05
        )

        return ZStack {
            MeshGradient(
                width: 3,
                height: 3,
                points: [
                    [0, 0],
                    [0.5 + Float(slowFlow * 0.16), 0],
                    [1, 0],
                    [0, 0.54 + Float(counterFlow * 0.13)],
                    [0.5 + Float(sin(time * 0.26 + 1.4) * 0.22), 0.48 + Float(cos(time * 0.22) * 0.16)],
                    [1, 0.52 + Float(sin(time * 0.21 + 2.0) * 0.12)],
                    [0, 1],
                    [0.5 + Float(cos(time * 0.28) * 0.16), 1],
                    [1, 1]
                ],
                colors: theme.meshColors(shimmer: shimmer, slowFlow: slowFlow, counterFlow: counterFlow)
            )
            .saturation(1.16 + shimmer * 0.12)

            RadialGradient(
                colors: theme.glowColors(shimmer: shimmer),
                center: glowCenter,
                startRadius: 20,
                endRadius: 360
            )
            .blur(radius: 6)
            .opacity(theme.glowOpacity + shimmer * 0.08)

            FlowingLightBands(time: time, accent: theme.bandAccent)
                .opacity(0.92)

            LinearGradient(
                colors: theme.overlayColors,
                startPoint: .top,
                endPoint: .bottom
            )

            HorizonMist(time: time, color: theme.mistColor)
                .opacity(0.72)
        }
    }
}

#Preview {
    SkyAndLakeView(theme: .morning)
        .ignoresSafeArea()
}
