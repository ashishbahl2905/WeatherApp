//
//  WeatherService.swift
//  WeatherApp
//
//  Created by Ashish Bahl on 28/07/25.
//

import Foundation

class WeatherService: WeatherServiceProtocol {
    
    // MARK: Fetch weather using city
    func fetchWeather(for city: String) async throws -> WeatherResponse {
        guard let cityEncoded = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: Constants.API_BASE_URL + "weather?q=\(cityEncoded)&appid=\(Constants.API_KEY)&units=metric") else {
            throw URLError(.badURL)
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NSError(domain: "Invalid city or server error", code: 1, userInfo: nil)
        }
        return try JSONDecoder().decode(WeatherResponse.self, from: data)
    }

    // MARK: Fetch weather using coords
    func fetchWeatherByCoordinates(lat: Double, lon: Double) async throws -> WeatherResponse {
        guard let url = URL(string: Constants.API_BASE_URL + "weather?lat=\(lat)&lon=\(lon)&appid=\(Constants.API_KEY)&units=metric") else {
            throw URLError(.badURL)
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NSError(domain: "Failed to fetch location weather", code: 1, userInfo: nil)
        }
        return try JSONDecoder().decode(WeatherResponse.self, from: data)
    }
}
