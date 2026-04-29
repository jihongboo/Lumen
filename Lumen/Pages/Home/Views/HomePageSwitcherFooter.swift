//
//  HomePageSwitcherFooter.swift
//  Lumen
//
//  Created by Codex on 2026/4/30.
//

import SwiftUI

struct HomePageSwitcherFooter: View {
    @Binding var selectedPage: HomeDisplayPage

    var body: some View {
        HStack(spacing: 12) {
            ForEach(HomeDisplayPage.allCases) { page in
                HomePageSwitcherOptionButton(page: page, isSelected: page == selectedPage) {
                    select(page)
                }
            }
        }
        .padding(.horizontal, 18)
        .padding(.bottom, 34)
        .frame(maxHeight: .infinity, alignment: .bottom)
    }

    private func select(_ page: HomeDisplayPage) {
        withAnimation(.smooth) {
            selectedPage = page
        }
    }
}

#Preview {
    @Previewable @State var selectedPage = HomeDisplayPage.liquidGlassTime

    ZStack {
        Color.black
            .ignoresSafeArea()

        HomePageSwitcherFooter(selectedPage: $selectedPage)
    }
}
