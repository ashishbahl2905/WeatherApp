//
//  Constants.swift
//  WeatherApp
//
//  Created by Ashish Bahl on 28/07/25.
//

import Foundation

// MARK: Constants
public class Constants : NSObject {
    public static let API_KEY = "ENTER_YOUR_API_KEY"
    public static let API_BASE_URL = "https://api.openweathermap.org/data/2.5/"
    public static let IMAGE_BASE_URL = "https://openweathermap.org/img/wn/"
    
    public static let LAST_SEARCHED_CITY = "lastCity"
    public static let ENTER_CITY = "Enter city name"
    public static let GET_WEATHER = "Get Weather"
    public static let EMPTY_CITY_NAME = "Please enter a city name, city cannot be empty."
    public static let PULL_TO_REFRESH_TEXT = "Pull to refresh current weather data"
    public static let FAILED_TO_GET_LOCATION = "Failed to get location:"
}
