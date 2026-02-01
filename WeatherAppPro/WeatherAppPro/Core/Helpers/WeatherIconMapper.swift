//
//  WeatherIconMapper.swift
//  WeatherAppPro
//
//  Created by Donnadony Mollo on Feb 1, 2026.
//


struct WeatherIconMapper {
    static func icon(for condition: String) -> String {
        let lowercased = condition.lowercased()
        if lowercased.contains("clear") || lowercased.contains("sunny") {
            return "sun.max.fill"
        }
        if lowercased.contains("heavy rain") {
            return "cloud.heavyrain.fill"
        }
        if lowercased.contains("rain") || lowercased.contains("drizzle") || lowercased.contains("shower") {
            return "cloud.rain.fill"
        }
        if lowercased.contains("light rain") || lowercased.contains("patchy rain") {
            return "cloud.drizzle.fill"
        }
        if lowercased.contains("partly cloudy") {
            return "cloud.sun.fill"
        }
        if lowercased.contains("cloudy") || lowercased.contains("overcast") {
            return "cloud.fill"
        }
        if lowercased.contains("heavy snow") {
            return "cloud.snow.fill"
        }
        if lowercased.contains("snow") || lowercased.contains("sleet") || lowercased.contains("blizzard") {
            return "cloud.snow.fill"
        }
        if lowercased.contains("thunder") || lowercased.contains("storm") {
            return "cloud.bolt.rain.fill"
        }
        if lowercased.contains("mist") || lowercased.contains("fog") || lowercased.contains("haze") {
            return "cloud.fog.fill"
        }
        if lowercased.contains("wind") {
            return "wind"
        }
        return "cloud.sun.fill"
    }
    
    static func icon(for condition: String, isNight: Bool) -> String {
        let baseIcon = icon(for: condition)
        if isNight {
            if baseIcon == "sun.max.fill" {
                return "moon.stars.fill"
            }
            if baseIcon == "cloud.sun.fill" {
                return "cloud.moon.fill"
            }
        }
        return baseIcon
    }
}
