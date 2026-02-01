//
//  AstronomyRepository.swift
//  WeatherAppPro
//
//  Repository implementation for Astronomy data
//

import Foundation

final class AstronomyRepository: AstronomyRepositoryProtocol {
    private let remoteDataSource: RemoteDataSourceProtocol
    
    init(remoteDataSource: RemoteDataSourceProtocol) {
        self.remoteDataSource = remoteDataSource
    }
    
    func getAstronomy(for location: LocationEntity, date: Date) async throws -> AstronomyEntity {
        do {
            let response = try await remoteDataSource.fetchAstronomy(for: location, date: date)
            return WeatherMapper.mapAstronomy(response, locationId: location.id, date: date)
        } catch let error as NetworkError {
            throw error.toDomainError
        } catch {
            throw DomainError.unknown(error.localizedDescription)
        }
    }
    
    func getAstronomyRange(for location: LocationEntity, startDate: Date, endDate: Date) async throws -> [AstronomyEntity] {
        var results: [AstronomyEntity] = []
        var currentDate = startDate
        
        while currentDate <= endDate {
            let astronomy = try await getAstronomy(for: location, date: currentDate)
            results.append(astronomy)
            
            // Move to next day
            currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
        }
        
        return results
    }
}