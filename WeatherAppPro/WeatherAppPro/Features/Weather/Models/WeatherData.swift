//
//  WeatherData.swift
//  WeatherAppPro
//
//  Created by Dony on 31/01/26
//

import Foundation

/// Weather data model
struct WeatherData: Identifiable, Codable {
    let id: UUID
    let temperature: Double
    let feelsLike: Double
    let condition: String
    let humidity: Int
    let windSpeed: Double
    let location: Location
    let hourlyForecast: [HourlyWeather]
    let dailyForecast: [DailyWeather]
    
    init(
        id: UUID = UUID(),
        temperature: Double,
        feelsLike: Double,
        condition: String,
        humidity: Int,
        windSpeed: Double,
        location: Location,
        hourlyForecast: [HourlyWeather] = [],
        dailyForecast: [DailyWeather] = []
    ) {
        self.id = id
        self.temperature = temperature
        self.feelsLike = feelsLike
        self.condition = condition
        self.humidity = humidity
        self.windSpeed = windSpeed
        self.location = location
        self.hourlyForecast = hourlyForecast
        self.dailyForecast = dailyForecast
    }
}

/// Hourly weather forecast
struct HourlyWeather: Identifiable, Codable {
    let id: UUID
    let hour: String
    let temperature: Double
    let condition: String
    let icon: String
    
    init(id: UUID = UUID(), hour: String, temperature: Double, condition: String, icon: String) {
        self.id = id
        self.hour = hour
        self.temperature = temperature
        self.condition = condition
        self.icon = icon
    }
}

/// Daily weather forecast
struct DailyWeather: Identifiable, Codable {
    let id: UUID
    let day: String
    let high: Double
    let low: Double
    let condition: String
    let icon: String
    
    init(id: UUID = UUID(), day: String, high: Double, low: Double, condition: String, icon: String) {
        self.id = id
        self.day = day
        self.high = high
        self.low = low
        self.condition = condition
        self.icon = icon
    }
}
