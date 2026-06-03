//
//  WeatherAndLocationEnvironment.swift
//  Lumen
//
//  Created by Codex on 2026/4/30.
//

import Foundation
import Observation
import SwiftUI

#if canImport(CoreLocation) && canImport(MapKit) && canImport(WeatherKit)
import CoreLocation
import MapKit
import WeatherKit
#endif

@Observable
final class WeatherLocationService: NSObject {
    var weatherInfo: WeatherInfo?
    var weatherError: String?
    var isLoadingWeather = false

    @ObservationIgnored private let refreshInterval: TimeInterval = 60 * 60
    @ObservationIgnored private var lastWeatherRefreshDate: Date?

    #if canImport(CoreLocation) && canImport(MapKit) && canImport(WeatherKit)
    @ObservationIgnored private let locationManager = CLLocationManager()
    @ObservationIgnored private let weatherService = WeatherService.shared
    @ObservationIgnored private var locationContinuation: CheckedContinuation<CLLocation, Error>?
    #endif

    init(
        weatherInfo: WeatherInfo? = nil
    ) {
        self.weatherInfo = weatherInfo
        super.init()

        #if canImport(CoreLocation) && canImport(MapKit) && canImport(WeatherKit)
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        #endif
    }

    static func preview(weatherInfo: WeatherInfo = .preview) -> WeatherLocationService {
        WeatherLocationService(weatherInfo: weatherInfo)
    }

    func startWeatherUpdates() async {
        while !Task.isCancelled {
            await refreshWeatherIfNeeded()

            do {
                try await Task.sleep(for: .seconds(refreshInterval))
            } catch {
                return
            }
        }
    }

    private func fetchWeatherInfo() async throws -> WeatherInfo {
        #if canImport(CoreLocation) && canImport(MapKit) && canImport(WeatherKit)
        let location = try await currentLocation()
        async let weather = weatherService.weather(for: location)
        async let locationName = locationName(for: location)
        return try await WeatherInfo(weather: weather.currentWeather, location: locationName)
        #else
        throw WeatherAndLocationError.unsupportedPlatform
        #endif
    }

    private func refreshWeatherIfNeeded(date: Date = .now) async {
        guard !isLoadingWeather else {
            return
        }

        if let lastWeatherRefreshDate,
           date.timeIntervalSince(lastWeatherRefreshDate) < refreshInterval {
            return
        }

        isLoadingWeather = true
        weatherError = nil
        lastWeatherRefreshDate = date

        do {
            weatherInfo = try await fetchWeatherInfo()
        } catch {
            weatherError = error.localizedDescription
        }

        isLoadingWeather = false
    }
}

enum WeatherAndLocationError: LocalizedError {
    case locationDenied
    case locationUnavailable
    case unsupportedPlatform

    var errorDescription: String? {
        switch self {
        case .locationDenied:
            "Location access is disabled."
        case .locationUnavailable:
            "Unable to determine the current location."
        case .unsupportedPlatform:
            "Weather and location are unavailable on this platform."
        }
    }
}

#if canImport(CoreLocation) && canImport(MapKit) && canImport(WeatherKit)
extension WeatherLocationService: CLLocationManagerDelegate {
    private func currentLocation() async throws -> CLLocation {
        if let cachedLocation = locationManager.location,
           abs(cachedLocation.timestamp.timeIntervalSinceNow) < 600 {
            return cachedLocation
        }

        let authorizationStatus = locationManager.authorizationStatus

        switch authorizationStatus {
        case .notDetermined:
            break
        case .restricted, .denied:
            throw WeatherAndLocationError.locationDenied
        case .authorizedAlways, .authorizedWhenInUse:
            break
        @unknown default:
            break
        }

        return try await withCheckedThrowingContinuation { continuation in
            locationContinuation?.resume(throwing: WeatherAndLocationError.locationUnavailable)
            locationContinuation = continuation

            if authorizationStatus == .notDetermined {
                locationManager.requestWhenInUseAuthorization()
            } else {
                locationManager.requestLocation()
            }
        }
    }

    private func locationName(for location: CLLocation) async -> String {
        do {
            guard let request = MKReverseGeocodingRequest(location: location) else {
                return "Current Location"
            }

            let mapItems = try await request.mapItems
            guard let mapItem = mapItems.first else {
                return "Current Location"
            }

            return mapItem.name
                ?? mapItem.address?.shortAddress
                ?? mapItem.address?.fullAddress
                ?? "Current Location"
        } catch {
            return "Current Location"
        }
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .restricted, .denied:
            locationContinuation?.resume(throwing: WeatherAndLocationError.locationDenied)
            locationContinuation = nil
        case .authorizedAlways, .authorizedWhenInUse:
            manager.requestLocation()
        case .notDetermined:
            break
        @unknown default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            locationContinuation?.resume(throwing: WeatherAndLocationError.locationUnavailable)
            locationContinuation = nil
            return
        }

        locationContinuation?.resume(returning: location)
        locationContinuation = nil
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationContinuation?.resume(throwing: error)
        locationContinuation = nil
    }
}

private extension WeatherInfo {
    init(weather: CurrentWeather, location: String) {
        self.init(
            location: location,
            condition: weather.condition.description,
            symbol: weather.symbolName,
            temperature: Self.formattedTemperature(weather.temperature),
            feelsLike: Self.formattedTemperature(weather.apparentTemperature),
            humidity: Self.formattedHumidity(weather.humidity),
            wind: Self.formattedWind(weather.wind.speed)
        )
    }

    static func formattedTemperature(_ temperature: Measurement<UnitTemperature>) -> String {
        let value = temperature.converted(to: .celsius).value.rounded()
        return "\(Int(value))°"
    }

    static func formattedHumidity(_ humidity: Double) -> String {
        "\(Int((humidity * 100).rounded()))%"
    }

    static func formattedWind(_ speed: Measurement<UnitSpeed>) -> String {
        let value = speed.converted(to: .metersPerSecond).value
        return "\(String(format: "%.1f", value)) m/s"
    }
}
#endif
