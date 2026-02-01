//
//  WeatherServiceProtocol.swift
//  WeatherAppPro
//
//  Created by Dony on 31/01/26
//

import Foundation

/// Protocol defining weather service operations
protocol WeatherServiceProtocol {
    func getCurrentWeather(for location: Location) async throws -> WeatherData
    func getForecast(for location: Location) async throws -> [DailyWeather]
}
