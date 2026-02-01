//
//  LocationSearchRepositoryProtocol.swift
//  WeatherAppPro
//
//  Created by Donnadony Mollo on Feb 1, 2026.
//


/// Protocol defining location search repository operations
protocol LocationSearchRepositoryProtocol: Sendable {
    /// Search for locations by name
    /// - Parameter query: Search query string
    /// - Returns: Array of matching locations
    func searchLocations(query: String) async throws -> [LocationEntity]
    
    /// Get location by coordinates (reverse geocoding)
    /// - Parameters:
    ///   - latitude: Latitude
    ///   - longitude: Longitude
    /// - Returns: Location at coordinates
    func getLocationByCoordinates(latitude: Double, longitude: Double) async throws -> LocationEntity
    
    /// Get recent searches (cached locally)
    /// - Returns: Array of recently searched locations
    func getRecentSearches() async -> [LocationEntity]
    
    /// Save a location to recent searches
    /// - Parameter location: Location to save
    func saveRecentSearch(_ location: LocationEntity) async
}