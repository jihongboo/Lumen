//
//  HomePage.swift
//  Lumen
//
//  Created by 纪洪波 on 2026/4/29.
//

import SwiftUI

struct HomePage: View {
    @AppStorage(AppStorageKeys.homeSelectedPage) private var selectedPage = HomeDisplayPage.liquidGlassTime
    @State private var isSwitchingPage = false
    @FocusState private var isSwitcherButtonFocused: Bool
    @FocusState private var focusedSwitcherPage: HomeDisplayPage?
    
    var body: some View {
        ZStack {
            HomePageCarousel(
                selectedPage: $selectedPage,
                isSwitchingPage: isSwitchingPage,
            )
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
            .ignoresSafeArea()
            
            Color.clear
                .overlay(alignment: .topTrailing) {
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
                    .padding(.horizontal)
                }
        }
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
