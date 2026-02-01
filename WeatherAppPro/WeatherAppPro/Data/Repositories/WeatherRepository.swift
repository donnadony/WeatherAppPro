//
//  WeatherRepository.swift
//  WeatherAppPro
//
//  Created by Donnadony Mollo on Feb 1, 2026.
//


/// Weather repository implementing the caching strategy:
/// 1. Try remote first
/// 2. On success: save to cache, return data
/// 3. On failure: try cache
/// 4. If cache miss: return error
final class WeatherRepository: WeatherRepositoryProtocol {
    private let remoteDataSource: RemoteDataSourceProtocol
    private let localDataSource: LocalDataSourceProtocol
    
    init(
        remoteDataSource: RemoteDataSourceProtocol,
        localDataSource: LocalDataSourceProtocol
    ) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
    }
    
    func getWeather(for location: LocationEntity, forceRefresh: Bool) async throws -> WeatherDataEntity {
        // Check cache first if not forcing refresh
        if !forceRefresh {
            if let cached = await localDataSource.getCachedWeather(for: location.id),
               await localDataSource.isCacheValid(for: location.id) {
                return cached
            }
        }
        
        do {
            // Fetch from remote
            let apiResponse = try await remoteDataSource.fetchWeather(for: location)
            let domainData = WeatherMapper.mapWeatherData(apiResponse)
            
            // Save to cache
            await localDataSource.saveWeather(domainData)
            
            return domainData
        } catch let error as NetworkError {
            // Try cache as fallback
            if let cached = await localDataSource.getCachedWeather(for: location.id) {
                var cachedWithFallback = cached
                // Mark as cache source
                return WeatherDataEntity(
                    location: cached.location,
                    current: cached.current,
                    hourlyForecast: cached.hourlyForecast,
                    dailyForecast: cached.dailyForecast,
                    lastUpdated: cached.lastUpdated,
                    dataSource: .cache
                )
            }
            throw error.toDomainError
        } catch {
            throw DomainError.unknown(error.localizedDescription)
        }
    }
    
    func getForecast(for location: LocationEntity) async throws -> [DailyWeatherEntity] {
        let weather = try await getWeather(for: location)
        return weather.dailyForecast
    }
    
    func getHourlyForecast(for location: LocationEntity, date: Date) async throws -> [HourlyWeatherEntity] {
        let weather = try await getWeather(for: location)
        // Filter for the specific date if needed
        // For now, return all hourly data (it's for the current day)
        return weather.hourlyForecast
    }
    
    func clearCache() async {
        await localDataSource.clearWeatherCache()
    }
    
    func hasFreshCache(for location: LocationEntity) async -> Bool {
        await localDataSource.isCacheValid(for: location.id)
    }
}