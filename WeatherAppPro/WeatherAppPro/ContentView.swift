//
//  ContentView.swift
//  WeatherAppPro
//
//  Created by Donnadony Mollo on Feb 1, 2026.
//


struct ContentView: View {
    @StateObject private var router = Router()
    
    // ViewModels from DI Container
    private let weatherViewModel: WeatherViewModel
    private let settingsViewModel: SettingsViewModel
    
    init() {
        // Create ViewModels using DI Container
        self.weatherViewModel = Container.shared.makeWeatherViewModel()
        self.settingsViewModel = Container.shared.makeSettingsViewModel()
    }
    
    var body: some View {
        NavigationStack(path: $router.path) {
            WeatherHomeView()
                .navigationDestination(for: Route.self) { route in
                    RouteViewFactory.view(for: route, router: router)
                }
        }
        .environmentObject(router)
        .environmentObject(weatherViewModel)
        .environmentObject(settingsViewModel)
        .sheet(item: $router.presentedSheet) { route in
            NavigationStack {
                RouteViewFactory.view(for: route, router: router)
            }
        }
        .fullScreenCover(item: $router.presentedFullScreen) { route in
            NavigationStack {
                RouteViewFactory.view(for: route, router: router)
            }
        }
    }
}

// MARK: - Preview

#Preview {
    ContentView()
}