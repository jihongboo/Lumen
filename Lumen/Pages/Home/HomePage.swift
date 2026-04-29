//
//  HomePage.swift
//  Lumen
//
//  Created by 纪洪波 on 2026/4/29.
//

import SwiftUI

struct HomePage: View {
    @State private var selectedPage = HomeDisplayPage.liquidGlassTime
    @State private var isSwitchingPage = false

    var body: some View {
        GeometryReader { proxy in
            HomePageCarousel(
                selectedPage: $selectedPage,
                isSwitchingPage: isSwitchingPage,
                size: proxy.size
            )
            .overlay(alignment: .topTrailing) {
                HStack(spacing: 8) {
                    HomePlayerButton()
                    
                    Button(isSwitchingPage ? "完成页面切换" : "切换页面", systemImage: isSwitchingPage ? "checkmark" : "rectangle.stack") {
                        withAnimation(.smooth) {
                            isSwitchingPage.toggle()
                        }
                    }
                    .labelStyle(.iconOnly)
                    .buttonStyle(.glass)
                    .padding()
                }
            }
            .overlay {
                if isSwitchingPage {
                    HomePageSwitcherFooter(selectedPage: $selectedPage)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
        }
        .preferredColorScheme(.dark)
        .ignoresSafeArea()
    }
}

#Preview {
    HomePage()
        .environment(WeatherLocationService(weatherInfo: WeatherInfo.preview))
}
