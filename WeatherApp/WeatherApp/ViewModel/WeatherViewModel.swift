//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Ashish Bahl on 28/07/25.
//

import Foundation

class WeatherViewModel {
    
    // MARK: Variables
    private let service: WeatherServiceProtocol

    // MARK: Initialiser
    init(service: WeatherServiceProtocol = WeatherService()) {
        self.service = service
    }

    // MARK: Fetch Weather for city
    func fetchWeather(for city: String) async throws -> WeatherResponse {
        return try await service.fetchWeather(for: city)
    }

    // MARK: Fetch weather using coords
    func fetchWeatherByCoordinates(lat: Double, lon: Double) async throws -> WeatherResponse {
        return try await service.fetchWeatherByCoordinates(lat: lat, lon: lon)
    }
}
