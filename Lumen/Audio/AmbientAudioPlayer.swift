//
//  AmbientAudioPlayer.swift
//  Lumen
//
//  Created by Codex on 2026/4/30.
//

import AVFoundation
import Observation
import SwiftUI

@Observable
final class AmbientAudioPlayer {
    static let disabled = AmbientAudioPlayer(resourceName: "", fileExtension: "")

    private let resourceName: String
    private let fileExtension: String
    private(set) var isPlaying = false

    @ObservationIgnored
    private var player: AVAudioPlayer?

    init(resourceName: String, fileExtension: String) {
        self.resourceName = resourceName
        self.fileExtension = fileExtension
    }

    func play(looping: Bool = true) {
        guard !resourceName.isEmpty, !fileExtension.isEmpty else {
            return
        }

        if let player {
            if !player.isPlaying {
                player.play()
            }
            isPlaying = player.isPlaying
            return
        }

        guard let audioURL else {
            assertionFailure("Missing bundled audio resource: \(resourceName).\(fileExtension)")
            return
        }

        configureAudioSession()

        do {
            let player = try AVAudioPlayer(contentsOf: audioURL)
            player.numberOfLoops = looping ? -1 : 0
            player.prepareToPlay()
            player.play()
            isPlaying = player.isPlaying
            self.player = player
        } catch {
            assertionFailure("Failed to play bundled audio resource: \(error.localizedDescription)")
        }
    }

    func stop() {
        player?.stop()
        isPlaying = false
    }

    private var audioURL: URL? {
        Bundle.main.url(forResource: resourceName, withExtension: fileExtension, subdirectory: "Resources/Sounds")
            ?? Bundle.main.url(forResource: resourceName, withExtension: fileExtension, subdirectory: "Sounds")
            ?? Bundle.main.url(forResource: resourceName, withExtension: fileExtension)
    }

    private func configureAudioSession() {
        #if os(iOS) || os(tvOS) || os(visionOS)
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            assertionFailure("Failed to configure audio session: \(error.localizedDescription)")
        }
        #endif
    }
}

extension EnvironmentValues {
    @Entry var ambientAudioPlayer = AmbientAudioPlayer.disabled
}
