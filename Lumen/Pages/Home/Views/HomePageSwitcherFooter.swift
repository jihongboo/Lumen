//
//  HomePageSwitcherFooter.swift
//  Lumen
//
//  Created by Codex on 2026/4/30.
//

import SwiftUI

struct HomePageSwitcherFooter: View {
    @Binding var selectedPage: HomeDisplayPage
    let focusedPage: FocusState<HomeDisplayPage?>.Binding
    let isSwitcherButtonFocused: FocusState<Bool>.Binding

    var body: some View {
        HStack(spacing: 12) {
            ForEach(HomeDisplayPage.allCases) { page in
                HomePageSwitcherOptionButton(page: page, isSelected: page == selectedPage) {
                    select(page)
                }
                .focused(focusedPage, equals: page)
            }
        }
        .tvOSFocusSection()
        .tvOSMoveUpCommand {
            isSwitcherButtonFocused.wrappedValue = true
        }
        .padding(.horizontal, 18)
        .padding(.bottom, 34)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .onAppear {
            focusedPage.wrappedValue = selectedPage
        }
        .onChange(of: selectedPage) {
            focusedPage.wrappedValue = selectedPage
        }
    }

    private func select(_ page: HomeDisplayPage) {
        withAnimation(.smooth) {
            selectedPage = page
        }
    }
}

private extension View {
    @ViewBuilder
    func tvOSFocusSection() -> some View {
        #if os(tvOS)
        focusSection()
        #else
        self
        #endif
    }

    @ViewBuilder
    func tvOSMoveUpCommand(_ action: @escaping () -> Void) -> some View {
        #if os(tvOS)
        onMoveCommand { direction in
            if direction == .up {
                action()
            }
        }
        #else
        self
        #endif
    }
}

#Preview {
    @Previewable @State var selectedPage = HomeDisplayPage.liquidGlassTime
    @FocusState var focusedPage: HomeDisplayPage?
    @FocusState var isSwitcherButtonFocused: Bool

    ZStack {
        Color.black
            .ignoresSafeArea()

        HomePageSwitcherFooter(
            selectedPage: $selectedPage,
            focusedPage: $focusedPage,
            isSwitcherButtonFocused: $isSwitcherButtonFocused
        )
    }
}
