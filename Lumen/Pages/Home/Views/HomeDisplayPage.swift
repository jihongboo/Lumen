//
//  HomeDisplayPage.swift
//  Lumen
//
//  Created by Codex on 2026/4/30.
//

import SwiftUI

enum HomeDisplayPage: String, CaseIterable, Identifiable, Hashable {
    case time
    case liquidGlassTime
    case particleOcean
    case auroraVeil
    case starTunnel
    case chromaBloom
    case prismRefraction

    var id: String { rawValue }

    var title: String {
        switch self {
        case .time: "Time"
        case .liquidGlassTime: "Liquid Glass"
        case .particleOcean: "Particle Ocean"
        case .auroraVeil: MetalArtBackgroundStyle.auroraVeil.title
        case .starTunnel: MetalArtBackgroundStyle.starTunnel.title
        case .chromaBloom: MetalArtBackgroundStyle.chromaBloom.title
        case .prismRefraction: MetalArtBackgroundStyle.prismRefraction.title
        }
    }

    var symbol: String {
        switch self {
        case .time: "clock"
        case .liquidGlassTime: "sparkles"
        case .particleOcean: "water.waves"
        case .auroraVeil: MetalArtBackgroundStyle.auroraVeil.symbol
        case .starTunnel: MetalArtBackgroundStyle.starTunnel.symbol
        case .chromaBloom: MetalArtBackgroundStyle.chromaBloom.symbol
        case .prismRefraction: MetalArtBackgroundStyle.prismRefraction.symbol
        }
    }

    @ViewBuilder
    func content(isActive: Bool = true) -> some View {
        switch self {
        case .time:
            TimePage(isAnimating: isActive)
        case .liquidGlassTime:
            LiquidGlassTimePage(isAnimating: isActive)
        case .particleOcean:
            OceanParticleTimePage(isAnimating: isActive)
        case .auroraVeil:
            MetalArtTimePage(style: .auroraVeil, isAnimating: isActive)
        case .starTunnel:
            MetalArtTimePage(style: .starTunnel, isAnimating: isActive)
        case .chromaBloom:
            MetalArtTimePage(style: .chromaBloom, isAnimating: isActive)
        case .prismRefraction:
            MetalArtTimePage(style: .prismRefraction, isAnimating: isActive)
        }
    }
}
