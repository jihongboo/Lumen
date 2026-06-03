//
//  AmbientAudioPlayer.swift
//  Lumen
//
//  Created by Codex on 2026/4/30.
//

import AVFoundation
import Observation
import SwiftUI

enum AmbientSound: String, CaseIterable, Identifiable, Hashable {
    case rain
    case ocean
    case forest
    case wind
    case fire

    var id: String { rawValue }

    var title: String {
        switch self {
        case .rain: "Rain"
        case .ocean: "Ocean"
        case .forest: "Forest"
        case .wind: "Wind"
        case .fire: "Fire"
        }
    }

    var symbol: String {
        switch self {
        case .rain: "cloud.rain"
        case .ocean: "water.waves"
        case .forest: "tree"
        case .wind: "wind"
        case .fire: "flame"
        }
    }

    var fileExtension: String { "m4a" }

    static var storedDefault: AmbientSound {
        guard
            let rawValue = UserDefaults.standard.string(forKey: AppStorageKeys.homeDefaultAmbientSound),
            let sound = AmbientSound(rawValue: rawValue)
        else {
            return .rain
        }

        return sound
    }
}

@Observable
final class AmbientAudioPlayer {
    static let disabled = AmbientAudioPlayer(resourceName: "", fileExtension: "")

    private var resourceName: String
    private var fileExtension: String
    private(set) var selectedSound: AmbientSound? = .rain
    private(set) var isPlaying = false

    @ObservationIgnored
    private var player: AVAudioPlayer?

    convenience init(sound: AmbientSound) {
        self.init(resourceName: sound.rawValue, fileExtension: sound.fileExtension)
        selectedSound = sound
    }

    init(resourceName: String, fileExtension: String) {
        self.resourceName = resourceName
        self.fileExtension = fileExtension
    }

    func play(looping: Bool = true) {
        guard !isPreviews else {
            return
        }

        guard !resourceName.isEmpty, !fileExtension.isEmpty else {
            return
        }

        if let player {
            player.numberOfLoops = looping ? -1 : 0
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

    func selectSound(_ sound: AmbientSound) {
        if selectedSound == sound, isPlaying {
            stop(clearSelection: true)
            return
        }

        playSound(sound)
    }

    func playSound(_ sound: AmbientSound) {
        if selectedSound == sound, isPlaying {
            return
        }

        player?.stop()
        player = nil
        isPlaying = false
        selectedSound = sound
        resourceName = sound.rawValue
        fileExtension = sound.fileExtension
        play()
    }

    func stop() {
        stop(clearSelection: false)
    }

    private func stop(clearSelection: Bool) {
        player?.stop()
        isPlaying = false
        if clearSelection {
            selectedSound = nil
        }
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


