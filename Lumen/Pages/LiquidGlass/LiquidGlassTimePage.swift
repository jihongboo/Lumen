//
//  LiquidGlassTimePage.swift
//  Lumen
//
//  Created by 纪洪波 on 2026/4/30.
//

import SwiftUI

enum Background: String, CaseIterable, Identifiable {
    var id: Background { self }
    
    case meshGradient
    case smoke
    case fractalClouds
    case liquidChrome
    case plasma
    case starfield
    case animatedLoop
    case dots
    
    var title: LocalizedStringKey {
        switch self {
        case .meshGradient:
            "Gradient"
        case .smoke:
            "Smoke"
        case .fractalClouds:
            "Clouds"
        case .liquidChrome:
            "Chrome"
        case .plasma:
            "Plasma"
        case .starfield:
            "Stars"
        case .animatedLoop:
            "Loop"
        case .dots:
            "Dots"
        }
    }
}

struct LiquidGlassTimePage: View {
    let background: Background
    
    @Environment(WeatherLocationService.self) private var weatherAndLocation
    private var theme: Theme {
        Theme.current(weather: weatherAndLocation.weatherInfo)
    }
    
    var body: some View {
        backgroundView
            .overlay {
                LiquidGlassTimeView()
            }
    }
    
    var backgroundView: some View {
        ZStack {
            switch background {
            case .meshGradient:
                MeshGradientView(theme: theme)
            case .smoke:
                SWInkSmoke(theme: theme)
            case .fractalClouds:
                let style = theme.fractalCloudsStyle
                SWFractalClouds(
                    skyColor: style.skyColor,
                    cloudColor: style.cloudColor,
                    warmTint: style.warmTint,
                    warmth: style.warmth,
                    coverage: style.coverage
                )
            case .liquidChrome:
                let style = theme.liquidChromeStyle
                SWLiquidChrome(
                    shadow: style.shadow,
                    silver: style.silver,
                    highlight: style.highlight,
                    tint: style.tint,
                    specStrength: style.specStrength,
                    tintStrength: style.tintStrength
                )
            case .plasma:
                let style = theme.plasmaStyle
                SWPlasma(
                    style: style.style,
                    c1: style.c1,
                    c2: style.c2,
                    c3: style.c3,
                    c4: style.c4,
                    c5: style.c5,
                    intensity: style.intensity,
                    distortion: style.distortion
                )
            case .starfield:
                let style = theme.starfieldStyle
                SWStarfield(
                    starColor: style.starColor,
                    background: style.background,
                    speed: style.speed,
                    layers: style.layers,
                    density: style.density,
                    twinkleAmount: style.twinkleAmount
                )
            case .animatedLoop:
                let style = theme.animatedLoopStyle
                SWAnimatedLoop(
                    style: style.style,
                    color1: style.color1,
                    color2: style.color2,
                    color3: style.color3,
                    background: style.background,
                    scale: style.scale
                )
            case .dots:
                let style = theme.dotsStyle
                SWDots(
                    style: style.style,
                    tint: style.tint,
                    background: style.background,
                    speed: style.speed,
                    brightness: style.brightness,
                    gridDensity: style.gridDensity,
                    horizon: style.horizon
                )
            }
        }
        .ignoresSafeArea()
        .transition(.opacity)
        .animation(.smooth, value: background)
    }
}

#Preview {
    TabView {
        ForEach(Background.allCases) { background in
            LiquidGlassTimePage(background: background)
                .tag(background)
        }
    }
    .environment(WeatherLocationService.preview())
}

private struct FractalCloudsThemeStyle {
    let skyColor: Color
    let cloudColor: Color
    let warmTint: Color
    let warmth: Float
    let coverage: Float
}

private struct LiquidChromeThemeStyle {
    let shadow: Color
    let silver: Color
    let highlight: Color
    let tint: Color
    let specStrength: Float
    let tintStrength: Float
}

private struct PlasmaThemeStyle {
    let style: SWPlasmaStyle
    let c1: Color
    let c2: Color
    let c3: Color
    let c4: Color
    let c5: Color
    let intensity: Float
    let distortion: Float
}

private struct StarfieldThemeStyle {
    let starColor: Color
    let background: Color
    let speed: Float
    let layers: Int
    let density: Float
    let twinkleAmount: Float
}

private struct AnimatedLoopThemeStyle {
    let style: SWAnimatedLoopStyle
    let color1: Color
    let color2: Color
    let color3: Color
    let background: Color
    let scale: Float
}

private struct DotsThemeStyle {
    let style: SWDotsStyle
    let tint: Color
    let background: Color
    let speed: Float
    let brightness: Float
    let gridDensity: Float
    let horizon: Float
}

private extension Theme {
    var fractalCloudsStyle: FractalCloudsThemeStyle {
        switch self {
        case .morning:
            FractalCloudsThemeStyle(
                skyColor: Color(red: 0.23, green: 0.26, blue: 0.46),
                cloudColor: Color(red: 1.0, green: 0.76, blue: 0.68),
                warmTint: Color(red: 0.56, green: 0.22, blue: 0.12),
                warmth: 0.6,
                coverage: 0.08
            )
        case .sunnyNoon:
            FractalCloudsThemeStyle(
                skyColor: Color(red: 0.18, green: 0.42, blue: 0.72),
                cloudColor: Color(red: 0.92, green: 0.96, blue: 1.0),
                warmTint: Color(red: 0.52, green: 0.34, blue: 0.08),
                warmth: 0.34,
                coverage: -0.02
            )
        case .rainy:
            FractalCloudsThemeStyle(
                skyColor: Color(red: 0.05, green: 0.09, blue: 0.16),
                cloudColor: Color(red: 0.46, green: 0.58, blue: 0.66),
                warmTint: Color(red: 0.05, green: 0.10, blue: 0.14),
                warmth: 0.18,
                coverage: 0.16
            )
        case .night:
            FractalCloudsThemeStyle(
                skyColor: Color(red: 0.01, green: 0.02, blue: 0.09),
                cloudColor: Color(red: 0.20, green: 0.26, blue: 0.46),
                warmTint: Color(red: 0.06, green: 0.04, blue: 0.14),
                warmth: 0.28,
                coverage: 0.04
            )
        }
    }

    var liquidChromeStyle: LiquidChromeThemeStyle {
        switch self {
        case .morning:
            LiquidChromeThemeStyle(
                shadow: Color(red: 0.10, green: 0.06, blue: 0.12),
                silver: Color(red: 0.50, green: 0.38, blue: 0.46),
                highlight: Color(red: 1.0, green: 0.82, blue: 0.72),
                tint: Color(red: 0.82, green: 0.38, blue: 0.32),
                specStrength: 0.36,
                tintStrength: 0.20
            )
        case .sunnyNoon:
            LiquidChromeThemeStyle(
                shadow: Color(red: 0.02, green: 0.10, blue: 0.20),
                silver: Color(red: 0.30, green: 0.48, blue: 0.64),
                highlight: Color(red: 0.92, green: 0.98, blue: 1.0),
                tint: Color(red: 0.98, green: 0.64, blue: 0.28),
                specStrength: 0.42,
                tintStrength: 0.16
            )
        case .rainy:
            LiquidChromeThemeStyle(
                shadow: Color(red: 0.02, green: 0.03, blue: 0.06),
                silver: Color(red: 0.18, green: 0.26, blue: 0.32),
                highlight: Color(red: 0.58, green: 0.78, blue: 0.86),
                tint: Color(red: 0.12, green: 0.34, blue: 0.42),
                specStrength: 0.28,
                tintStrength: 0.22
            )
        case .night:
            LiquidChromeThemeStyle(
                shadow: Color(red: 0.01, green: 0.01, blue: 0.05),
                silver: Color(red: 0.10, green: 0.12, blue: 0.24),
                highlight: Color(red: 0.48, green: 0.54, blue: 0.82),
                tint: Color(red: 0.18, green: 0.22, blue: 0.56),
                specStrength: 0.32,
                tintStrength: 0.22
            )
        }
    }

    var plasmaStyle: PlasmaThemeStyle {
        switch self {
        case .morning:
            PlasmaThemeStyle(
                style: .lilac,
                c1: Color(red: 0.10, green: 0.04, blue: 0.18),
                c2: Color(red: 0.42, green: 0.24, blue: 0.44),
                c3: Color(red: 0.78, green: 0.38, blue: 0.46),
                c4: Color(red: 1.0, green: 0.62, blue: 0.48),
                c5: Color(red: 1.0, green: 0.82, blue: 0.70),
                intensity: 1.05,
                distortion: 0.9
            )
        case .sunnyNoon:
            PlasmaThemeStyle(
                style: .solar,
                c1: Color(red: 0.02, green: 0.12, blue: 0.30),
                c2: Color(red: 0.08, green: 0.34, blue: 0.62),
                c3: Color(red: 0.20, green: 0.58, blue: 0.90),
                c4: Color(red: 0.96, green: 0.68, blue: 0.30),
                c5: Color(red: 1.0, green: 0.88, blue: 0.58),
                intensity: 1.0,
                distortion: 0.82
            )
        case .rainy:
            PlasmaThemeStyle(
                style: .spectrum,
                c1: Color(red: 0.02, green: 0.04, blue: 0.10),
                c2: Color(red: 0.06, green: 0.16, blue: 0.26),
                c3: Color(red: 0.14, green: 0.30, blue: 0.40),
                c4: Color(red: 0.34, green: 0.52, blue: 0.58),
                c5: Color(red: 0.70, green: 0.86, blue: 0.92),
                intensity: 0.9,
                distortion: 1.1
            )
        case .night:
            PlasmaThemeStyle(
                style: .prism,
                c1: Color(red: 0.01, green: 0.01, blue: 0.08),
                c2: Color(red: 0.05, green: 0.08, blue: 0.28),
                c3: Color(red: 0.16, green: 0.16, blue: 0.48),
                c4: Color(red: 0.36, green: 0.24, blue: 0.70),
                c5: Color(red: 0.58, green: 0.62, blue: 0.92),
                intensity: 0.96,
                distortion: 1.05
            )
        }
    }

    var starfieldStyle: StarfieldThemeStyle {
        switch self {
        case .morning:
            StarfieldThemeStyle(
                starColor: Color(red: 1.0, green: 0.76, blue: 0.62),
                background: Color(red: 0.10, green: 0.07, blue: 0.18),
                speed: 0.24,
                layers: 4,
                density: 0.22,
                twinkleAmount: 0.22
            )
        case .sunnyNoon:
            StarfieldThemeStyle(
                starColor: Color(red: 1.0, green: 0.90, blue: 0.58),
                background: Color(red: 0.08, green: 0.24, blue: 0.42),
                speed: 0.18,
                layers: 3,
                density: 0.18,
                twinkleAmount: 0.16
            )
        case .rainy:
            StarfieldThemeStyle(
                starColor: Color(red: 0.70, green: 0.90, blue: 1.0),
                background: Color(red: 0.02, green: 0.04, blue: 0.08),
                speed: 0.28,
                layers: 5,
                density: 0.34,
                twinkleAmount: 0.32
            )
        case .night:
            StarfieldThemeStyle(
                starColor: Color(red: 0.82, green: 0.88, blue: 1.0),
                background: Color(red: 0.0, green: 0.01, blue: 0.05),
                speed: 0.35,
                layers: 6,
                density: 0.46,
                twinkleAmount: 0.48
            )
        }
    }

    var animatedLoopStyle: AnimatedLoopThemeStyle {
        switch self {
        case .morning:
            AnimatedLoopThemeStyle(
                style: .neon,
                color1: Color(red: 1.0, green: 0.38, blue: 0.34),
                color2: Color(red: 1.0, green: 0.72, blue: 0.42),
                color3: Color(red: 0.70, green: 0.42, blue: 0.76),
                background: Color(red: 0.06, green: 0.04, blue: 0.12),
                scale: 1.16
            )
        case .sunnyNoon:
            AnimatedLoopThemeStyle(
                style: .warp,
                color1: Color(red: 0.18, green: 0.72, blue: 1.0),
                color2: Color(red: 1.0, green: 0.82, blue: 0.30),
                color3: Color(red: 0.44, green: 0.90, blue: 0.92),
                background: Color(red: 0.02, green: 0.10, blue: 0.22),
                scale: 1.08
            )
        case .rainy:
            AnimatedLoopThemeStyle(
                style: .diamond,
                color1: Color(red: 0.34, green: 0.76, blue: 0.92),
                color2: Color(red: 0.50, green: 0.60, blue: 0.78),
                color3: Color(red: 0.70, green: 0.88, blue: 0.94),
                background: Color(red: 0.02, green: 0.03, blue: 0.07),
                scale: 1.2
            )
        case .night:
            AnimatedLoopThemeStyle(
                style: .neon,
                color1: Color(red: 0.20, green: 0.76, blue: 1.0),
                color2: Color(red: 0.54, green: 0.34, blue: 1.0),
                color3: Color(red: 1.0, green: 0.32, blue: 0.78),
                background: Color(red: 0.0, green: 0.0, blue: 0.04),
                scale: 1.2
            )
        }
    }

    var dotsStyle: DotsThemeStyle {
        switch self {
        case .morning:
            DotsThemeStyle(
                style: .flow,
                tint: Color(red: 1.0, green: 0.66, blue: 0.54),
                background: Color(red: 0.08, green: 0.05, blue: 0.12),
                speed: 0.55,
                brightness: 1.05,
                gridDensity: 0.85,
                horizon: -0.26
            )
        case .sunnyNoon:
            DotsThemeStyle(
                style: .ocean,
                tint: Color(red: 0.78, green: 0.94, blue: 1.0),
                background: Color(red: 0.02, green: 0.16, blue: 0.30),
                speed: 0.65,
                brightness: 1.2,
                gridDensity: 0.9,
                horizon: -0.18
            )
        case .rainy:
            DotsThemeStyle(
                style: .standing,
                tint: Color(red: 0.56, green: 0.84, blue: 0.92),
                background: Color(red: 0.02, green: 0.04, blue: 0.08),
                speed: 0.48,
                brightness: 0.92,
                gridDensity: 0.82,
                horizon: -0.22
            )
        case .night:
            DotsThemeStyle(
                style: .snake,
                tint: Color(red: 0.50, green: 0.72, blue: 1.0),
                background: Color(red: 0.0, green: 0.01, blue: 0.05),
                speed: 0.7,
                brightness: 1.08,
                gridDensity: 0.95,
                horizon: -0.2
            )
        }
    }
}
