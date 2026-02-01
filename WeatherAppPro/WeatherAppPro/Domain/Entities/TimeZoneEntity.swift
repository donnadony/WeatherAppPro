//
//  TimeZoneEntity.swift
//  WeatherAppPro
//
//  Domain entity for TimeZone data - framework independent
//

import Foundation

/// Time zone data - domain entity
struct TimeZoneEntity: Identifiable, Codable, Hashable, Sendable {
    let id: UUID
    let locationId: UUID
    let locationName: String
    let country: String
    let localtime: String
    let timezone: String
    let utcOffset: String?
    
    init(
        id: UUID = UUID(),
        locationId: UUID,
        locationName: String,
        country: String,
        localtime: String,
        timezone: String,
        utcOffset: String? = nil
    ) {
        self.id = id
        self.locationId = locationId
        self.locationName = locationName
        self.country = country
        self.localtime = localtime
        self.timezone = timezone
        self.utcOffset = utcOffset
    }
    
    /// Parsed date from localtime string
    var parsedLocalDate: Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter.date(from: localtime)
    }
}