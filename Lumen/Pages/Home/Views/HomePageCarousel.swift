//
//  HomePageCarousel.swift
//  Lumen
//
//  Created by Codex on 2026/4/30.
//

import SwiftUI

struct HomePageCarousel: View {
    @Binding var selectedPage: HomeDisplayPage

    let isSwitchingPage: Bool
    let size: CGSize

    var body: some View {
        TabView(selection: $selectedPage) {
            ForEach(HomeDisplayPage.allCases) { page in
                page.content
                    .frame(width: size.width, height: size.height)
                    .clipShape(RoundedRectangle(cornerRadius: isSwitchingPage ? 32 : 0, style: .continuous))
                    .padding(.horizontal, isSwitchingPage ? 28 : 0)
                    .tag(page)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .scaleEffect(isSwitchingPage ? 0.7 : 1)
        .allowsHitTesting(isSwitchingPage)
        .animation(.smooth, value: isSwitchingPage)
    }
}

#Preview {
    @Previewable @State var selectedPage = HomeDisplayPage.liquidGlassTime

    GeometryReader { proxy in
        HomePageCarousel(
            selectedPage: $selectedPage,
            isSwitchingPage: true,
            size: proxy.size
        )
    }
    .background(.black)
    .ignoresSafeArea()
}
