//
//  LocationEntity.swift
//  WeatherAppPro
//
//  Created by Donnadony Mollo on Feb 1, 2026.
//


/// Location entity - core domain model
/// Represents a geographic location without framework dependencies
struct LocationEntity: Identifiable, Codable, Hashable, Sendable {
    let id: UUID
    let name: String
    let latitude: Double
    let longitude: Double
    let country: String
    let region: String?
    let timezoneId: String?
    
    init(
        id: UUID = UUID(),
        name: String,
        latitude: Double,
        longitude: Double,
        country: String = "",
        region: String? = nil,
        timezoneId: String? = nil
    ) {
        self.id = id
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.country = country
        self.region = region
        self.timezoneId = timezoneId
    }
}

// MARK: - Sample Data for Testing/Previews

extension LocationEntity {
    static let sampleLima = LocationEntity(
        name: "Lima",
        latitude: -12.0464,
        longitude: -77.0428,
        country: "Peru",
        region: "Lima",
        timezoneId: "America/Lima"
    )
    
    static let sampleNewYork = LocationEntity(
        name: "New York",
        latitude: 40.7128,
        longitude: -74.0060,
        country: "USA",
        region: "New York",
        timezoneId: "America/New_York"
    )
    
    static let sampleLondon = LocationEntity(
        name: "London",
        latitude: 51.5074,
        longitude: -0.1278,
        country: "UK",
        region: "England",
        timezoneId: "Europe/London"
    )
    
    static let sampleTokyo = LocationEntity(
        name: "Tokyo",
        latitude: 35.6762,
        longitude: 139.6503,
        country: "Japan",
        region: "Tokyo",
        timezoneId: "Asia/Tokyo"
    )
}