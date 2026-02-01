//
//  SettingsViewModel.swift
//  WeatherAppPro
//
//  Created by Dony on 31/01/26
//

import Foundation
import Combine

enum TemperatureUnit: String, CaseIterable {
    case celsius = "Celsius"
    case fahrenheit = "Fahrenheit"
    
    var symbol: String {
        switch self {
        case .celsius: return "°C"
        case .fahrenheit: return "°F"
        }
    }
}

@MainActor
final class SettingsViewModel: ObservableObject {
    @Published var temperatureUnit: TemperatureUnit {
        didSet {
            UserDefaults.standard.set(temperatureUnit.rawValue, forKey: "temperatureUnit")
        }
    }
    
    init() {
        if let savedUnit = UserDefaults.standard.string(forKey: "temperatureUnit"),
           let unit = TemperatureUnit(rawValue: savedUnit) {
            temperatureUnit = unit
        } else {
            temperatureUnit = .celsius
        }
    }
    
    func convert(_ celsius: Double) -> Double {
        switch temperatureUnit {
        case .celsius:
            return celsius
        case .fahrenheit:
            return celsius * 9/5 + 32
        }
    }
    
    func format(_ celsius: Double) -> String {
        let converted = convert(celsius)
        return "\(Int(converted))°"
    }
    
    func formatWithUnit(_ celsius: Double) -> String {
        let converted = convert(celsius)
        return "\(Int(converted))\(temperatureUnit.symbol)"
    }
}
