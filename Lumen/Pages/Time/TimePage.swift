//
//  TimePage.swift
//  Lumen
//
//  Created by Codex on 2026/4/30.
//

import SwiftUI

struct TimePage: View {
    let theme: Theme

    private static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()

    init(theme: Theme = .morning) {
        self.theme = theme
    }

    var body: some View {
        TimelineView(.periodic(from: .now, by: 1)) { timeline in
            let timeText = Self.timeFormatter.string(from: timeline.date)

            GeometryReader { proxy in
                let sidePadding = max(18, proxy.size.width * 0.08)
                let fontSize = min(proxy.size.width * 0.24, 200)

                ZStack {
                    SkyAndLakeView(theme: theme)
                        .ignoresSafeArea()

                    VStack(spacing: -fontSize * 0.08) {
                        GlassGlyphTimeText(text: timeText, fontSize: fontSize)
                            .padding(.horizontal, sidePadding)

                        ReflectedView(fontSize: fontSize) {
                            GlassGlyphTimeText(text: timeText, fontSize: fontSize)
                        }
                            .padding(.horizontal, sidePadding)
                    }
                    .offset(y: proxy.size.height * 0.07)
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview("Morning") {
    TimePage(theme: .morning)
        .ignoresSafeArea()
}

#Preview("Sunny Noon") {
    TimePage(theme: .sunnyNoon)
        .ignoresSafeArea()
}

#Preview("Rainy") {
    TimePage(theme: .rainy)
        .ignoresSafeArea()
}

#Preview("Night") {
    TimePage(theme: .night)
        .ignoresSafeArea()
}
