//
//  AstronomyService.swift
//  WeatherAppPro
//
//  Created by Donnadony Mollo on Feb 1, 2026.
//


final class AstronomyService {
    private let apiKey = APIConfig.weatherAPIKey
    private let baseURL = "https://api.weatherapi.com/v1"
    
    func getAstronomy(for location: Location, date: Date = Date()) async throws -> AstronomyData {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date)
        let urlString = "\(baseURL)/astronomy.json?key=\(apiKey)&q=\(location.latitude),\(location.longitude)&dt=\(dateString)"
        guard let url = URL(string: urlString) else {
            throw WeatherError.invalidURL
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw WeatherError.invalidResponse
        }
        let apiResponse = try JSONDecoder().decode(AstronomyAPIResponse.self, from: data)
        return AstronomyData(
            sunrise: apiResponse.astronomy.astro.sunrise,
            sunset: apiResponse.astronomy.astro.sunset,
            moonrise: apiResponse.astronomy.astro.moonrise,
            moonset: apiResponse.astronomy.astro.moonset,
            moonPhase: apiResponse.astronomy.astro.moon_phase,
            moonIllumination: apiResponse.astronomy.astro.moon_illumination
        )
    }
}

struct AstronomyData {
    let sunrise: String
    let sunset: String
    let moonrise: String
    let moonset: String
    let moonPhase: String
    let moonIllumination: String
}

struct AstronomyAPIResponse: Codable {
    let astronomy: AstronomyWrapper
}

struct AstronomyWrapper: Codable {
    let astro: Astro
}

struct Astro: Codable {
    let sunrise: String
    let sunset: String
    let moonrise: String
    let moonset: String
    let moon_phase: String
    let moon_illumination: String
}
