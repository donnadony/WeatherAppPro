//
//  SearchLocationsUseCase.swift
//  WeatherAppPro
//
//  Use case for searching locations
//

import Foundation

/// Use case for searching locations
@MainActor
final class SearchLocationsUseCase: Sendable {
    private let repository: LocationSearchRepositoryProtocol
    
    init(repository: LocationSearchRepositoryProtocol) {
        self.repository = repository
    }
    
    /// Execute the use case
    /// - Parameter query: Search query
    /// - Returns: Result with array of locations or domain error
    func execute(query: String) async -> Result<[LocationEntity]> {
        guard !query.isEmpty else {
            return .success([])
        }
        
        guard query.count >= 2 else {
            return .failure(.invalidLocation)
        }
        
        do {
            let locations = try await repository.searchLocations(query: query)
            return .success(locations)
        } catch let error as DomainError {
            return .failure(error)
        } catch {
            return .failure(.unknown(error.localizedDescription))
        }
    }
    
    /// Get recent searches
    func getRecentSearches() async -> [LocationEntity] {
        await repository.getRecentSearches()
    }
    
    /// Save a location to recent searches
    func saveRecentSearch(_ location: LocationEntity) async {
        await repository.saveRecentSearch(location)
    }
}