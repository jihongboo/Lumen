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
    
    var title: LocalizedStringKey {
        switch self {
        case .meshGradient:
            "Gradient"
        case .smoke:
            "Smock"
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
            }
        }
        .ignoresSafeArea()
        .transition(.opacity)
        .animation(.smooth, value: background)
    }
}

#Preview {
    LiquidGlassTimePage(background: .meshGradient)
        .environment(WeatherLocationService.preview())
}
