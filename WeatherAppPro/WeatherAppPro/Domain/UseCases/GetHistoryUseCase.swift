//
//  GetHistoryUseCase.swift
//  WeatherAppPro
//
//  Created by Donnadony Mollo on Feb 1, 2026.
//

import Foundation

/// Use case for getting historical weather data
@MainActor
final class GetHistoryUseCase: Sendable {
    private let repository: HistoryRepositoryProtocol
    
    init(repository: HistoryRepositoryProtocol) {
        self.repository = repository
    }
    
    /// Execute the use case
    /// - Parameters:
    ///   - location: The location
    ///   - date: The historical date
    /// - Returns: Result with historical weather data or domain error
    func execute(for location: LocationEntity, date: Date) async -> Result<HistoricalWeatherEntity> {
        // Validate date is in the past
        guard date < Date() else {
            return .failure(.invalidDate)
        }
        
        do {
            let history = try await repository.getHistory(for: location, date: date)
            return .success(history)
        } catch let error as DomainError {
            return .failure(error)
        } catch {
            return .failure(.unknown(error.localizedDescription))
        }
    }
    
    /// Validate if a date is valid for historical queries
    /// - Parameter date: The date to validate
    /// - Returns: True if the date is valid (in the past, after Jan 1 2010)
    func isValidDate(_ date: Date) -> Bool {
        let calendar = Calendar.current
        let now = Date()
        
        // Must be in the past
        guard date < now else { return false }
        
        // Must be after Jan 1, 2010 (API limitation)
        guard let minDate = calendar.date(from: DateComponents(year: 2010, month: 1, day: 1)),
              date >= minDate else { return false }
        
        return true
    }
}