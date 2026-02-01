//
//  GetWeatherUseCase.swift
//  WeatherAppPro
//
//  Created by Donnadony Mollo on Feb 1, 2026.
//


/// Use case for getting weather data
/// Encapsulates the business logic for weather retrieval including caching strategy
@MainActor
final class GetWeatherUseCase: Sendable {
    private let repository: WeatherRepositoryProtocol
    
    init(repository: WeatherRepositoryProtocol) {
        self.repository = repository
    }
    
    /// Execute the use case
    /// - Parameters:
    ///   - location: The location to fetch weather for
    ///   - forceRefresh: If true, always fetch from remote
    /// - Returns: Result with weather data or domain error
    func execute(for location: LocationEntity, forceRefresh: Bool = false) async -> Result<WeatherDataEntity> {
        do {
            let weather = try await repository.getWeather(for: location, forceRefresh: forceRefresh)
            return .success(weather)
        } catch let error as DomainError {
            return .failure(error)
        } catch {
            return .failure(.unknown(error.localizedDescription))
        }
    }
    
    /// Check if we have fresh cached data
    func hasFreshCache(for location: LocationEntity) async -> Bool {
        await repository.hasFreshCache(for: location)
    }
}