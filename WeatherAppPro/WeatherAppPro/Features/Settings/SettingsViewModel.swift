//
//  SettingsViewModel.swift
//  WeatherAppPro
//
//  Created by Donnadony Mollo on Feb 1, 2026.
//

import Combine

enum TemperatureUnit: String, CaseIterable, Identifiable {
    case celsius = "Celsius"
    case fahrenheit = "Fahrenheit"
    
    var id: String { rawValue }
    
    var symbol: String {
        switch self {
        case .celsius: return "°C"
        case .fahrenheit: return "°F"
        }
    }
}

enum WindSpeedUnit: String, CaseIterable, Identifiable {
    case kph = "km/h"
    case mph = "mph"
    case ms = "m/s"
    
    var id: String { rawValue }
}

@MainActor
final class SettingsViewModel: ObservableObject, Sendable {
    
    // MARK: - Published State
    
    @Published var temperatureUnit: TemperatureUnit {
        didSet {
            UserDefaults.standard.set(temperatureUnit.rawValue, forKey: Keys.temperatureUnit)
        }
    }
    
    @Published var windSpeedUnit: WindSpeedUnit {
        didSet {
            UserDefaults.standard.set(windSpeedUnit.rawValue, forKey: Keys.windSpeedUnit)
        }
    }
    
    @Published var useMetricSystem: Bool {
        didSet {
            UserDefaults.standard.set(useMetricSystem, forKey: Keys.useMetricSystem)
        }
    }
    
    // MARK: - Initialization
    
    init() {
        self.temperatureUnit = UserDefaults.standard.enum(forKey: Keys.temperatureUnit) ?? .celsius
        self.windSpeedUnit = UserDefaults.standard.enum(forKey: Keys.windSpeedUnit) ?? .kph
        self.useMetricSystem = UserDefaults.standard.bool(forKey: Keys.useMetricSystem)
    }
    
    // MARK: - Temperature Conversion
    
    func convertTemperature(_ celsius: Double) -> Double {
        switch temperatureUnit {
        case .celsius:
            return celsius
        case .fahrenheit:
            return celsius * 9/5 + 32
        }
    }
    
    func formatTemperature(_ celsius: Double) -> String {
        let converted = convertTemperature(celsius)
        return "\(Int(converted))°"
    }
    
    func formatTemperatureWithUnit(_ celsius: Double) -> String {
        let converted = convertTemperature(celsius)
        return "\(Int(converted))\(temperatureUnit.symbol)"
    }
    
    // MARK: - Wind Speed Conversion
    
    func convertWindSpeed(_ kph: Double) -> Double {
        switch windSpeedUnit {
        case .kph:
            return kph
        case .mph:
            return kph * 0.621371
        case .ms:
            return kph * 0.277778
        }
    }
    
    func formatWindSpeed(_ kph: Double) -> String {
        let converted = convertWindSpeed(kph)
        return String(format: "%.1f %@", converted, windSpeedUnit.rawValue)
    }
    
    // MARK: - Reset
    
    func resetToDefaults() {
        temperatureUnit = .celsius
        windSpeedUnit = .kph
        useMetricSystem = true
    }
    
    // MARK: - Keys
    
    private enum Keys {
        static let temperatureUnit = "temperatureUnit"
        static let windSpeedUnit = "windSpeedUnit"
        static let useMetricSystem = "useMetricSystem"
    }
}

// MARK: - UserDefaults Helpers

extension UserDefaults {
    func enum<T: RawRepresentable>(forKey key: String) -> T? where T.RawValue == String {
        guard let value = string(forKey: key) else { return nil }
        return T(rawValue: value)
    }
}