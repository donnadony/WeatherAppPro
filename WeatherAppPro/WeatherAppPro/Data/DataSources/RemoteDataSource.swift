//
//  RemoteDataSource.swift
//  WeatherAppPro
//
//  Created by Donnadony Mollo on Feb 1, 2026.
//


/// Protocol for remote data operations
protocol RemoteDataSourceProtocol: Sendable {
    func fetchWeather(for location: LocationEntity) async throws -> WeatherAPIResponse
    func searchLocations(query: String) async throws -> [APISearchResult]
    func fetchAstronomy(for location: LocationEntity, date: Date) async throws -> AstronomyAPIResponse
    func fetchTimeZone(for location: LocationEntity) async throws -> TimeZoneAPIResponse
    func fetchHistory(for location: LocationEntity, date: Date) async throws -> HistoryAPIResponse
}

/// Network errors
enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case httpError(Int)
    case decodingError(Error)
    case noInternet
    
    var toDomainError: DomainError {
        switch self {
        case .noInternet, .invalidResponse:
            return .networkUnavailable
        case .httpError(let code):
            if code == 404 {
                return .locationNotFound
            }
            return .unknown("HTTP Error: \(code)")
        case .decodingError:
            return .unknown("Failed to parse response")
        default:
            return .unknown("Network error")
        }
    }
}

/// Remote data source implementation
final class RemoteDataSource: RemoteDataSourceProtocol {
    private let apiKey: String
    private let baseURL: String
    private let session: URLSession
    
    init(
        apiKey: String = APIConfig.weatherAPIKey,
        baseURL: String = "https://api.weatherapi.com/v1",
        session: URLSession = .shared
    ) {
        self.apiKey = apiKey
        self.baseURL = baseURL
        self.session = session
    }
    
    // MARK: - Weather
    
    func fetchWeather(for location: LocationEntity) async throws -> WeatherAPIResponse {
        let urlString = "\(baseURL)/forecast.json?key=\(apiKey)&q=\(location.latitude),\(location.longitude)&days=7&aqi=no&alerts=no"
        return try await performRequest(urlString: urlString)
    }
    
    // MARK: - Search
    
    func searchLocations(query: String) async throws -> [APISearchResult] {
        guard !query.isEmpty else { return [] }
        
        let urlString = "\(baseURL)/search.json?key=\(apiKey)&q=\(query)"
        
        guard let encodedURL = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            throw NetworkError.invalidURL
        }
        
        return try await performRequest(urlString: encodedURL)
    }
    
    // MARK: - Astronomy
    
    func fetchAstronomy(for location: LocationEntity, date: Date) async throws -> AstronomyAPIResponse {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date)
        
        let urlString = "\(baseURL)/astronomy.json?key=\(apiKey)&q=\(location.latitude),\(location.longitude)&dt=\(dateString)"
        return try await performRequest(urlString: urlString)
    }
    
    // MARK: - TimeZone
    
    func fetchTimeZone(for location: LocationEntity) async throws -> TimeZoneAPIResponse {
        let urlString = "\(baseURL)/timezone.json?key=\(apiKey)&q=\(location.latitude),\(location.longitude)"
        return try await performRequest(urlString: urlString)
    }
    
    // MARK: - History
    
    func fetchHistory(for location: LocationEntity, date: Date) async throws -> HistoryAPIResponse {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date)
        
        let urlString = "\(baseURL)/history.json?key=\(apiKey)&q=\(location.latitude),\(location.longitude)&dt=\(dateString)"
        return try await performRequest(urlString: urlString)
    }
    
    // MARK: - Generic Request
    
    private func performRequest<T: Decodable>(urlString: String) async throws -> T {
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        do {
            let (data, response) = try await session.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                throw NetworkError.httpError(httpResponse.statusCode)
            }
            
            do {
                return try JSONDecoder().decode(T.self, from: data)
            } catch {
                throw NetworkError.decodingError(error)
            }
        } catch let error as NetworkError {
            throw error
        } catch {
            throw NetworkError.noInternet
        }
    }
}