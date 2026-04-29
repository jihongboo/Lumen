//
//  LumenApp.swift
//  Lumen
//
//  Created by 纪洪波 on 2026/4/29.
//

import SwiftUI

@main
struct LumenApp: App {
    private let ambientAudioPlayer = AmbientAudioPlayer(resourceName: "rain", fileExtension: "mp3")
    @State private var weatherAndLocation = WeatherLocationService()

    var body: some Scene {
        WindowGroup {
            HomePage()
                .environment(\.ambientAudioPlayer, ambientAudioPlayer)
                .environment(weatherAndLocation)
                .task {
                    ambientAudioPlayer.play()
                    await weatherAndLocation.startWeatherUpdates()
                }
        }
    }
}
