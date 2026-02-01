//
//  TimeZoneRepository.swift
//  WeatherAppPro
//
//  Created by Donnadony Mollo on Feb 1, 2026.
//

import Foundation

final class TimeZoneRepository: TimeZoneRepositoryProtocol {
    private let remoteDataSource: RemoteDataSourceProtocol
    
    init(remoteDataSource: RemoteDataSourceProtocol) {
        self.remoteDataSource = remoteDataSource
    }
    
    func getTimeZone(for location: LocationEntity) async throws -> TimeZoneEntity {
        do {
            let response = try await remoteDataSource.fetchTimeZone(for: location)
            return WeatherMapper.mapTimeZone(response, locationId: location.id)
        } catch let error as NetworkError {
            throw error.toDomainError
        } catch {
            throw DomainError.unknown(error.localizedDescription)
        }
    }
    
    func convertTime(_ date: Date, from: String, to: String) async throws -> String {
        // For now, return formatted local time
        // In production, you might use a time conversion API or library
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        formatter.timeZone = TimeZone(identifier: to)
        return formatter.string(from: date)
    }
}