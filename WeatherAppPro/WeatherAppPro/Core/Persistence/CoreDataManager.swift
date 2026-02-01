//
//  CoreDataManager.swift
//  WeatherAppPro
//
//  Created by Donnadony Mollo on Feb 1, 2026.
//

import CoreData

/// Core Data manager for offline caching
final class CoreDataManager {
    static let shared = CoreDataManager()
    
    private init() {}
    
    // TODO: Implement Core Data stack
    // Add .xcdatamodeld file in Xcode for weather caching
    
    func saveWeather(_ weather: WeatherData) {
        // Save weather data for offline access
    }
    
    func fetchCachedWeather() -> WeatherData? {
        // Retrieve cached weather
        return nil
    }
}
