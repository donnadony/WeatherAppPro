//
//  LocationSearchRepository.swift
//  WeatherAppPro
//
//  Created by Donnadony Mollo on Feb 1, 2026.
//


final class LocationSearchRepository: LocationSearchRepositoryProtocol {
    private let remoteDataSource: RemoteDataSourceProtocol
    private let localDataSource: LocalDataSourceProtocol
    
    init(
        remoteDataSource: RemoteDataSourceProtocol,
        localDataSource: LocalDataSourceProtocol
    ) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
    }
    
    func searchLocations(query: String) async throws -> [LocationEntity] {
        guard query.count >= 2 else {
            throw DomainError.invalidLocation
        }
        
        do {
            let results = try await remoteDataSource.searchLocations(query: query)
            return results.map(WeatherMapper.mapSearchResult)
        } catch let error as NetworkError {
            throw error.toDomainError
        } catch {
            throw DomainError.unknown(error.localizedDescription)
        }
    }
    
    func getLocationByCoordinates(latitude: Double, longitude: Double) async throws -> LocationEntity {
        let tempLocation = LocationEntity(
            name: "",
            latitude: latitude,
            longitude: longitude,
            country: ""
        )
        
        do {
            // Use timezone endpoint to get location info from coordinates
            let response = try await remoteDataSource.fetchTimeZone(for: tempLocation)
            return LocationEntity(
                name: response.location.name,
                latitude: latitude,
                longitude: longitude,
                country: response.location.country,
                timezoneId: response.location.tz_id
            )
        } catch let error as NetworkError {
            throw error.toDomainError
        } catch {
            throw DomainError.unknown(error.localizedDescription)
        }
    }
    
    func getRecentSearches() async -> [LocationEntity] {
        await localDataSource.getRecentSearches()
    }
    
    func saveRecentSearch(_ location: LocationEntity) async {
        await localDataSource.saveRecentSearch(location)
    }
}