//
//  Location.swift
//  WeatherAppPro
//
//  Created by Donnadony Mollo on Feb 1, 2026.
//

import Foundation

/// Location model
struct Location: Identifiable, Codable, Hashable {
    let id: UUID
    let name: String
    let latitude: Double
    let longitude: Double
    let country: String
    
    init(
        id: UUID = UUID(),
        name: String,
        latitude: Double,
        longitude: Double,
        country: String = ""
    ) {
        self.id = id
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.country = country
    }
    
    // Sample locations for preview
    static let sample = Location(
        name: "Lima",
        latitude: -12.0464,
        longitude: -77.0428,
        country: "Peru"
    )
}
