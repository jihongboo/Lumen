//
//  SWInkSmoke.swift
//  ShipSwift
//
//  Domain-warped fbm "ink in water" smoke field rendered via a SwiftUI
//  Metal stitchable shader. Two-stage domain warp on 5-octave value-noise
//  FBM produces slow, billowing color blooms reminiscent of food coloring
//  diffusing through water. Four ink colors and a glow highlight are
//  user-tunable.
//
//  Requires iOS 17+ / macOS 14+ (SwiftUI `ShaderLibrary`,
//  `Shader`/`ShaderFunction`, Metal `stitchable`).
//
//  Usage:
//    // Default — twilight-purple ink, full-screen
//    ZStack {
//        SWInkSmoke()
//            .ignoresSafeArea()
//        // Your content here
//    }
//
//    // Theme — colors follow the app time/weather theme
//    SWInkSmoke(theme: .rainy)
//
//    // Recolor — emerald / teal ink
//    SWInkSmoke(
//        ink1: .black,
//        ink2: .teal,
//        ink3: .green,
//        ink4: .mint,
//        glow: .white
//    )
//
//    // As a section background
//    myContent
//        .background { SWInkSmoke() }
//
//    // Demo / debug — adds a gear button in the navigation bar that
//    // opens a sheet to tweak every parameter live. Disabled by default.
//    SWInkSmoke(showsControls: true)
//
//  Parameters:
//    - theme: Optional app theme. When supplied, the theme palette overrides
//             the ink/glow defaults.
//    - ink1: First ink color, dominant where the final FBM is darkest
//            (default deep aubergine `#0D001A`)
//    - ink2: Second ink color, mixed in by the final FBM
//            (default ultramarine `#1A3380`)
//    - ink3: Third ink color, mixed in by the first warp field
//            (default plum `#661A4D`)
//    - ink4: Fourth ink color, mixed in by the second warp field
//            (default deep teal `#004D66`)
//    - glow: Wispy highlight color added where the field peaks
//            (default violet-grey `#4D3366`)
//    - speed: Multiplier on the internal time evolution (default `1.0`)
//    - scale: Spatial scale of the FBM field — higher = finer ink filaments
//             (default `1.8`)
//    - warp: Strength of the first-pass domain warp on the second
//            (default `4.0`)
//    - highlight: Multiplier on the wispy highlight additive layer
//                 (default `1.0`)
//    - showsControls: When `true`, adds a gear `ToolbarItem` to the
//                     enclosing `NavigationStack` that opens a
//                     live-tuning sheet. Default `false`.
//
//  Notes:
//    - The shader makes 5 FBM evaluations per pixel (`q.x`, `q.y`, `r2.x`,
//      `r2.y`, `f`), each of which is a 5-octave value noise = 25 noise
//      lookups per pixel. This is heavier than `SWFractalClouds` (2 FBMs
//      = 10 lookups). Keep to one full-screen instance; budget accordingly
//      on lower-end devices.
//    - `scale` is clamped internally to `>= 0.0001` so zero/negative input
//      is safe.
//    - When `showsControls` is `true`, the gear button is a native
//      `ToolbarItem` — the call site must be inside a `NavigationStack`.
//
//  Created by Wei Zhong on 5/20/26.
//

import SwiftUI

// MARK: - Main View

struct SWInkSmoke: View {
    /// Optional app theme. When supplied, the theme palette overrides ink/glow defaults.
    var theme: Theme

    /// First ink color, dominant where the final FBM is darkest.
    var ink1: Color = Color(red: 0.051, green: 0.0,   blue: 0.102)   // #0D001A

    /// Second ink color, mixed in by the final FBM.
    var ink2: Color = Color(red: 0.102, green: 0.2,   blue: 0.502)   // #1A3380

    /// Third ink color, mixed in by the first warp field.
    var ink3: Color = Color(red: 0.4,   green: 0.102, blue: 0.302)   // #661A4D

    /// Fourth ink color, mixed in by the second warp field.
    var ink4: Color = Color(red: 0.0,   green: 0.302, blue: 0.4)     // #004D66

    /// Wispy highlight color added where the field peaks.
    var glow: Color = Color(red: 0.302, green: 0.2,   blue: 0.4)     // #4D3366

    /// Multiplier on the internal time evolution.
    var speed: Float = 1.0

    /// Spatial scale of the FBM field — higher = finer ink filaments.
    var scale: Float = 1.8

    /// Strength of the first-pass domain warp on the second.
    var warp: Float = 4.0

    /// Multiplier on the wispy highlight additive layer.
    var highlight: Float = 1.0

    /// When `true`, attaches a gear `ToolbarItem` that opens a live-tuning sheet.
    var showsControls: Bool = false
    
    init(theme: Theme, showsControls: Bool = false) {
        self.theme = theme
        self.showsControls = showsControls
    }

    var body: some View {
        let palette = theme.inkSmokePalette

        if showsControls {
            SWInkSmokeControlled(initial: self)
        } else {
            SWInkSmokeRenderer(
                ink1: palette.ink1,
                ink2: palette.ink2,
                ink3: palette.ink3,
                ink4: palette.ink4,
                glow: palette.glow,
                speed: speed,
                scale: scale,
                warp: warp,
                highlight: highlight
            )
        }
    }
}

private struct SWInkSmokePalette {
    let ink1: Color
    let ink2: Color
    let ink3: Color
    let ink4: Color
    let glow: Color
}

// MARK: - Renderer (pure shader binding)

private struct SWInkSmokeRenderer: View {
    let ink1: Color
    let ink2: Color
    let ink3: Color
    let ink4: Color
    let glow: Color
    let speed: Float
    let scale: Float
    let warp: Float
    let highlight: Float

    @State private var start: Date = .now

    var body: some View {
        TimelineView(.animation) { ctx in
            let elapsed = Float(ctx.date.timeIntervalSince(start))
            // The base layer is `ink1` — the shader overwrites every pixel,
            // so the choice is cosmetic, but `ink1` keeps the first frame
            // looking like dark ink instead of flashing black.
            ink1
                .colorEffect(
                    ShaderLibrary.swInkSmoke(
                        .boundingRect,
                        .float(elapsed),
                        .float(speed),
                        .float(scale),
                        .float(warp),
                        .float(highlight),
                        .color(ink1),
                        .color(ink2),
                        .color(ink3),
                        .color(ink4),
                        .color(glow)
                    )
                )
        }
    }
}

// MARK: - Controlled Wrapper (gear toolbar item + live sheet)

private struct SWInkSmokeControlled: View {
    @State private var ink1: Color
    @State private var ink2: Color
    @State private var ink3: Color
    @State private var ink4: Color
    @State private var glow: Color
    @State private var speed: Float
    @State private var scale: Float
    @State private var warp: Float
    @State private var highlight: Float

    @State private var showSheet = false

    init(initial: SWInkSmoke) {
        let palette = initial.theme.inkSmokePalette

        _ink1      = State(initialValue: palette.ink1)
        _ink2      = State(initialValue: palette.ink2)
        _ink3      = State(initialValue: palette.ink3)
        _ink4      = State(initialValue: palette.ink4)
        _glow      = State(initialValue: palette.glow)
        _speed     = State(initialValue: initial.speed)
        _scale     = State(initialValue: initial.scale)
        _warp      = State(initialValue: initial.warp)
        _highlight = State(initialValue: initial.highlight)
    }

    var body: some View {
        SWInkSmokeRenderer(
            ink1: ink1,
            ink2: ink2,
            ink3: ink3,
            ink4: ink4,
            glow: glow,
            speed: speed,
            scale: scale,
            warp: warp,
            highlight: highlight
        )
        .ignoresSafeArea()
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    showSheet = true
                } label: {
                    Image(systemName: "slider.horizontal.3")
                }
                .accessibilityLabel("Ink Smoke Controls")
            }
        }
        .sheet(isPresented: $showSheet) {
            SWInkSmokeControlsSheet(
                ink1: $ink1,
                ink2: $ink2,
                ink3: $ink3,
                ink4: $ink4,
                glow: $glow,
                speed: $speed,
                scale: $scale,
                warp: $warp,
                highlight: $highlight
            )
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.visible)
        }
    }
}

// MARK: - Controls Sheet

private struct SWInkSmokeControlsSheet: View {
    @Binding var ink1: Color
    @Binding var ink2: Color
    @Binding var ink3: Color
    @Binding var ink4: Color
    @Binding var glow: Color
    @Binding var speed: Float
    @Binding var scale: Float
    @Binding var warp: Float
    @Binding var highlight: Float

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Section("Inks") {
                    ColorPicker("Ink 1", selection: $ink1, supportsOpacity: false)
                    ColorPicker("Ink 2", selection: $ink2, supportsOpacity: false)
                    ColorPicker("Ink 3", selection: $ink3, supportsOpacity: false)
                    ColorPicker("Ink 4", selection: $ink4, supportsOpacity: false)
                    ColorPicker("Glow",  selection: $glow, supportsOpacity: false)
                }

                Section("Field") {
                    SliderRow(label: "Scale",     value: $scale,     range: 0.2...5,  step: 0.05)
                    SliderRow(label: "Warp",      value: $warp,      range: 0...10,   step: 0.1)
                    SliderRow(label: "Highlight", value: $highlight, range: 0...3,    step: 0.05)
                }

                Section("Motion") {
                    SliderRow(label: "Speed", value: $speed, range: 0...3, step: 0.05)
                }
            }
            .navigationTitle("Ink Smoke")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

private struct SliderRow: View {
    let label: String
    @Binding var value: Float
    let range: ClosedRange<Float>
    let step: Float

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(label)
                Spacer()
                Text(String(format: "%.2f", value))
                    .font(.callout.monospacedDigit())
                    .foregroundStyle(.secondary)
            }
            Slider(value: $value, in: range, step: step)
        }
    }
}

private extension Theme {
    var inkSmokePalette: SWInkSmokePalette {
        switch self {
        case .morning:
            SWInkSmokePalette(
                ink1: Color(red: 0.11, green: 0.08, blue: 0.18),
                ink2: Color(red: 0.46, green: 0.32, blue: 0.48),
                ink3: Color(red: 0.84, green: 0.48, blue: 0.44),
                ink4: Color(red: 0.40, green: 0.42, blue: 0.58),
                glow: Color(red: 1.00, green: 0.74, blue: 0.64)
            )
        case .sunnyNoon:
            SWInkSmokePalette(
                ink1: Color(red: 0.03, green: 0.12, blue: 0.28),
                ink2: Color(red: 0.12, green: 0.34, blue: 0.58),
                ink3: Color(red: 0.48, green: 0.44, blue: 0.22),
                ink4: Color(red: 0.12, green: 0.46, blue: 0.52),
                glow: Color(red: 0.68, green: 0.52, blue: 0.26)
            )
        case .rainy:
            SWInkSmokePalette(
                ink1: Color(red: 0.03, green: 0.06, blue: 0.12),
                ink2: Color(red: 0.12, green: 0.22, blue: 0.32),
                ink3: Color(red: 0.26, green: 0.38, blue: 0.46),
                ink4: Color(red: 0.12, green: 0.34, blue: 0.42),
                glow: Color(red: 0.58, green: 0.82, blue: 0.92)
            )
        case .night:
            SWInkSmokePalette(
                ink1: Color(red: 0.01, green: 0.02, blue: 0.09),
                ink2: Color(red: 0.05, green: 0.12, blue: 0.32),
                ink3: Color(red: 0.10, green: 0.18, blue: 0.38),
                ink4: Color(red: 0.04, green: 0.20, blue: 0.36),
                glow: Color(red: 0.34, green: 0.48, blue: 0.76)
            )
        }
    }
}

#Preview {
    TabView {
        ForEach(Theme.allCases) { theme in
            Tab(theme.title, systemImage: "") {
                SWInkSmoke(theme: theme)
                    .ignoresSafeArea()
                    .overlay(alignment: .bottom) {
                        Text(theme.title)
                            .font(.headline)
                            .foregroundStyle(.white)
                            .padding(.bottom, 32)
                    }
                    .tag(theme)
            }
        }
    }
}
