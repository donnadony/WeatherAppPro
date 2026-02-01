//
//  Route.swift
//  WeatherAppPro
//
//  App navigation routes - all possible destinations in the app
//

import Foundation

/// App navigation routes
/// Each case represents a unique screen/destination in the app
enum Route: Hashable, Sendable {
    // MARK: - Main Routes
    
    /// Home/Weather screen
    case home
    
    /// Search for locations
    case search
    
    /// App settings
    case settings
    
    // MARK: - Weather Routes
    
    /// Detailed forecast for a location
    case forecast(locationId: UUID)
    
    /// Hourly forecast detail
    case hourlyDetail(dayIndex: Int)
    
    /// Daily forecast detail
    case dailyDetail(dayIndex: Int)
    
    // MARK: - Feature Routes
    
    /// Astronomy information for a location
    case astronomy(location: LocationEntity)
    
    /// Time zone information for a location
    case timeZone(location: LocationEntity)
    
    /// Historical weather for a location
    case history(location: LocationEntity)
    
    // MARK: - Location Routes
    
    /// Location detail screen
    case locationDetail(location: LocationEntity)
    
    /// Location on map
    case locationMap(location: LocationEntity)
}

// MARK: - Route Helpers

extension Route {
    /// Returns the display title for this route
    var title: String {
        switch self {
        case .home:
            return "Weather"
        case .search:
            return "Search"
        case .settings:
            return "Settings"
        case .forecast:
            return "Forecast"
        case .hourlyDetail:
            return "Hourly"
        case .dailyDetail:
            return "Daily"
        case .astronomy:
            return "Astronomy"
        case .timeZone:
            return "Time Zone"
        case .history:
            return "History"
        case .locationDetail(let location):
            return location.name
        case .locationMap(let location):
            return location.name
        }
    }
    
    /// Returns whether this route should show the back button
    var showsBackButton: Bool {
        switch self {
        case .home:
            return false
        default:
            return true
        }
    }
}