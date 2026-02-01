//
//  AstronomyEntity.swift
//  WeatherAppPro
//
//  Created by Donnadony Mollo on Feb 1, 2026.
//


/// Astronomy data - domain entity
struct AstronomyEntity: Identifiable, Codable, Hashable, Sendable {
    let id: UUID
    let locationId: UUID
    let date: Date
    let sunrise: String
    let sunset: String
    let moonrise: String
    let moonset: String
    let moonPhase: String
    let moonIllumination: Int
    let isMoonUp: Bool
    let isSunUp: Bool
    
    init(
        id: UUID = UUID(),
        locationId: UUID,
        date: Date,
        sunrise: String,
        sunset: String,
        moonrise: String,
        moonset: String,
        moonPhase: String,
        moonIllumination: Int,
        isMoonUp: Bool = false,
        isSunUp: Bool = true
    ) {
        self.id = id
        self.locationId = locationId
        self.date = date
        self.sunrise = sunrise
        self.sunset = sunset
        self.moonrise = moonrise
        self.moonset = moonset
        self.moonPhase = moonPhase
        self.moonIllumination = moonIllumination
        self.isMoonUp = isMoonUp
        self.isSunUp = isSunUp
    }
}

// MARK: - Moon Phase Helpers

extension AstronomyEntity {
    /// Returns a SF Symbol icon name for the moon phase
    var moonPhaseIcon: String {
        let phase = moonPhase.lowercased()
        switch phase {
        case let p where p.contains("new"):
            return "moon"
        case let p where p.contains("waxing crescent"):
            return "moon.fill"
        case let p where p.contains("first quarter"):
            return "moon.circle.fill"
        case let p where p.contains("waxing gibbous"):
            return "moon.circle"
        case let p where p.contains("full"):
            return "moon.stars.fill"
        case let p where p.contains("waning gibbous"):
            return "moon.circle"
        case let p where p.contains("last quarter"):
            return "moon.circle.fill"
        case let p where p.contains("waning crescent"):
            return "moon.fill"
        default:
            return "moon.fill"
        }
    }
}