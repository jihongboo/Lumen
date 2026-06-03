//
//  LockScreenGlassTimeTheme.swift
//  Lumen
//
//  Created by 纪洪波 on 2026/4/30.
//

import SwiftUI

enum Theme: String, CaseIterable, Identifiable {
    case morning
    case sunnyNoon
    case rainy
    case night

    var id: String { rawValue }

    static func current(
        date: Date = .now,
        weather: WeatherInfo?,
        calendar: Calendar = .current
    ) -> Theme {
        if weather?.isRainy == true {
            return .rainy
        }

        let hour = calendar.component(.hour, from: date)

        switch hour {
        case 5..<12:
            return .morning
        case 12..<18:
            return .sunnyNoon
        default:
            return .night
        }
    }

    var title: String {
        switch self {
        case .morning: "Morning"
        case .sunnyNoon: "Sunny Noon"
        case .rainy: "Rainy"
        case .night: "Night"
        }
    }

    func meshColors(shimmer: Double, slowFlow: Double, counterFlow: Double) -> [Color] {
        switch self {
        case .morning:
            [
                Color(red: 0.1 + shimmer * 0.03, green: 0.13, blue: 0.28 + shimmer * 0.04),
                Color(red: 0.34 + slowFlow * 0.03, green: 0.32 + shimmer * 0.04, blue: 0.45 + shimmer * 0.05),
                Color(red: 0.12, green: 0.14, blue: 0.28),
                Color(red: 0.46 + counterFlow * 0.04, green: 0.39 + shimmer * 0.08, blue: 0.48 + shimmer * 0.04),
                Color(red: 0.82 + shimmer * 0.08, green: 0.62 + shimmer * 0.1, blue: 0.58 + counterFlow * 0.04),
                Color(red: 0.36, green: 0.36 + shimmer * 0.03, blue: 0.5 + slowFlow * 0.04),
                Color(red: 0.1, green: 0.12, blue: 0.22),
                Color(red: 0.28 + shimmer * 0.04, green: 0.26 + shimmer * 0.03, blue: 0.35 + shimmer * 0.04),
                Color(red: 0.08, green: 0.1, blue: 0.2)
            ]
        case .sunnyNoon:
            [
                Color(red: 0.2, green: 0.45 + shimmer * 0.04, blue: 0.78 + shimmer * 0.04),
                Color(red: 0.39 + slowFlow * 0.03, green: 0.66 + shimmer * 0.04, blue: 0.94),
                Color(red: 0.16, green: 0.4, blue: 0.78 + shimmer * 0.03),
                Color(red: 0.56 + counterFlow * 0.03, green: 0.76, blue: 0.94),
                Color(red: 0.96, green: 0.78 + shimmer * 0.08, blue: 0.5 + counterFlow * 0.03),
                Color(red: 0.38, green: 0.62 + shimmer * 0.05, blue: 0.9 + slowFlow * 0.03),
                Color(red: 0.08, green: 0.24, blue: 0.48),
                Color(red: 0.25 + shimmer * 0.04, green: 0.48 + shimmer * 0.03, blue: 0.72),
                Color(red: 0.06, green: 0.18, blue: 0.38)
            ]
        case .rainy:
            [
                Color(red: 0.06, green: 0.09, blue: 0.16 + shimmer * 0.03),
                Color(red: 0.17 + slowFlow * 0.02, green: 0.26 + shimmer * 0.03, blue: 0.36 + shimmer * 0.04),
                Color(red: 0.09, green: 0.13, blue: 0.22),
                Color(red: 0.24 + counterFlow * 0.03, green: 0.34 + shimmer * 0.04, blue: 0.43),
                Color(red: 0.45 + shimmer * 0.04, green: 0.57 + shimmer * 0.05, blue: 0.63 + counterFlow * 0.03),
                Color(red: 0.15, green: 0.22 + shimmer * 0.03, blue: 0.33 + slowFlow * 0.03),
                Color(red: 0.04, green: 0.07, blue: 0.13),
                Color(red: 0.13 + shimmer * 0.03, green: 0.19 + shimmer * 0.03, blue: 0.28 + shimmer * 0.04),
                Color(red: 0.03, green: 0.05, blue: 0.11)
            ]
        case .night:
            [
                Color(red: 0.02, green: 0.03, blue: 0.1 + shimmer * 0.02),
                Color(red: 0.07 + slowFlow * 0.02, green: 0.09 + shimmer * 0.02, blue: 0.22 + shimmer * 0.04),
                Color(red: 0.02, green: 0.03, blue: 0.11),
                Color(red: 0.11 + counterFlow * 0.02, green: 0.1 + shimmer * 0.03, blue: 0.25 + shimmer * 0.03),
                Color(red: 0.31 + shimmer * 0.05, green: 0.32 + shimmer * 0.05, blue: 0.56 + counterFlow * 0.03),
                Color(red: 0.06, green: 0.08 + shimmer * 0.02, blue: 0.19 + slowFlow * 0.03),
                Color(red: 0.01, green: 0.02, blue: 0.07),
                Color(red: 0.05 + shimmer * 0.02, green: 0.05 + shimmer * 0.02, blue: 0.15 + shimmer * 0.03),
                Color(red: 0.0, green: 0.01, blue: 0.05)
            ]
        }
    }

    func glowColors(shimmer: Double) -> [Color] {
        switch self {
        case .morning:
            [.white.opacity(0.34 + shimmer * 0.16), .pink.opacity(0.22 + shimmer * 0.08), .clear]
        case .sunnyNoon:
            [.white.opacity(0.38 + shimmer * 0.18), .yellow.opacity(0.24 + shimmer * 0.08), .clear]
        case .rainy:
            [.white.opacity(0.22 + shimmer * 0.08), .cyan.opacity(0.18 + shimmer * 0.05), .clear]
        case .night:
            [.white.opacity(0.2 + shimmer * 0.1), .indigo.opacity(0.2 + shimmer * 0.06), .clear]
        }
    }

    var glowCenter: UnitPoint {
        switch self {
        case .morning: UnitPoint(x: 0.5, y: 0.4)
        case .sunnyNoon: UnitPoint(x: 0.5, y: 0.34)
        case .rainy: UnitPoint(x: 0.46, y: 0.48)
        case .night: UnitPoint(x: 0.54, y: 0.36)
        }
    }

    var glowOpacity: Double {
        switch self {
        case .morning: 0.2
        case .sunnyNoon: 0.28
        case .rainy: 0.18
        case .night: 0.18
        }
    }

    var bandAccent: Color {
        switch self {
        case .morning: .pink
        case .sunnyNoon: .yellow
        case .rainy: .cyan
        case .night: .indigo
        }
    }

    var mistColor: Color {
        switch self {
        case .morning: .white
        case .sunnyNoon: Color(red: 1.0, green: 0.92, blue: 0.78)
        case .rainy: Color(red: 0.74, green: 0.9, blue: 1.0)
        case .night: Color(red: 0.72, green: 0.78, blue: 1.0)
        }
    }

    var overlayColors: [Color] {
        switch self {
        case .morning:
            [.black.opacity(0.2), .clear, .white.opacity(0.08), .black.opacity(0.28)]
        case .sunnyNoon:
            [.white.opacity(0.04), .clear, .white.opacity(0.12), .black.opacity(0.18)]
        case .rainy:
            [.black.opacity(0.3), .clear, .white.opacity(0.06), .black.opacity(0.34)]
        case .night:
            [.black.opacity(0.44), .clear, .white.opacity(0.04), .black.opacity(0.46)]
        }
    }

    func ambientMeshColor(bright: Double, shadow: Double, flow: Double) -> Color {
        switch self {
        case .morning:
            Color(
                red: clamped(0.11 + bright * 0.56 + flow * 0.08 - shadow * 0.02),
                green: clamped(0.14 + bright * 0.42 + flow * 0.04 - shadow * 0.03),
                blue: clamped(0.24 + bright * 0.32 + flow * 0.05 - shadow * 0.05)
            )
        case .sunnyNoon:
            Color(
                red: clamped(0.22 + bright * 0.66 + flow * 0.06 - shadow * 0.03),
                green: clamped(0.52 + bright * 0.34 + flow * 0.06 - shadow * 0.03),
                blue: clamped(0.78 + bright * 0.08 + flow * 0.04 - shadow * 0.08)
            )
        case .rainy:
            Color(
                red: clamped(0.03 + bright * 0.22 - shadow * 0.03),
                green: clamped(0.07 + bright * 0.32 + flow * 0.03 - shadow * 0.04),
                blue: clamped(0.13 + bright * 0.52 + flow * 0.08 - shadow * 0.06)
            )
        case .night:
            Color(
                red: clamped(0.01 + bright * 0.16 + flow * 0.02 - shadow * 0.02),
                green: clamped(0.02 + bright * 0.18 + flow * 0.02 - shadow * 0.03),
                blue: clamped(0.08 + bright * 0.42 + flow * 0.07 - shadow * 0.05)
            )
        }
    }

    private func clamped(_ value: Double) -> Double {
        min(max(value, 0), 1)
    }
}

private extension WeatherInfo {
    var isRainy: Bool {
        let rainySymbols = [
            "cloud.rain",
            "cloud.heavyrain",
            "cloud.drizzle",
            "cloud.sun.rain",
            "cloud.moon.rain",
            "cloud.bolt.rain"
        ]

        if rainySymbols.contains(where: symbol.contains) {
            return true
        }

        let normalizedCondition = condition.lowercased()
        return [
            "rain",
            "drizzle",
            "shower",
            "storm",
            "thunder",
            "雷雨",
            "雨",
            "阵雨"
        ].contains { normalizedCondition.contains($0) }
    }
}
