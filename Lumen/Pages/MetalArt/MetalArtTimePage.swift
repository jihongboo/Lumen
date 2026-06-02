//
//  MetalArtTimePage.swift
//  Lumen
//
//  Created by Codex on 2026/5/21.
//

import SwiftUI

struct MetalArtTimePage: View {
    let style: MetalArtBackgroundStyle
    let isAnimating: Bool

    var body: some View {
        MetalArtBackgroundView(style: style, isAnimating: isAnimating)
            .ignoresSafeArea()
            .overlay {
                LiquidGlassTimeView()
            }
    }
}

#Preview("Aurora") {
    MetalArtTimePage(style: .auroraVeil, isAnimating: true)
        .environment(WeatherLocationService.preview())
}

#Preview("Star Tunnel") {
    MetalArtTimePage(style: .starTunnel, isAnimating: true)
        .environment(WeatherLocationService.preview())
}

#Preview("Chroma Bloom") {
    MetalArtTimePage(style: .chromaBloom, isAnimating: true)
        .environment(WeatherLocationService.preview())
}

#Preview("Prism Refraction") {
    MetalArtTimePage(style: .prismRefraction, isAnimating: true)
        .environment(WeatherLocationService.preview())
}
