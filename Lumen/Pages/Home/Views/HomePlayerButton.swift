//
//  HomePlayerButton.swift
//  Lumen
//
//  Created by 纪洪波 on 2026/4/30.
//

import SwiftUI

struct HomePlayerButton: View {
    @Environment(\.ambientAudioPlayer) var ambientAudioPlayer

    var body: some View {
        Button(action: togglePlayback) {
            Image(systemName: ambientAudioPlayer.isPlaying ? "pause.fill" : "play.fill")
        }
        .lumenGlassButtonStyle()
        .accessibilityLabel(ambientAudioPlayer.isPlaying ? "Pause ambient sound" : "Play ambient sound")
    }

    private func togglePlayback() {
        if ambientAudioPlayer.isPlaying {
            ambientAudioPlayer.stop()
        } else {
            ambientAudioPlayer.play()
        }
    }
}

#Preview {
    HomePlayerButton()
}
