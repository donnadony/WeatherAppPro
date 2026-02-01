import Foundation

//
//  HistoricalWeatherEntity.swift
//  WeatherAppPro
//
//  Created by Donnadony Mollo on Feb 1, 2026.
//


/// Historical weather data - domain entity
struct HistoricalWeatherEntity: Identifiable, Codable, Hashable, Sendable {
    let id: UUID
    let locationId: UUID
    let date: Date
    let dateString: String
    let maxTemp: Double
    let minTemp: Double
    let avgTemp: Double
    let condition: String
    let maxWind: Double
    let avgHumidity: Double
    let totalPrecipitation: Double?
    let uvIndex: Double?
    
    init(
        id: UUID = UUID(),
        locationId: UUID,
        date: Date,
        dateString: String,
        maxTemp: Double,
        minTemp: Double,
        avgTemp: Double,
        condition: String,
        maxWind: Double,
        avgHumidity: Double,
        totalPrecipitation: Double? = nil,
        uvIndex: Double? = nil
    ) {
        self.id = id
        self.locationId = locationId
        self.date = date
        self.dateString = dateString
        self.maxTemp = maxTemp
        self.minTemp = minTemp
        self.avgTemp = avgTemp
        self.condition = condition
        self.maxWind = maxWind
        self.avgHumidity = avgHumidity
        self.totalPrecipitation = totalPrecipitation
        self.uvIndex = uvIndex
    }
}