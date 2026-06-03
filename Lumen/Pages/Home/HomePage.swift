//
//  HomePage.swift
//  Lumen
//
//  Created by 纪洪波 on 2026/4/29.
//

import SwiftUI

struct HomePage: View {
    @AppStorage(AppStorageKeys.homeSelectedBackground) private var background = Background.meshGradient
    @State private var isSwitchingPage = false
    
    var body: some View {
        ZStack {
            LiquidGlassTimePage(background: background)
                .overlay {
                    if isSwitchingPage {
                        HomePageSwitcherFooter()
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation(.smooth) {
                        isSwitchingPage = false
                    }
                }
            VStack {
                HStack {
                    Spacer()
                    Button(isSwitchingPage ? "完成页面切换" : "切换页面", systemImage: isSwitchingPage ? "rectangle.stack.fill" : "rectangle.stack") {
                        withAnimation(.smooth) {
                            isSwitchingPage.toggle()
                        }
                    }
                    .controlSize(.large)
                    .labelStyle(.iconOnly)
                    .lumenGlassButtonStyle()
                    .padding()
                }
                .lumenFocusSection()
                Spacer()
            }
        }
    }
}

#Preview {
    HomePage()
        .environment(WeatherLocationService(weatherInfo: WeatherInfo.preview))
}
