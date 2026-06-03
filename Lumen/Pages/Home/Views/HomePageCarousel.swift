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
    
    var body: some View {
        selectedPage.content(isActive: !isSwitchingPage)
    }
}

#Preview {
    @Previewable @State var selectedPage = HomeDisplayPage.liquidGlassTime
    
    HomePageCarousel(
        selectedPage: $selectedPage,
        isSwitchingPage: true,
    )
    .background(.black)
    .ignoresSafeArea()
}
