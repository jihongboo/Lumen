//
//  LumenApp.swift
//  Lumen
//
//  Created by 纪洪波 on 2026/4/29.
//

import SwiftUI

@main
struct LumenApp: App {
    @AppStorage(AppStorageKeys.homeDefaultAmbientSound) private var defaultAmbientSound = AmbientSound.rain

    private let ambientAudioPlayer = AmbientAudioPlayer(sound: AmbientSound.storedDefault)
    @State private var weatherAndLocation = WeatherLocationService()

    var body: some Scene {
        WindowGroup {
            HomePage()
                .preferredColorScheme(.dark)
                .environment(\.ambientAudioPlayer, ambientAudioPlayer)
                .environment(weatherAndLocation)
                .task {
                    AppIdleTimer.disable()
                    ambientAudioPlayer.play()
                    await weatherAndLocation.startWeatherUpdates()
                }
                .onChange(of: defaultAmbientSound) { _, sound in
                    ambientAudioPlayer.playSound(sound)
                }
        }
    }
}
