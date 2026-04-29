//
//  LiquidGlassTimeView.swift
//  Lumen
//
//  Created by Codex on 2026/4/29.
//

import SwiftUI

struct LiquidGlassTimeView: View {
    let weather: WeatherInfo?

    var body: some View {
        TimelineView(.periodic(from: .now, by: 1)) { timeline in
            GlassEffectContainer(spacing: 14) {
                VStack(spacing: 18) {
                    VStack(spacing: 10) {
                        Text(timeline.date, format: .dateTime.hour(.twoDigits(amPM: .omitted)).minute(.twoDigits))
                            .font(.system(size: 76, weight: .semibold, design: .rounded))
                            .monospacedDigit()
                            .shadow(color: .black.opacity(0.22), radius: 18, x: 0, y: 10)

                        Text(timeline.date, format: .dateTime.weekday(.wide).month(.wide).day())
                            .font(.system(.callout, design: .rounded, weight: .medium))
                            .foregroundStyle(.secondary)
                    }

                    if let weather {
                        LiquidGlassWeatherInfoView(weather: weather)
                            .padding(.top)
                            .overlay(alignment: .top) {
                                Divider()
                            }
                    }
                }
                .padding(.horizontal, 34)
                .padding(.vertical, 24)
                .glassEffect(.regular, in: .rect(cornerRadius: 34))
            }
        }
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    ZStack {
        MeshGradientView()
            .ignoresSafeArea()

        LiquidGlassTimeView(weather: .preview)
    }
    .preferredColorScheme(.dark)
}
