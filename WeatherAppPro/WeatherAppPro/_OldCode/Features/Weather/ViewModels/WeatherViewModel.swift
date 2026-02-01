//
//  WeatherViewModel.swift
//  WeatherAppPro
//
//  Created by Dony on 31/01/26
//

import Foundation
import Combine

@MainActor
final class WeatherViewModel: ObservableObject {
    @Published var weatherData: WeatherData?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var selectedLocation: Location = .sample
    
    private let weatherService: WeatherServiceProtocol
    
    init(weatherService: WeatherServiceProtocol = WeatherService()) {
        self.weatherService = weatherService
    }
    
    func fetchWeather() async {
        isLoading = true
        errorMessage = nil
        do {
            let data = try await weatherService.getCurrentWeather(for: selectedLocation)
            weatherData = data
        } catch {
            errorMessage = "Failed to fetch weather: \(error.localizedDescription)"
            weatherData = generateMockData()
        }
        isLoading = false
    }
    
    func refresh() async {
        await fetchWeather()
    }
    
    private func generateMockData() -> WeatherData {
        WeatherData(
            temperature: 22.5,
            feelsLike: 20.0,
            condition: "Sunny",
            humidity: 65,
            windSpeed: 12.3,
            location: selectedLocation,
            hourlyForecast: generateMockHourly(),
            dailyForecast: generateMockDaily()
        )
    }
    
    private func generateMockHourly() -> [HourlyWeather] {
        (0..<24).map { hour in
            let condition = ["Sunny", "Cloudy", "Light rain", "Partly cloudy"].randomElement()!
            return HourlyWeather(
                hour: "\(hour):00",
                temperature: Double.random(in: 18...28),
                condition: condition,
                icon: WeatherIconMapper.icon(for: condition)
            )
        }
    }
    
    private func generateMockDaily() -> [DailyWeather] {
        let days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
        return days.map { day in
            let condition = ["Sunny", "Cloudy", "Light rain", "Partly cloudy", "Clear"].randomElement()!
            return DailyWeather(
                day: day,
                high: Double.random(in: 22...30),
                low: Double.random(in: 15...20),
                condition: condition,
                icon: WeatherIconMapper.icon(for: condition)
            )
        }
    }
}
