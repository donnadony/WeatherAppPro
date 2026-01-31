//
//  Route.swift
//  WeatherAppPro
//
//  Created by Dony on 31/01/26
//

import Foundation

/// App navigation routes
enum Route: Hashable {
    case home
    case forecast(location: String)
    case search
    case settings
    case locationDetail(id: String)
    case astronomy(location: Location)
    case timeZone(location: Location)
    case history(location: Location)
}
