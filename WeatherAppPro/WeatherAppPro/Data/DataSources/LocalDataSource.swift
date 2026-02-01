//
//  LocalDataSource.swift
//  WeatherAppPro
//
//  Created by Donnadony Mollo on Feb 1, 2026.
//


/// Protocol for local data operations
protocol LocalDataSourceProtocol: Sendable {
    func saveWeather(_ weather: WeatherDataEntity) async
    func getCachedWeather(for locationId: UUID) async -> WeatherDataEntity?
    func saveRecentSearch(_ location: LocationEntity) async
    func getRecentSearches() async -> [LocationEntity]
    func clearWeatherCache() async
    func isCacheValid(for locationId: UUID) async -> Bool
}

/// Local data source using UserDefaults and file storage
final class LocalDataSource: LocalDataSourceProtocol {
    private let userDefaults: UserDefaults
    private let fileManager: FileManager
    private let cacheDirectory: URL
    
    /// Cache expiration time in seconds (30 minutes)
    private let cacheExpiration: TimeInterval = 30 * 60
    
    init(userDefaults: UserDefaults = .standard, fileManager: FileManager = .default) {
        self.userDefaults = userDefaults
        self.fileManager = fileManager
        
        // Create cache directory
        let cachesURL = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        self.cacheDirectory = cachesURL.appendingPathComponent("WeatherCache", isDirectory: true)
        
        // Ensure cache directory exists
        try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
    }
    
    // MARK: - Weather Cache
    
    func saveWeather(_ weather: WeatherDataEntity) async {
        let filename = "weather_\(weather.location.id.uuidString).json"
        let fileURL = cacheDirectory.appendingPathComponent(filename)
        
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            let data = try encoder.encode(weather)
            try data.write(to: fileURL)
            
            // Save timestamp
            userDefaults.set(Date().timeIntervalSince1970, forKey: "cache_timestamp_\(weather.location.id.uuidString)")
        } catch {
            print("Failed to save weather cache: \(error)")
        }
    }
    
    func getCachedWeather(for locationId: UUID) async -> WeatherDataEntity? {
        let filename = "weather_\(locationId.uuidString).json"
        let fileURL = cacheDirectory.appendingPathComponent(filename)
        
        guard fileManager.fileExists(atPath: fileURL.path) else {
            return nil
        }
        
        do {
            let data = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode(WeatherDataEntity.self, from: data)
        } catch {
            print("Failed to load weather cache: \(error)")
            return nil
        }
    }
    
    func clearWeatherCache() async {
        do {
            let files = try fileManager.contentsOfDirectory(at: cacheDirectory, includingPropertiesForKeys: nil)
            for file in files where file.lastPathComponent.hasPrefix("weather_") {
                try? fileManager.removeItem(at: file)
            }
        } catch {
            print("Failed to clear cache: \(error)")
        }
    }
    
    func isCacheValid(for locationId: UUID) async -> Bool {
        let timestampKey = "cache_timestamp_\(locationId.uuidString)"
        guard let timestamp = userDefaults.object(forKey: timestampKey) as? TimeInterval else {
            return false
        }
        
        let cacheDate = Date(timeIntervalSince1970: timestamp)
        let timeSinceCache = Date().timeIntervalSince(cacheDate)
        
        return timeSinceCache < cacheExpiration
    }
    
    // MARK: - Recent Searches
    
    func saveRecentSearch(_ location: LocationEntity) async {
        var searches = await getRecentSearches()
        
        // Remove if already exists (to move to front)
        searches.removeAll { $0.id == location.id }
        
        // Add to front
        searches.insert(location, at: 0)
        
        // Keep only last 10
        if searches.count > 10 {
            searches = Array(searches.prefix(10))
        }
        
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(searches)
            userDefaults.set(data, forKey: "recent_searches")
        } catch {
            print("Failed to save recent search: \(error)")
        }
    }
    
    func getRecentSearches() async -> [LocationEntity] {
        guard let data = userDefaults.data(forKey: "recent_searches") else {
            return []
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode([LocationEntity].self, from: data)
        } catch {
            print("Failed to load recent searches: \(error)")
            return []
        }
    }
}