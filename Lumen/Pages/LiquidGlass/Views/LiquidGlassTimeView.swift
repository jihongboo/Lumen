//
//  LiquidGlassTimeView.swift
//  Lumen
//
//  Created by Codex on 2026/4/29.
//

import SwiftUI

struct LiquidGlassTimeView: View {
    @Environment(WeatherLocationService.self) private var weatherAndLocation
    
    var body: some View {
        glassContent
            .accessibilityElement(children: .combine)
    }
    
    private var glassContent: some View {
        #if os(visionOS)
        timeAndWeatherContent
            .padding(.horizontal, 34)
            .padding(.vertical, 24)
            .background(.regularMaterial, in: .rect(cornerRadius: 34))
        #else
        GlassEffectContainer(spacing: 14) {
            timeAndWeatherContent
            .padding(.horizontal, 34)
            .padding(.vertical, 24)
            .glassEffect(.regular, in: .rect(cornerRadius: 34))
        }
        #endif
    }

    private var timeAndWeatherContent: some View {
        VStack(spacing: 18) {
            TimelineView(.periodic(from: .now, by: 1)) { timeline in
                VStack {
                    Text(timeline.date, format: .dateTime.hour(.twoDigits(amPM: .omitted)).minute(.twoDigits))
                        .font(.system(size: 76, weight: .semibold, design: .rounded))
                        .monospacedDigit()

                    Text(timeline.date, format: .dateTime.weekday(.wide).month(.wide).day())
                        .font(.system(.callout, design: .rounded, weight: .medium))
                        .foregroundStyle(.secondary)
                }
            }

            if let weather = weatherAndLocation.weatherInfo {
                LiquidGlassWeatherInfoView(weather: weather)
                    .padding(.top)
                    .overlay(alignment: .top) {
                        Divider()
                    }
            }
        }
    }
}

#Preview {
    LiquidGlassTimeView()
        .environment(WeatherLocationService.preview())
}
