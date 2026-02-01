//
//  LocationSearchService.swift
//  WeatherAppPro
//
//  Created by Donnadony Mollo on Feb 1, 2026.
//


/// Search/Autocomplete for locations using WeatherAPI.com
final class LocationSearchService {
    
    private let apiKey = APIConfig.weatherAPIKey
    private let baseURL = "https://api.weatherapi.com/v1"
    
    /// Search for locations
    func searchLocations(query: String) async throws -> [Location] {
        guard !query.isEmpty else { return [] }
        
        let urlString = "\(baseURL)/search.json?key=\(apiKey)&q=\(query)"
        
        guard let encodedURL = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: encodedURL) else {
            throw WeatherError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw WeatherError.invalidResponse
        }
        
        let searchResults = try JSONDecoder().decode([SearchResult].self, from: data)
        
        return searchResults.map { result in
            Location(
                name: result.name,
                latitude: result.lat,
                longitude: result.lon,
                country: result.country
            )
        }
    }
}

// MARK: - Search Result Model

struct SearchResult: Codable {
    let name: String
    let country: String
    let lat: Double
    let lon: Double
}
