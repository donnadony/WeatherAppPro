//
//  GetTimeZoneUseCase.swift
//  WeatherAppPro
//
//  Created by Donnadony Mollo on Feb 1, 2026.
//


/// Use case for getting timezone data
@MainActor
final class GetTimeZoneUseCase: Sendable {
    private let repository: TimeZoneRepositoryProtocol
    
    init(repository: TimeZoneRepositoryProtocol) {
        self.repository = repository
    }
    
    /// Execute the use case
    /// - Parameter location: The location
    /// - Returns: Result with timezone data or domain error
    func execute(for location: LocationEntity) async -> Result<TimeZoneEntity> {
        do {
            let timeZone = try await repository.getTimeZone(for: location)
            return .success(timeZone)
        } catch let error as DomainError {
            return .failure(error)
        } catch {
            return .failure(.unknown(error.localizedDescription))
        }
    }
}