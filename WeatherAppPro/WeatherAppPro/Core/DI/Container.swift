//
//  Container.swift
//  WeatherAppPro
//
//  Dependency Injection Container - Centralized dependency creation
//

import Foundation

/// The DI Container manages all dependencies in the app
/// This is the single source of truth for object creation
@MainActor
final class Container: Sendable {
    
    // MARK: - Singleton
    
    static let shared = Container()
    
    private init() {
        // Private initializer to enforce singleton
    }
    
    // MARK: - Data Sources
    
    private(set) lazy var remoteDataSource: RemoteDataSourceProtocol = {
        RemoteDataSource()
    }()
    
    private(set) lazy var localDataSource: LocalDataSourceProtocol = {
        LocalDataSource()
    }()
    
    // MARK: - Repositories
    
    private(set) lazy var weatherRepository: WeatherRepositoryProtocol = {
        WeatherRepository(
            remoteDataSource: remoteDataSource,
            localDataSource: localDataSource
        )
    }()
    
    private(set) lazy var locationSearchRepository: LocationSearchRepositoryProtocol = {
        LocationSearchRepository(
            remoteDataSource: remoteDataSource,
            localDataSource: localDataSource
        )
    }()
    
    private(set) lazy var astronomyRepository: AstronomyRepositoryProtocol = {
        AstronomyRepository(remoteDataSource: remoteDataSource)
    }()
    
    private(set) lazy var timeZoneRepository: TimeZoneRepositoryProtocol = {
        TimeZoneRepository(remoteDataSource: remoteDataSource)
    }()
    
    private(set) lazy var historyRepository: HistoryRepositoryProtocol = {
        HistoryRepository(remoteDataSource: remoteDataSource)
    }()
    
    // MARK: - Use Cases
    
    func makeGetWeatherUseCase() -> GetWeatherUseCase {
        GetWeatherUseCase(repository: weatherRepository)
    }
    
    func makeSearchLocationsUseCase() -> SearchLocationsUseCase {
        SearchLocationsUseCase(repository: locationSearchRepository)
    }
    
    func makeGetAstronomyUseCase() -> GetAstronomyUseCase {
        GetAstronomyUseCase(repository: astronomyRepository)
    }
    
    func makeGetTimeZoneUseCase() -> GetTimeZoneUseCase {
        GetTimeZoneUseCase(repository: timeZoneRepository)
    }
    
    func makeGetHistoryUseCase() -> GetHistoryUseCase {
        GetHistoryUseCase(repository: historyRepository)
    }
    
    // MARK: - ViewModels
    
    func makeWeatherViewModel() -> WeatherViewModel {
        WeatherViewModel(
            getWeatherUseCase: makeGetWeatherUseCase(),
            searchLocationsUseCase: makeSearchLocationsUseCase()
        )
    }
    
    func makeSearchViewModel() -> SearchViewModel {
        SearchViewModel(searchLocationsUseCase: makeSearchLocationsUseCase())
    }
    
    func makeAstronomyViewModel(location: LocationEntity) -> AstronomyViewModel {
        AstronomyViewModel(
            location: location,
            getAstronomyUseCase: makeGetAstronomyUseCase()
        )
    }
    
    func makeTimeZoneViewModel(location: LocationEntity) -> TimeZoneViewModel {
        TimeZoneViewModel(
            location: location,
            getTimeZoneUseCase: makeGetTimeZoneUseCase()
        )
    }
    
    func makeHistoryViewModel(location: LocationEntity) -> HistoryViewModel {
        HistoryViewModel(
            location: location,
            getHistoryUseCase: makeGetHistoryUseCase()
        )
    }
    
    func makeSettingsViewModel() -> SettingsViewModel {
        SettingsViewModel()
    }
}

// MARK: - Preview Container (for SwiftUI Previews)

extension Container {
    /// Container with mock dependencies for previews
    static var preview: Container {
        let container = Container()
        // In a real implementation, you might inject mock repositories here
        return container
    }
}