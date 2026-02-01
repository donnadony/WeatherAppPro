//
//  HistoryRepository.swift
//  WeatherAppPro
//
//  Repository implementation for Historical Weather data
//

import Foundation

final class HistoryRepository: HistoryRepositoryProtocol {
    private let remoteDataSource: RemoteDataSourceProtocol
    
    init(remoteDataSource: RemoteDataSourceProtocol) {
        self.remoteDataSource = remoteDataSource
    }
    
    func getHistory(for location: LocationEntity, date: Date) async throws -> HistoricalWeatherEntity {
        // Validate date is in the past
        guard date < Date() else {
            throw DomainError.invalidDate
        }
        
        do {
            let response = try await remoteDataSource.fetchHistory(for: location, date: date)
            return WeatherMapper.mapHistory(response, locationId: location.id, date: date)
        } catch let error as NetworkError {
            throw error.toDomainError
        } catch {
            throw DomainError.unknown(error.localizedDescription)
        }
    }
    
    func getHistoryRange(for location: LocationEntity, startDate: Date, endDate: Date) async throws -> [HistoricalWeatherEntity] {
        var results: [HistoricalWeatherEntity] = []
        var currentDate = startDate
        
        while currentDate <= endDate {
            let history = try await getHistory(for: location, date: currentDate)
            results.append(history)
            
            // Move to next day
            guard let nextDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate) else {
                break
            }
            currentDate = nextDate
        }
        
        return results
    }
}