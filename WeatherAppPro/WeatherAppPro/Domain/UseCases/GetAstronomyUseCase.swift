//
//  GetAstronomyUseCase.swift
//  WeatherAppPro
//
//  Created by Donnadony Mollo on Feb 1, 2026.
//

import Foundation

/// Use case for getting astronomy data
@MainActor
final class GetAstronomyUseCase: Sendable {
    private let repository: AstronomyRepositoryProtocol
    
    init(repository: AstronomyRepositoryProtocol) {
        self.repository = repository
    }
    
    /// Execute the use case
    /// - Parameters:
    ///   - location: The location
    ///   - date: The date (defaults to today)
    /// - Returns: Result with astronomy data or domain error
    func execute(for location: LocationEntity, date: Date = Date()) async -> Result<AstronomyEntity> {
        do {
            let astronomy = try await repository.getAstronomy(for: location, date: date)
            return .success(astronomy)
        } catch let error as DomainError {
            return .failure(error)
        } catch {
            return .failure(.unknown(error.localizedDescription))
        }
    }
}