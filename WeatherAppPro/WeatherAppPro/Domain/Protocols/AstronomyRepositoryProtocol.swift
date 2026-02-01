//
//  AstronomyRepositoryProtocol.swift
//  WeatherAppPro
//
//  Repository protocol for Astronomy data
//

import Foundation

/// Protocol defining astronomy repository operations
protocol AstronomyRepositoryProtocol: Sendable {
    /// Fetch astronomy data for a location and date
    /// - Parameters:
    ///   - location: The location to fetch data for
    ///   - date: The date (defaults to today)
    /// - Returns: Astronomy data including sun/moon times
    func getAstronomy(for location: LocationEntity, date: Date) async throws -> AstronomyEntity
    
    /// Fetch astronomy data for a date range
    /// - Parameters:
    ///   - location: The location
    ///   - startDate: Start of range
    ///   - endDate: End of range
    /// - Returns: Array of astronomy data
    func getAstronomyRange(for location: LocationEntity, startDate: Date, endDate: Date) async throws -> [AstronomyEntity]
}

// MARK: - Default Implementation

extension AstronomyRepositoryProtocol {
    func getAstronomy(for location: LocationEntity) async throws -> AstronomyEntity {
        try await getAstronomy(for: location, date: Date())
    }
}