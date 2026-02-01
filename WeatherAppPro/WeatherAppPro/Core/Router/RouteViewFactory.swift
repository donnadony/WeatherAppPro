//
//  RouteViewFactory.swift
//  WeatherAppPro
//
//  Factory for creating views from routes
//

import SwiftUI

/// Factory that creates the appropriate view for each route
@MainActor
enum RouteViewFactory {
    
    /// Create a view for a given route
    /// - Parameters:
    ///   - route: The route to create a view for
    ///   - router: The router instance
    /// - Returns: The appropriate view
    @ViewBuilder
    static func view(for route: Route, router: Router) -> some View {
        switch route {
        case .home:
            WeatherHomeView()
            
        case .search:
            SearchView()
            
        case .settings:
            SettingsView()
            
        case .forecast(let locationId):
            // Could create a detailed forecast view
            Text("Forecast for \(locationId.uuidString)")
            
        case .hourlyDetail(let dayIndex):
            HourlyDetailView(dayIndex: dayIndex)
            
        case .dailyDetail(let dayIndex):
            DailyDetailView(dayIndex: dayIndex)
            
        case .astronomy(let location):
            AstronomyView(location: location)
            
        case .timeZone(let location):
            TimeZoneView(location: location)
            
        case .history(let location):
            HistoryView(location: location)
            
        case .locationDetail(let location):
            LocationDetailView(location: location)
            
        case .locationMap(let location):
            LocationMapView(location: location)
        }
    }
}

// MARK: - Placeholder Views (will be replaced with actual implementations)

struct HourlyDetailView: View {
    let dayIndex: Int
    @EnvironmentObject private var router: Router
    @EnvironmentObject private var weatherViewModel: WeatherViewModel
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.weatherBackground(for: weatherViewModel.weatherCondition))
                .ignoresSafeArea()
            
            VStack {
                Text("Hourly Forecast - Day \(dayIndex + 1)")
                    .font(.title)
                    .foregroundStyle(.white)
                    .padding()
                
                if let hours = weatherViewModel.hourlyForecast {
                    List(hours) { hour in
                        HStack {
                            Text(hour.hour)
                                .foregroundStyle(.white)
                            Spacer()
                            Image(systemName: hour.icon)
                                .foregroundStyle(.white)
                            Text("\(Int(hour.temperature))°")
                                .foregroundStyle(.white)
                        }
                        .listRowBackground(Color.clear)
                    }
                    .scrollContentBackground(.hidden)
                }
            }
        }
        .navigationTitle("Hourly")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct DailyDetailView: View {
    let dayIndex: Int
    @EnvironmentObject private var router: Router
    @EnvironmentObject private var weatherViewModel: WeatherViewModel
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.weatherBackground(for: weatherViewModel.weatherCondition))
                .ignoresSafeArea()
            
            VStack {
                Text("Daily Forecast - Day \(dayIndex + 1)")
                    .font(.title)
                    .foregroundStyle(.white)
                    .padding()
                
                if let days = weatherViewModel.dailyForecast, dayIndex < days.count {
                    let day = days[dayIndex]
                    VStack(spacing: 20) {
                        Image(systemName: day.icon)
                            .font(.system(size: 80))
                            .foregroundStyle(.white)
                        
                        Text(day.dayName)
                            .font(.largeTitle)
                            .foregroundStyle(.white)
                        
                        Text(day.condition)
                            .font(.title2)
                            .foregroundStyle(.white.opacity(0.8))
                        
                        HStack(spacing: 40) {
                            VStack {
                                Text("High")
                                    .foregroundStyle(.white.opacity(0.6))
                                Text("\(Int(day.high))°")
                                    .font(.title)
                                    .foregroundStyle(.white)
                            }
                            VStack {
                                Text("Low")
                                    .foregroundStyle(.white.opacity(0.6))
                                Text("\(Int(day.low))°")
                                    .font(.title)
                                    .foregroundStyle(.white)
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("Daily")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct LocationDetailView: View {
    let location: LocationEntity
    @EnvironmentObject private var router: Router
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.blue.gradient)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text(location.name)
                    .font(.largeTitle)
                    .foregroundStyle(.white)
                
                Text(location.country)
                    .font(.title2)
                    .foregroundStyle(.white.opacity(0.8))
                
                Text("Lat: \(location.latitude, specifier: "%.4f"), Lon: \(location.longitude, specifier: "%.4f")")
                    .foregroundStyle(.white.opacity(0.6))
                    .font(.caption)
                
                Spacer()
                
                VStack(spacing: 12) {
                    NavigationButton(icon: "sun.and.horizon.fill", title: "Astronomy") {
                        router.navigate(to: .astronomy(location: location))
                    }
                    
                    NavigationButton(icon: "clock.fill", title: "Time Zone") {
                        router.navigate(to: .timeZone(location: location))
                    }
                    
                    NavigationButton(icon: "calendar", title: "Historical Weather") {
                        router.navigate(to: .history(location: location))
                    }
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle(location.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct LocationMapView: View {
    let location: LocationEntity
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.black)
                .ignoresSafeArea()
            
            VStack {
                Text("Map View")
                    .font(.title)
                    .foregroundStyle(.white)
                
                Text("\(location.name), \(location.country)")
                    .foregroundStyle(.white.opacity(0.8))
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Map")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Helper Components

struct NavigationButton: View {
    let icon: String
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                Text(title)
                    .font(.headline)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption)
            }
            .foregroundStyle(.white)
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(12)
        }
    }
}