//
//  TimeZoneRepositoryProtocol.swift
//  WeatherAppPro
//
//  Repository protocol for TimeZone data
//

import Foundation

/// Protocol defining time zone repository operations
protocol TimeZoneRepositoryProtocol: Sendable {
    /// Fetch time zone information for a location
    /// - Parameter location: The location to fetch timezone for
    /// - Returns: Time zone data
    func getTimeZone(for location: LocationEntity) async throws -> TimeZoneEntity
    
    /// Convert time between timezones
    /// - Parameters:
    ///   - date: Date to convert
    ///   - from: Source timezone
    ///   - to: Target timezone
    /// - Returns: Converted date string
    func convertTime(_ date: Date, from: String, to: String) async throws -> String
}