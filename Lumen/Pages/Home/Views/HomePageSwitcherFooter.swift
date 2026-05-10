//
//  HomePageSwitcherFooter.swift
//  Lumen
//
//  Created by Codex on 2026/4/30.
//

import SwiftUI

struct HomePageSwitcherFooter: View {
    @Environment(\.ambientAudioPlayer) private var ambientAudioPlayer
    @AppStorage(AppStorageKeys.homeDefaultAmbientSound) private var defaultAmbientSound = AmbientSound.rain

    @Binding var selectedPage: HomeDisplayPage
    let focusedPage: FocusState<HomeDisplayPage?>.Binding
    let isSwitcherButtonFocused: FocusState<Bool>.Binding

    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                ForEach(HomeDisplayPage.allCases) { page in
                    HomePageSwitcherOptionButton(page: page, isSelected: page == selectedPage) {
                        select(page)
                    }
                    .focused(focusedPage, equals: page)
                }

            }

            HStack(spacing: 12) {
                ForEach(AmbientSound.allCases) { sound in
                    AmbientSoundSegmentButton(
                        sound: sound,
                        isSelected: sound == ambientAudioPlayer.selectedSound
                    ) {
                        defaultAmbientSound = sound
                        ambientAudioPlayer.selectSound(sound)
                    }
                }
            }
        }
        .tvOSFocusSection()
        .tvOSMoveUpCommand {
            isSwitcherButtonFocused.wrappedValue = true
        }
        .padding(.horizontal, 18)
        .padding(.bottom)
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

private struct AmbientSoundSegmentButton: View {
    let sound: AmbientSound
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Label(sound.title, systemImage: sound.symbol)
                .font(.system(.callout, design: .rounded, weight: .semibold))
                .lineLimit(1)
                .minimumScaleFactor(0.8)
                .padding(.horizontal, 15)
                .frame(height: 44)
                .foregroundStyle(isSelected ? .black : .white)
        }
        .tint(isSelected ? .white : .clear)
        .buttonStyle(.glassProminent)
        .accessibilityLabel(sound.title)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
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
