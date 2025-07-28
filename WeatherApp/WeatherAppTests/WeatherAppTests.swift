//
//  WeatherAppTests.swift
//  WeatherAppTests
//
//  Created by Ashish Bahl on 28/07/25.
//

import XCTest
@testable import WeatherApp

final class WeatherAppTests: XCTestCase {
    
    var viewModel: WeatherViewModel!
    var mockService: MockWeatherService!
    
    override func setUp() {
        super.setUp()
        mockService = MockWeatherService()
        viewModel = WeatherViewModel(service: mockService)
    }
    
    override func tearDown() {
        viewModel = nil
        mockService = nil
        super.tearDown()
    }
    
    func testFetchWeatherReturnsCorrectData() async throws {
        mockService.stubbedWeather = WeatherResponse(
            name: "Toronto",
            main: Main(temp: 25.0),
            weather: [Weather(main: "Sunny", icon: "01d")]
        )
        
        let result = try await viewModel.fetchWeather(for: "Toronto")
        XCTAssertEqual(result.name, "Toronto")
        XCTAssertEqual(result.main.temp, 25.0)
        XCTAssertEqual(result.weather.first?.main, "Sunny")
    }
    
    func testFetchWeatherByCoordinatesReturnsCorrectData() async throws {
        mockService.stubbedWeather = WeatherResponse(
            name: "Delhi",
            main: Main(temp: 30.0),
            weather: [Weather(main: "Cloudy", icon: "03d")]
        )
        
        let result = try await viewModel.fetchWeatherByCoordinates(lat: 28.61, lon: 77.20)
        XCTAssertEqual(result.name, "Delhi")
        XCTAssertEqual(result.main.temp, 30.0)
        XCTAssertEqual(result.weather.first?.main, "Cloudy")
    }
    
    func testFetchWeatherFailsWithInvalidCity() async {
        mockService.errorToThrow = URLError(.badURL)
        
        do {
            _ = try await viewModel.fetchWeather(for: "")
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertTrue(error is URLError)
        }
    }
}
