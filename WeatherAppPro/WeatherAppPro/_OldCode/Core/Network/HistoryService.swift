//
//  HistoryService.swift
//  WeatherAppPro
//
//  Created by Donnadony Mollo on Feb 1, 2026.
//


/// Historical weather data service
final class HistoryService {
    
    private let apiKey = APIConfig.weatherAPIKey
    private let baseURL = "https://api.weatherapi.com/v1"
    
    func getHistory(for location: Location, date: Date) async throws -> HistoricalWeatherData {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date)
        
        let urlString = "\(baseURL)/history.json?key=\(apiKey)&q=\(location.latitude),\(location.longitude)&dt=\(dateString)"
        
        guard let url = URL(string: urlString) else {
            throw WeatherError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw WeatherError.invalidResponse
        }
        
        let apiResponse = try JSONDecoder().decode(HistoryAPIResponse.self, from: data)
        
        guard let forecastDay = apiResponse.forecast.forecastday.first else {
            throw WeatherError.invalidResponse
        }
        
        return HistoricalWeatherData(
            date: forecastDay.date,
            maxTemp: forecastDay.day.maxtemp_c,
            minTemp: forecastDay.day.mintemp_c,
            avgTemp: forecastDay.day.avgtemp_c,
            condition: forecastDay.day.condition.text,
            maxWind: forecastDay.day.maxwind_kph,
            avgHumidity: forecastDay.day.avghumidity
        )
    }
}

// MARK: - Models

struct HistoricalWeatherData {
    let date: String
    let maxTemp: Double
    let minTemp: Double
    let avgTemp: Double
    let condition: String
    let maxWind: Double
    let avgHumidity: Double
}

struct HistoryAPIResponse: Codable {
    let forecast: HistoryForecast
}

struct HistoryForecast: Codable {
    let forecastday: [HistoryForecastDay]
}

struct HistoryForecastDay: Codable {
    let date: String
    let day: HistoryDay
}

struct HistoryDay: Codable {
    let maxtemp_c: Double
    let mintemp_c: Double
    let avgtemp_c: Double
    let maxwind_kph: Double
    let avghumidity: Double
    let condition: APICondition
}
