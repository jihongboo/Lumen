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
    @FocusState private var isPlayerButtonFocused: Bool
    @FocusState private var isSwitcherButtonFocused: Bool
    @FocusState private var focusedSwitcherPage: HomeDisplayPage?

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
                        .focused($isPlayerButtonFocused)
                    
                    Button(isSwitchingPage ? "完成页面切换" : "切换页面", systemImage: isSwitchingPage ? "checkmark" : "rectangle.stack") {
                        withAnimation(.smooth) {
                            isSwitchingPage.toggle()
                        }
                    }
                    .labelStyle(.iconOnly)
                    .buttonStyle(.glass)
                    .focused($isSwitcherButtonFocused)
                    .tvOSMoveDownCommand {
                        if isSwitchingPage {
                            focusedSwitcherPage = selectedPage
                        }
                    }
                    .padding()
                }
            }
            .overlay {
                if isSwitchingPage {
                    HomePageSwitcherFooter(
                        selectedPage: $selectedPage,
                        focusedPage: $focusedSwitcherPage,
                        isSwitcherButtonFocused: $isSwitcherButtonFocused
                    )
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
        }
        .preferredColorScheme(.dark)
        .ignoresSafeArea()
    }
}

private extension View {
    @ViewBuilder
    func tvOSMoveDownCommand(_ action: @escaping () -> Void) -> some View {
        #if os(tvOS)
        onMoveCommand { direction in
            if direction == .down {
                action()
            }
        }
        #else
        self
        #endif
    }
}

#Preview {
    HomePage()
        .environment(WeatherLocationService(weatherInfo: WeatherInfo.preview))
}
