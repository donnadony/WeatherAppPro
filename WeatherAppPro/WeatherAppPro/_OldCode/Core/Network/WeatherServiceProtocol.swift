//
//  WeatherServiceProtocol.swift
//  WeatherAppPro
//
//  Created by Donnadony Mollo on Feb 1, 2026.
//


/// Protocol defining weather service operations
protocol WeatherServiceProtocol {
    func getCurrentWeather(for location: Location) async throws -> WeatherData
    func getForecast(for location: Location) async throws -> [DailyWeather]
}
