//
//  WeatherService.swift
//  WeatherAppPro
//
//  Created by Dony on 31/01/26
//

import Foundation

final class WeatherService: WeatherServiceProtocol {
    private let apiKey = APIConfig.weatherAPIKey
    private let baseURL = "https://api.weatherapi.com/v1"
    
    func getCurrentWeather(for location: Location) async throws -> WeatherData {
        let urlString = "\(baseURL)/forecast.json?key=\(apiKey)&q=\(location.latitude),\(location.longitude)&days=7&aqi=no"
        guard let url = URL(string: urlString) else {
            throw WeatherError.invalidURL
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw WeatherError.invalidResponse
        }
        let apiResponse = try JSONDecoder().decode(WeatherAPIResponse.self, from: data)
        return convertToWeatherData(apiResponse)
    }
    
    func getForecast(for location: Location) async throws -> [DailyWeather] {
        let weatherData = try await getCurrentWeather(for: location)
        return weatherData.dailyForecast
    }
    
    private func convertToWeatherData(_ response: WeatherAPIResponse) -> WeatherData {
        let location = Location(
            name: response.location.name,
            latitude: response.location.lat,
            longitude: response.location.lon,
            country: response.location.country
        )
        let hourlyForecast = response.forecast?.forecastday.first?.hour.map { hour in
            HourlyWeather(
                hour: formatHour(hour.time),
                temperature: hour.temp_c,
                condition: hour.condition.text,
                icon: WeatherIconMapper.icon(for: hour.condition.text)
            )
        } ?? []
        let dailyForecast = response.forecast?.forecastday.map { day in
            DailyWeather(
                day: formatDay(day.date),
                high: day.day.maxtemp_c,
                low: day.day.mintemp_c,
                condition: day.day.condition.text,
                icon: WeatherIconMapper.icon(for: day.day.condition.text)
            )
        } ?? []
        return WeatherData(
            temperature: response.current.temp_c,
            feelsLike: response.current.feelslike_c,
            condition: response.current.condition.text,
            humidity: response.current.humidity,
            windSpeed: response.current.wind_kph,
            location: location,
            hourlyForecast: hourlyForecast,
            dailyForecast: dailyForecast
        )
    }
    
    private func formatHour(_ timeString: String) -> String {
        let components = timeString.split(separator: " ")
        return components.count > 1 ? String(components[1]) : timeString
    }
    
    private func formatDay(_ dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let date = formatter.date(from: dateString) else {
            return dateString
        }
        formatter.dateFormat = "EEE"
        return formatter.string(from: date)
    }
}

enum WeatherError: Error {
    case invalidURL
    case invalidResponse
    case decodingError
}
