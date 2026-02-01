import Foundation

//
//  HistoryRepositoryProtocol.swift
//  WeatherAppPro
//
//  Created by Donnadony Mollo on Feb 1, 2026.
//


/// Protocol defining history repository operations
protocol HistoryRepositoryProtocol: Sendable {
    /// Fetch historical weather for a specific date
    /// - Parameters:
    ///   - location: The location
    ///   - date: The historical date (must be in the past)
    /// - Returns: Historical weather data
    func getHistory(for location: LocationEntity, date: Date) async throws -> HistoricalWeatherEntity
    
    /// Fetch historical weather for a date range
    /// - Parameters:
    ///   - location: The location
    ///   - startDate: Start date
    ///   - endDate: End date
    /// - Returns: Array of historical weather data
    func getHistoryRange(for location: LocationEntity, startDate: Date, endDate: Date) async throws -> [HistoricalWeatherEntity]
}