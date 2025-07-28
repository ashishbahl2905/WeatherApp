//
//  MockWeatherService.swift
//  WeatherApp
//
//  Created by Ashish Bahl on 28/07/25.
//

import Foundation
@testable import WeatherApp

class MockWeatherService: WeatherServiceProtocol {
    var stubbedWeather: WeatherResponse?
    var errorToThrow: Error?

    func fetchWeather(for city: String) async throws -> WeatherResponse {
        if let error = errorToThrow {
            throw error
        }
        return stubbedWeather!
    }

    func fetchWeatherByCoordinates(lat: Double, lon: Double) async throws -> WeatherResponse {
        if let error = errorToThrow {
            throw error
        }
        return stubbedWeather!
    }
}
