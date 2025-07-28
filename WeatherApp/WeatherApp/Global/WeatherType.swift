//
//  WeatherType.swift
//  WeatherApp
//
//  Created by Ashish Bahl on 28/07/25.
//

import UIKit

// MARK: Weather Enum
enum WeatherType: String {
    case sunny = "Sunny"
    case clear = "Clear"
    case rain = "Rain"
    case clouds = "Clouds"
    case snow = "Snow"
    
    var imageName: String {
        switch self {
        case .sunny, .clear:
            return "Sunny"
        case .rain:
            return "Rain"
        case .clouds:
            return "Cloudy"
        case .snow:
            return "Snow"
        }
    }
    
    var textColor: UIColor {
        switch self {
        case .sunny, .clear, .snow:
            return .black
        case .clouds, .rain:
            return .white
        }
    }
}
