//
//  WeatherRepositoryProtocol.swift
//  WeatherAppPro
//
//  Created by Donnadony Mollo on Feb 1, 2026.
//


/// Protocol defining weather repository operations
/// This is the boundary between domain and data layers
protocol WeatherRepositoryProtocol: Sendable {
    /// Fetch current weather and forecast for a location
    /// - Parameters:
    ///   - location: The location to fetch weather for
    ///   - forceRefresh: If true, bypass cache and fetch from remote
    /// - Returns: Complete weather data including current conditions and forecasts
    func getWeather(for location: LocationEntity, forceRefresh: Bool) async throws -> WeatherDataEntity
    
    /// Fetch only the forecast data
    /// - Parameter location: The location to fetch forecast for
    /// - Returns: Array of daily forecasts
    func getForecast(for location: LocationEntity) async throws -> [DailyWeatherEntity]
    
    /// Fetch hourly forecast for a specific day
    /// - Parameters:
    ///   - location: The location
    ///   - date: The specific date
    /// - Returns: Array of hourly forecasts
    func getHourlyForecast(for location: LocationEntity, date: Date) async throws -> [HourlyWeatherEntity]
    
    /// Clear cached weather data
    func clearCache() async
    
    /// Check if cached data exists and is fresh (less than 30 minutes old)
    /// - Parameter location: The location to check
    /// - Returns: True if fresh cached data exists
    func hasFreshCache(for location: LocationEntity) async -> Bool
}

// MARK: - Default Implementation for Optional Parameters

extension WeatherRepositoryProtocol {
    func getWeather(for location: LocationEntity) async throws -> WeatherDataEntity {
        try await getWeather(for: location, forceRefresh: false)
    }
}