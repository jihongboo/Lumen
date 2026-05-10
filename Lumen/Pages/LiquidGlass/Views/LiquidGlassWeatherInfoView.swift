//
//  LiquidGlassWeatherInfoView.swift
//  Lumen
//
//  Created by 纪洪波 on 2026/4/30.
//

import SwiftUI

struct LiquidGlassWeatherInfoView: View {
    let weather: WeatherInfo

    var body: some View {
        weatherSummary
    }

    private var weatherSummary: some View {
        HStack(spacing: 14) {
            Image(systemName: weather.symbol)
                .font(.system(size: 34, weight: .semibold))
                .symbolRenderingMode(.multicolor)

            VStack(alignment: .leading, spacing: 3) {
                Text(weather.location)
                    .font(.system(.subheadline, design: .rounded, weight: .semibold))
                    .foregroundStyle(.primary)
                    .lineLimit(1)

                Text(weather.condition)
                    .font(.system(.caption, design: .rounded, weight: .medium))
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }

            Text(weather.temperature)
                .font(.system(size: 42, weight: .thin, design: .rounded))
                .monospacedDigit()
                .foregroundStyle(.primary)
                .lineLimit(1)
        }
    }
}

struct WeatherInfo: Equatable, Sendable {
    var location: String
    var condition: String
    var symbol: String
    var temperature: String
    var feelsLike: String
    var humidity: String
    var wind: String

    static let preview = WeatherInfo(
        location: "San Francisco",
        condition: "Partly Cloudy",
        symbol: "cloud.sun.fill",
        temperature: "18°",
        feelsLike: "17°",
        humidity: "72%",
        wind: "3 m/s"
    )
}
