//
//  WeatherAPIModels.swift
//  WeatherAppPro
//
//  Created by Donnadony Mollo on Feb 1, 2026.
//


// MARK: - Weather API Response

struct WeatherAPIResponse: Codable {
    let location: APILocation
    let current: APICurrent
    let forecast: APIForecast?
}

struct APILocation: Codable {
    let name: String
    let country: String
    let lat: Double
    let lon: Double
    let region: String?
    let tz_id: String?
    let localtime: String?
}

struct APICurrent: Codable {
    let temp_c: Double
    let temp_f: Double
    let feelslike_c: Double
    let feelslike_f: Double
    let humidity: Int
    let wind_kph: Double
    let wind_dir: String?
    let pressure_mb: Double?
    let uv: Double?
    let vis_km: Double?
    let is_day: Int?
    let condition: APICondition
}

struct APICondition: Codable {
    let text: String
    let icon: String
    let code: Int?
}

struct APIForecast: Codable {
    let forecastday: [APIForecastDay]
}

struct APIForecastDay: Codable {
    let date: String
    let date_epoch: TimeInterval?
    let day: APIDay
    let hour: [APIHour]
    let astro: APIAstro?
}

struct APIDay: Codable {
    let maxtemp_c: Double
    let maxtemp_f: Double
    let mintemp_c: Double
    let mintemp_f: Double
    let avgtemp_c: Double
    let condition: APICondition
    let daily_chance_of_rain: Int?
    let uv: Double?
}

struct APIHour: Codable {
    let time: String
    let temp_c: Double
    let temp_f: Double
    let condition: APICondition
    let chance_of_rain: Int?
    let is_day: Int?
}

struct APIAstro: Codable {
    let sunrise: String
    let sunset: String
}

// MARK: - Search API Response

struct APISearchResult: Codable {
    let name: String
    let country: String
    let lat: Double
    let lon: Double
    let region: String?
    let tz_id: String?
}

// MARK: - Astronomy API Response

struct AstronomyAPIResponse: Codable {
    let location: APILocation
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
    let is_moon_up: Int?
    let is_sun_up: Int?
}

// MARK: - TimeZone API Response

struct TimeZoneAPIResponse: Codable {
    let location: TimeZoneAPILocation
}

struct TimeZoneAPILocation: Codable {
    let name: String
    let country: String
    let localtime: String
    let tz_id: String
}

// MARK: - History API Response

struct HistoryAPIResponse: Codable {
    let location: APILocation
    let forecast: HistoryForecast
}

struct HistoryForecast: Codable {
    let forecastday: [HistoryForecastDay]
}

struct HistoryForecastDay: Codable {
    let date: String
    let date_epoch: TimeInterval?
    let day: HistoryDay
}

struct HistoryDay: Codable {
    let maxtemp_c: Double
    let maxtemp_f: Double
    let mintemp_c: Double
    let mintemp_f: Double
    let avgtemp_c: Double
    let avgtemp_f: Double
    let maxwind_kph: Double
    let avghumidity: Double
    let totalprecip_mm: Double?
    let uv: Double?
    let condition: APICondition
}