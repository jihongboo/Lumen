//
//  SWArtisticBackgrounds.swift
//  Lumen
//
//  Created by Codex on 2026/6/3.
//

import SwiftUI

struct SWAuroraVeil: View {
    var base: Color
    var ribbon1: Color
    var ribbon2: Color
    var glow: Color
    var speed: Float = 0.32
    var scale: Float = 1.0
    var intensity: Float = 1.0

    @State private var start: Date = .now

    var body: some View {
        TimelineView(.animation) { context in
            let elapsed = Float(context.date.timeIntervalSince(start))
            base
                .colorEffect(
                    ShaderLibrary.swAuroraVeil(
                        .boundingRect,
                        .float(elapsed),
                        .float(speed),
                        .float(scale),
                        .float(intensity),
                        .color(base),
                        .color(ribbon1),
                        .color(ribbon2),
                        .color(glow)
                    )
                )
        }
    }
}

struct SWKaleidoscopeBloom: View {
    var background: Color
    var petal1: Color
    var petal2: Color
    var highlight: Color
    var speed: Float = 0.22
    var petals: Float = 8
    var bloom: Float = 1.0

    @State private var start: Date = .now

    var body: some View {
        TimelineView(.animation) { context in
            let elapsed = Float(context.date.timeIntervalSince(start))
            background
                .colorEffect(
                    ShaderLibrary.swKaleidoscopeBloom(
                        .boundingRect,
                        .float(elapsed),
                        .float(speed),
                        .float(petals),
                        .float(bloom),
                        .color(background),
                        .color(petal1),
                        .color(petal2),
                        .color(highlight)
                    )
                )
        }
    }
}

struct SWSilkVortex: View {
    var shadow: Color
    var silk1: Color
    var silk2: Color
    var glint: Color
    var speed: Float = 0.26
    var swirl: Float = 1.0
    var contrast: Float = 1.0

    @State private var start: Date = .now

    var body: some View {
        TimelineView(.animation) { context in
            let elapsed = Float(context.date.timeIntervalSince(start))
            shadow
                .colorEffect(
                    ShaderLibrary.swSilkVortex(
                        .boundingRect,
                        .float(elapsed),
                        .float(speed),
                        .float(swirl),
                        .float(contrast),
                        .color(shadow),
                        .color(silk1),
                        .color(silk2),
                        .color(glint)
                    )
                )
        }
    }
}

#Preview("Artistic Backgrounds") {
    TabView {
        SWAuroraVeil(
            base: Color(red: 0.01, green: 0.02, blue: 0.08),
            ribbon1: .mint,
            ribbon2: .purple,
            glow: .cyan
        )
        .ignoresSafeArea()

        SWKaleidoscopeBloom(
            background: Color(red: 0.04, green: 0.01, blue: 0.08),
            petal1: .pink,
            petal2: .orange,
            highlight: .white
        )
        .ignoresSafeArea()

        SWSilkVortex(
            shadow: Color(red: 0.01, green: 0.01, blue: 0.05),
            silk1: .cyan,
            silk2: .purple,
            glint: .white
        )
        .ignoresSafeArea()
    }
}
