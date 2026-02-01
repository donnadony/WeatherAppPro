//
//  TimeZoneService.swift
//  WeatherAppPro
//
//  Created by Dony on 31/01/26
//

import Foundation

/// Time zone information service
final class TimeZoneService {
    
    private let apiKey = APIConfig.weatherAPIKey
    private let baseURL = "https://api.weatherapi.com/v1"
    
    func getTimeZone(for location: Location) async throws -> TimeZoneData {
        let urlString = "\(baseURL)/timezone.json?key=\(apiKey)&q=\(location.latitude),\(location.longitude)"
        
        guard let url = URL(string: urlString) else {
            throw WeatherError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw WeatherError.invalidResponse
        }
        
        let apiResponse = try JSONDecoder().decode(TimeZoneAPIResponse.self, from: data)
        
        return TimeZoneData(
            locationName: apiResponse.location.name,
            country: apiResponse.location.country,
            localtime: apiResponse.location.localtime,
            timezone: apiResponse.location.tz_id
        )
    }
}

// MARK: - Models

struct TimeZoneData {
    let locationName: String
    let country: String
    let localtime: String
    let timezone: String
}

struct TimeZoneAPIResponse: Codable {
    let location: TimeZoneLocation
}

struct TimeZoneLocation: Codable {
    let name: String
    let country: String
    let localtime: String
    let tz_id: String
}
