//
//  TimePage.swift
//  Lumen
//
//  Created by Codex on 2026/4/30.
//

import SwiftUI

struct TimePage: View {
    let theme: Theme?
    let isAnimating: Bool

    private static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()

    init(theme: Theme? = nil, isAnimating: Bool = true) {
        self.theme = theme
        self.isAnimating = isAnimating
    }

    var body: some View {
        TimelineView(.periodic(from: .now, by: isAnimating ? 1 : Double.infinity)) { timeline in
            timeScene(date: timeline.date)
        }
    }

    private func timeScene(date: Date) -> some View {
        let timeText = Self.timeFormatter.string(from: date)

        return GeometryReader { proxy in
            let sidePadding = max(18, proxy.size.width * 0.08)
            let fontSize = min(proxy.size.width * 0.24, 200)

            SkyAndLakeView(theme: theme, isAnimating: isAnimating)
                .ignoresSafeArea()
                .overlay {
                    VStack(spacing: -fontSize * 0.08) {
                        GlassGlyphTimeText(text: timeText, fontSize: fontSize)
                            .padding(.horizontal, sidePadding)

                        ReflectedView(fontSize: fontSize, isAnimating: isAnimating) {
                            GlassGlyphTimeText(text: timeText, fontSize: fontSize)
                        }
                        .padding(.horizontal, sidePadding)
                    }
                    .offset(y: proxy.size.height * 0.07)
                }
        }
    }
}

#Preview("Morning") {
    TimePage()
        .ignoresSafeArea()
        .environment(WeatherLocationService(weatherInfo: WeatherInfo.preview))
}

#Preview("Sunny Noon") {
    TimePage(theme: .sunnyNoon)
        .ignoresSafeArea()
        .environment(WeatherLocationService(weatherInfo: WeatherInfo.preview))
}

#Preview("Rainy") {
    TimePage(theme: .rainy)
        .ignoresSafeArea()
        .environment(WeatherLocationService(weatherInfo: WeatherInfo.preview))
}

#Preview("Night") {
    TimePage(theme: .night)
        .ignoresSafeArea()
        .environment(WeatherLocationService(weatherInfo: WeatherInfo.preview))
}
