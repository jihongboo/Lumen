//
//  OceanParticleTimePage.swift
//  Lumen
//
//  Created by Codex on 2026/5/21.
//

import SwiftUI

struct OceanParticleTimePage: View {
    let isAnimating: Bool

    var body: some View {
        MetalArtTimePage(style: .particleOcean, isAnimating: isAnimating)
    }
}

#Preview {
    OceanParticleTimePage(isAnimating: true)
        .environment(WeatherLocationService.preview())
}
