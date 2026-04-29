//
//  LiquidGlassTimePage.swift
//  Lumen
//
//  Created by 纪洪波 on 2026/4/30.
//

import SwiftUI

struct LiquidGlassTimePage: View {
    @Environment(WeatherLocationService.self) private var weatherAndLocation

    var body: some View {
        TimelineView(.periodic(from: .now, by: 60)) { timeline in
            let theme = Theme.current(date: timeline.date, weather: weatherAndLocation.weatherInfo)

            ZStack {
                MeshGradientView(theme: theme)
                    .ignoresSafeArea()

                LiquidGlassTimeView(weather: weatherAndLocation.weatherInfo)
            }
        }
    }
}

#Preview {
    LiquidGlassTimePage()
        .environment(WeatherLocationService.preview())
}
