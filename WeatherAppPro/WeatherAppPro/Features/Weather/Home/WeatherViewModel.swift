//
//  WeatherViewModel.swift
//  WeatherAppPro
//
//  Created by Donnadony Mollo on Feb 1, 2026.
//

import Combine

/// View state for UI binding
enum WeatherViewState: Equatable {
    case idle
    case loading
    case success
    case error(String)
    case cached // Showing cached data due to network error
    
    var isLoading: Bool {
        if case .loading = self { return true }
        return false
    }
    
    var errorMessage: String? {
        if case .error(let msg) = self { return msg }
        return nil
    }
}

@MainActor
final class WeatherViewModel: ObservableObject, Sendable {
    
    // MARK: - Published State
    
    @Published var weatherData: WeatherDataEntity?
    @Published var viewState: WeatherViewState = .idle
    @Published var selectedLocation: LocationEntity = .sampleLima
    
    // MARK: - Dependencies
    
    private let getWeatherUseCase: GetWeatherUseCase
    private let searchLocationsUseCase: SearchLocationsUseCase
    
    // MARK: - Initialization
    
    init(
        getWeatherUseCase: GetWeatherUseCase,
        searchLocationsUseCase: SearchLocationsUseCase
    ) {
        self.getWeatherUseCase = getWeatherUseCase
        self.searchLocationsUseCase = searchLocationsUseCase
    }
    
    // MARK: - Public Methods
    
    /// Fetch weather for the selected location
    func fetchWeather(forceRefresh: Bool = false) async {
        viewState = .loading
        
        let result = await getWeatherUseCase.execute(for: selectedLocation, forceRefresh: forceRefresh)
        
        switch result {
        case .success(let weather):
            weatherData = weather
            viewState = weather.dataSource == .cache ? .cached : .success
        case .failure(let error):
            viewState = .error(error.localizedDescription)
            // Load mock data as fallback
            weatherData = MockData.weatherData(for: selectedLocation)
        }
    }
    
    /// Refresh weather (force remote fetch)
    func refresh() async {
        await fetchWeather(forceRefresh: true)
    }
    
    /// Change the selected location
    func selectLocation(_ location: LocationEntity) async {
        selectedLocation = location
        await fetchWeather(forceRefresh: true)
        
        // Save to recent searches
        await searchLocationsUseCase.saveRecentSearch(location)
    }
    
    /// Check if we have fresh cached data
    func hasFreshCache() async -> Bool {
        await getWeatherUseCase.hasFreshCache(for: selectedLocation)
    }
    
    // MARK: - Computed Properties for Views
    
    var currentTemperature: Double {
        weatherData?.current.temperature ?? 0
    }
    
    var weatherCondition: String {
        weatherData?.current.condition ?? "Sunny"
    }
    
    var hourlyForecast: [HourlyWeatherEntity]? {
        weatherData?.hourlyForecast
    }
    
    var dailyForecast: [DailyWeatherEntity]? {
        weatherData?.dailyForecast
    }
    
    var locationName: String {
        weatherData?.location.name ?? selectedLocation.name
    }
    
    var isShowingCachedData: Bool {
        viewState == .cached
    }
    
    var lastUpdatedText: String {
        guard let date = weatherData?.lastUpdated else { return "" }
        let formatter = RelativeDateTimeFormatter()
        return "Updated \(formatter.localizedString(for: date, relativeTo: Date()))"
    }
}

// MARK: - Mock Data

enum MockData {
    static func weatherData(for location: LocationEntity) -> WeatherDataEntity {
        WeatherDataEntity(
            location: location,
            current: WeatherEntity(
                locationId: location.id,
                temperature: 22.5,
                feelsLike: 20.0,
                condition: "Sunny",
                conditionCode: 1000,
                humidity: 65,
                windSpeed: 12.3,
                windDirection: "NW",
                pressure: 1013.0,
                uvIndex: 7.0,
                visibility: 10.0,
                isDay: true
            ),
            hourlyForecast: hourlyForecast,
            dailyForecast: dailyForecast,
            lastUpdated: Date(),
            dataSource: .mock
        )
    }
    
    static let hourlyForecast: [HourlyWeatherEntity] = (0..<24).map { hour in
        let conditions = ["Sunny", "Cloudy", "Light rain", "Partly cloudy"]
        let condition = conditions[hour % conditions.count]
        return HourlyWeatherEntity(
            hour: String(format: "%02d:00", hour),
            temperature: Double.random(in: 18...28),
            condition: condition,
            icon: WeatherIconMapper.icon(for: condition),
            chanceOfRain: hour > 12 && hour < 18 ? 30 : nil,
            isDay: hour >= 6 && hour < 18
        )
    }
    
    static let dailyForecast: [DailyWeatherEntity] = {
        let days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
        let conditions = ["Sunny", "Cloudy", "Light rain", "Partly cloudy", "Clear"]
        
        return days.enumerated().map { index, day in
            let condition = conditions[index % conditions.count]
            return DailyWeatherEntity(
                date: Date().addingTimeInterval(TimeInterval(index * 24 * 60 * 60)),
                dayName: day,
                high: Double.random(in: 22...30),
                low: Double.random(in: 15...20),
                condition: condition,
                icon: WeatherIconMapper.icon(for: condition),
                chanceOfRain: index % 3 == 0 ? 40 : nil
            )
        }
    }()
}