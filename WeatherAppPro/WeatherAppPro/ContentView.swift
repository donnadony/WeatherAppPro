//
//  ContentView.swift
//  WeatherAppPro
//
//  Created by Dony on 31/01/26.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var router = Router()
    @StateObject private var weatherViewModel = WeatherViewModel()
    @StateObject private var settingsViewModel = SettingsViewModel()
    
    var body: some View {
        NavigationStack(path: $router.path) {
            WeatherView()
                .navigationTitle("Weather")
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .home:
                        WeatherView()
                    case .forecast(let location):
                        Text("Forecast for \(location)")
                    case .search:
                        SearchView()
                    case .settings:
                        SettingsView()
                    case .locationDetail(let id):
                        Text("Location: \(id)")
                    case .astronomy(let location):
                        AstronomyView(location: location)
                    case .timeZone(let location):
                        TimeZoneView(location: location)
                    case .history(let location):
                        HistoryView(location: location)
                    }
                }
        }
        .environmentObject(router)
        .environmentObject(weatherViewModel)
        .environmentObject(settingsViewModel)
    }
}

#Preview {
    ContentView()
}
