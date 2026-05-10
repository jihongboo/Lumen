//
//  LiquidGlassTimePage.swift
//  Lumen
//
//  Created by 纪洪波 on 2026/4/30.
//

import SwiftUI

struct LiquidGlassTimePage: View {
    let isAnimating: Bool
    
    var body: some View {
        MeshGradientView(isAnimating: isAnimating)
            .ignoresSafeArea()
            .overlay {
                LiquidGlassTimeView()
            }
    }
}

#Preview {
    LiquidGlassTimePage(isAnimating: true)
        .environment(WeatherLocationService.preview())
}
