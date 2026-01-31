//
//  WeatherAPIModels.swift
//  WeatherAppPro
//
//  Created by Dony on 31/01/26
//

import Foundation

// MARK: - WeatherAPI.com Response Models

struct WeatherAPIResponse: Codable {
    let location: APILocation
    let current: APICurrent
    let forecast: APIForecast?
}

struct APILocation: Codable {
    let name: String
    let country: String
    let lat: Double
    let lon: Double
}

struct APICurrent: Codable {
    let temp_c: Double
    let feelslike_c: Double
    let humidity: Int
    let wind_kph: Double
    let condition: APICondition
}

struct APICondition: Codable {
    let text: String
    let icon: String
}

struct APIForecast: Codable {
    let forecastday: [APIForecastDay]
}

struct APIForecastDay: Codable {
    let date: String
    let day: APIDay
    let hour: [APIHour]
}

struct APIDay: Codable {
    let maxtemp_c: Double
    let mintemp_c: Double
    let condition: APICondition
}

struct APIHour: Codable {
    let time: String
    let temp_c: Double
    let condition: APICondition
}
