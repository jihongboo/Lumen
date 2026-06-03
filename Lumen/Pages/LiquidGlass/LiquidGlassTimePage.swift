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
    case auroraVeil
    case kaleidoscopeBloom
    case silkVortex
    
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
        case .auroraVeil:
            "Aurora"
        case .kaleidoscopeBloom:
            "Bloom"
        case .silkVortex:
            "Silk"
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
            case .auroraVeil:
                let style = theme.auroraVeilStyle
                SWAuroraVeil(
                    base: style.base,
                    ribbon1: style.ribbon1,
                    ribbon2: style.ribbon2,
                    glow: style.glow,
                    speed: style.speed,
                    scale: style.scale,
                    intensity: style.intensity
                )
            case .kaleidoscopeBloom:
                let style = theme.kaleidoscopeBloomStyle
                SWKaleidoscopeBloom(
                    background: style.background,
                    petal1: style.petal1,
                    petal2: style.petal2,
                    highlight: style.highlight,
                    speed: style.speed,
                    petals: style.petals,
                    bloom: style.bloom
                )
            case .silkVortex:
                let style = theme.silkVortexStyle
                SWSilkVortex(
                    shadow: style.shadow,
                    silk1: style.silk1,
                    silk2: style.silk2,
                    glint: style.glint,
                    speed: style.speed,
                    swirl: style.swirl,
                    contrast: style.contrast
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

private struct AuroraVeilThemeStyle {
    let base: Color
    let ribbon1: Color
    let ribbon2: Color
    let glow: Color
    let speed: Float
    let scale: Float
    let intensity: Float
}

private struct KaleidoscopeBloomThemeStyle {
    let background: Color
    let petal1: Color
    let petal2: Color
    let highlight: Color
    let speed: Float
    let petals: Float
    let bloom: Float
}

private struct SilkVortexThemeStyle {
    let shadow: Color
    let silk1: Color
    let silk2: Color
    let glint: Color
    let speed: Float
    let swirl: Float
    let contrast: Float
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

    var auroraVeilStyle: AuroraVeilThemeStyle {
        switch self {
        case .morning:
            AuroraVeilThemeStyle(
                base: Color(red: 0.07, green: 0.05, blue: 0.14),
                ribbon1: Color(red: 1.0, green: 0.52, blue: 0.48),
                ribbon2: Color(red: 0.66, green: 0.44, blue: 0.86),
                glow: Color(red: 1.0, green: 0.78, blue: 0.58),
                speed: 0.22,
                scale: 1.02,
                intensity: 0.92
            )
        case .sunnyNoon:
            AuroraVeilThemeStyle(
                base: Color(red: 0.02, green: 0.12, blue: 0.30),
                ribbon1: Color(red: 0.22, green: 0.84, blue: 1.0),
                ribbon2: Color(red: 1.0, green: 0.72, blue: 0.28),
                glow: Color(red: 0.80, green: 0.96, blue: 1.0),
                speed: 0.18,
                scale: 0.96,
                intensity: 0.82
            )
        case .rainy:
            AuroraVeilThemeStyle(
                base: Color(red: 0.02, green: 0.04, blue: 0.08),
                ribbon1: Color(red: 0.32, green: 0.74, blue: 0.86),
                ribbon2: Color(red: 0.40, green: 0.48, blue: 0.70),
                glow: Color(red: 0.62, green: 0.88, blue: 0.96),
                speed: 0.26,
                scale: 1.08,
                intensity: 0.78
            )
        case .night:
            AuroraVeilThemeStyle(
                base: Color(red: 0.0, green: 0.01, blue: 0.05),
                ribbon1: Color(red: 0.16, green: 0.92, blue: 0.68),
                ribbon2: Color(red: 0.54, green: 0.28, blue: 1.0),
                glow: Color(red: 0.44, green: 0.86, blue: 1.0),
                speed: 0.32,
                scale: 1.0,
                intensity: 1.08
            )
        }
    }

    var kaleidoscopeBloomStyle: KaleidoscopeBloomThemeStyle {
        switch self {
        case .morning:
            KaleidoscopeBloomThemeStyle(
                background: Color(red: 0.08, green: 0.04, blue: 0.10),
                petal1: Color(red: 1.0, green: 0.42, blue: 0.42),
                petal2: Color(red: 1.0, green: 0.68, blue: 0.36),
                highlight: Color(red: 1.0, green: 0.86, blue: 0.72),
                speed: 0.20,
                petals: 7,
                bloom: 0.92
            )
        case .sunnyNoon:
            KaleidoscopeBloomThemeStyle(
                background: Color(red: 0.02, green: 0.10, blue: 0.22),
                petal1: Color(red: 0.12, green: 0.64, blue: 1.0),
                petal2: Color(red: 0.96, green: 0.74, blue: 0.22),
                highlight: Color(red: 0.92, green: 0.98, blue: 1.0),
                speed: 0.18,
                petals: 8,
                bloom: 0.86
            )
        case .rainy:
            KaleidoscopeBloomThemeStyle(
                background: Color(red: 0.02, green: 0.03, blue: 0.07),
                petal1: Color(red: 0.24, green: 0.52, blue: 0.66),
                petal2: Color(red: 0.50, green: 0.78, blue: 0.84),
                highlight: Color(red: 0.74, green: 0.90, blue: 0.96),
                speed: 0.16,
                petals: 9,
                bloom: 0.76
            )
        case .night:
            KaleidoscopeBloomThemeStyle(
                background: Color(red: 0.02, green: 0.0, blue: 0.06),
                petal1: Color(red: 0.62, green: 0.24, blue: 1.0),
                petal2: Color(red: 0.12, green: 0.78, blue: 1.0),
                highlight: Color(red: 0.94, green: 0.86, blue: 1.0),
                speed: 0.22,
                petals: 10,
                bloom: 1.0
            )
        }
    }

    var silkVortexStyle: SilkVortexThemeStyle {
        switch self {
        case .morning:
            SilkVortexThemeStyle(
                shadow: Color(red: 0.07, green: 0.03, blue: 0.08),
                silk1: Color(red: 0.92, green: 0.36, blue: 0.42),
                silk2: Color(red: 0.96, green: 0.62, blue: 0.42),
                glint: Color(red: 1.0, green: 0.82, blue: 0.72),
                speed: 0.20,
                swirl: 0.82,
                contrast: 0.88
            )
        case .sunnyNoon:
            SilkVortexThemeStyle(
                shadow: Color(red: 0.02, green: 0.10, blue: 0.20),
                silk1: Color(red: 0.10, green: 0.58, blue: 0.92),
                silk2: Color(red: 0.94, green: 0.74, blue: 0.30),
                glint: Color(red: 0.92, green: 0.98, blue: 1.0),
                speed: 0.18,
                swirl: 0.72,
                contrast: 0.82
            )
        case .rainy:
            SilkVortexThemeStyle(
                shadow: Color(red: 0.01, green: 0.02, blue: 0.05),
                silk1: Color(red: 0.16, green: 0.36, blue: 0.48),
                silk2: Color(red: 0.36, green: 0.58, blue: 0.66),
                glint: Color(red: 0.70, green: 0.88, blue: 0.94),
                speed: 0.24,
                swirl: 0.92,
                contrast: 1.08
            )
        case .night:
            SilkVortexThemeStyle(
                shadow: Color(red: 0.0, green: 0.0, blue: 0.04),
                silk1: Color(red: 0.16, green: 0.48, blue: 0.96),
                silk2: Color(red: 0.48, green: 0.22, blue: 0.94),
                glint: Color(red: 0.86, green: 0.92, blue: 1.0),
                speed: 0.26,
                swirl: 1.05,
                contrast: 1.0
            )
        }
    }
}
