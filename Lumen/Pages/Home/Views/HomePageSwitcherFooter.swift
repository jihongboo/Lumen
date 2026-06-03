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
    @AppStorage(AppStorageKeys.homeSelectedBackground) private var selection = Background.meshGradient

    var body: some View {
        VStack {
            ScrollView(.horizontal) {
                HStack {
                    ForEach(Background.allCases) { background in
                        HomePageSwitcherOptionButton(background: background, selection: $selection)
                    }
                }
            }
            .lumenFocusSection()

            ScrollView(.horizontal) {
                HStack {
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
            .lumenFocusSection()
        }
        .scrollIndicators(.hidden)
        .scrollClipDisabled()
        .scenePadding()
        .background(alignment: .bottom) {
            LinearGradient(
                colors: [
                    .black.opacity(0),
                    .black.opacity(0.65)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea(edges: .bottom)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
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
        .lumenGlassProminentButtonStyle()
        .accessibilityLabel(sound.title)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

#Preview {
    HomePageSwitcherFooter()
}
