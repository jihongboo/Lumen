//
//  LiquidGlassTimePage.swift
//  Lumen
//
//  Created by 纪洪波 on 2026/4/30.
//

import SwiftUI

struct LiquidGlassTimePage: View {
    let isAnimating: Bool
    
    @Environment(WeatherLocationService.self) private var weatherAndLocation
    
    var body: some View {
        MeshGradientView(
            theme: Theme.current(weather: weatherAndLocation.weatherInfo),
            isAnimating: isAnimating
        )
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
