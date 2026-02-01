//
//  WeatherEntity.swift
//  WeatherAppPro
//
//  Domain entity for Weather - framework independent
//

import Foundation

/// Current weather conditions - domain entity
struct WeatherEntity: Identifiable, Codable, Hashable, Sendable {
    let id: UUID
    let locationId: UUID
    let temperature: Double
    let feelsLike: Double
    let condition: String
    let conditionCode: Int?
    let humidity: Int
    let windSpeed: Double
    let windDirection: String?
    let pressure: Double?
    let uvIndex: Double?
    let visibility: Double?
    let timestamp: Date
    let isDay: Bool
    
    init(
        id: UUID = UUID(),
        locationId: UUID,
        temperature: Double,
        feelsLike: Double,
        condition: String,
        conditionCode: Int? = nil,
        humidity: Int,
        windSpeed: Double,
        windDirection: String? = nil,
        pressure: Double? = nil,
        uvIndex: Double? = nil,
        visibility: Double? = nil,
        timestamp: Date = Date(),
        isDay: Bool = true
    ) {
        self.id = id
        self.locationId = locationId
        self.temperature = temperature
        self.feelsLike = feelsLike
        self.condition = condition
        self.conditionCode = conditionCode
        self.humidity = humidity
        self.windSpeed = windSpeed
        self.windDirection = windDirection
        self.pressure = pressure
        self.uvIndex = uvIndex
        self.visibility = visibility
        self.timestamp = timestamp
        self.isDay = isDay
    }
}

/// Hourly weather forecast - domain entity
struct HourlyWeatherEntity: Identifiable, Codable, Hashable, Sendable {
    let id: UUID
    let hour: String
    let temperature: Double
    let condition: String
    let icon: String
    let chanceOfRain: Int?
    let isDay: Bool
    
    init(
        id: UUID = UUID(),
        hour: String,
        temperature: Double,
        condition: String,
        icon: String,
        chanceOfRain: Int? = nil,
        isDay: Bool = true
    ) {
        self.id = id
        self.hour = hour
        self.temperature = temperature
        self.condition = condition
        self.icon = icon
        self.chanceOfRain = chanceOfRain
        self.isDay = isDay
    }
}

/// Daily weather forecast - domain entity
struct DailyWeatherEntity: Identifiable, Codable, Hashable, Sendable {
    let id: UUID
    let date: Date
    let dayName: String
    let high: Double
    let low: Double
    let condition: String
    let icon: String
    let chanceOfRain: Int?
    let sunrise: String?
    let sunset: String?
    
    init(
        id: UUID = UUID(),
        date: Date,
        dayName: String,
        high: Double,
        low: Double,
        condition: String,
        icon: String,
        chanceOfRain: Int? = nil,
        sunrise: String? = nil,
        sunset: String? = nil
    ) {
        self.id = id
        self.date = date
        self.dayName = dayName
        self.high = high
        self.low = low
        self.condition = condition
        self.icon = icon
        self.chanceOfRain = chanceOfRain
        self.sunrise = sunrise
        self.sunset = sunset
    }
}

/// Complete weather data aggregate - domain entity
struct WeatherDataEntity: Identifiable, Codable, Hashable, Sendable {
    let id: UUID
    let location: LocationEntity
    let current: WeatherEntity
    let hourlyForecast: [HourlyWeatherEntity]
    let dailyForecast: [DailyWeatherEntity]
    let lastUpdated: Date
    let dataSource: DataSource
    
    init(
        id: UUID = UUID(),
        location: LocationEntity,
        current: WeatherEntity,
        hourlyForecast: [HourlyWeatherEntity] = [],
        dailyForecast: [DailyWeatherEntity] = [],
        lastUpdated: Date = Date(),
        dataSource: DataSource = .remote
    ) {
        self.id = id
        self.location = location
        self.current = current
        self.hourlyForecast = hourlyForecast
        self.dailyForecast = dailyForecast
        self.lastUpdated = lastUpdated
        self.dataSource = dataSource
    }
}

/// Indicates where the data came from
enum DataSource: String, Codable, Sendable {
    case remote
    case cache
    case mock
}