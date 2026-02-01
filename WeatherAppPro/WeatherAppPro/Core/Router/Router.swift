//
//  Router.swift
//  WeatherAppPro
//
//  Created by Donnadony Mollo on Feb 1, 2026.
//

import Combine

/// Router manages the navigation state using NavigationPath
/// This is the single source of truth for navigation in the app
@MainActor
final class Router: ObservableObject, Sendable {
    
    // MARK: - Published State
    
    /// The navigation path - use this with NavigationStack(path:)
    @Published var path = NavigationPath()
    
    /// Sheet presentation state
    @Published var presentedSheet: Route?
    
    /// Full cover presentation state
    @Published var presentedFullScreen: Route?
    
    // MARK: - Navigation Methods
    
    /// Navigate to a route (pushes onto stack)
    /// - Parameter route: The destination route
    func navigate(to route: Route) {
        path.append(route)
    }
    
    /// Navigate back one step
    func navigateBack() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }
    
    /// Navigate to root (clears the stack)
    func navigateToRoot() {
        path.removeLast(path.count)
    }
    
    /// Pop a specific number of screens
    /// - Parameter count: Number of screens to pop
    func pop(count: Int) {
        guard count <= path.count else {
            navigateToRoot()
            return
        }
        path.removeLast(count)
    }
    
    /// Replace the current stack with a new route
    /// - Parameter route: The new route to show
    func replaceStack(with route: Route) {
        path.removeLast(path.count)
        path.append(route)
    }
    
    // MARK: - Modal Presentation
    
    /// Present a route as a sheet
    /// - Parameter route: The route to present
    func presentSheet(_ route: Route) {
        presentedSheet = route
    }
    
    /// Present a route as full screen cover
    /// - Parameter route: The route to present
    func presentFullScreen(_ route: Route) {
        presentedFullScreen = route
    }
    
    /// Dismiss the current modal
    func dismissModal() {
        presentedSheet = nil
        presentedFullScreen = nil
    }
    
    // MARK: - Navigation Helpers
    
    /// Navigate to location search and save the result
    func navigateToSearchAndSave(onSelect: @escaping (LocationEntity) -> Void) {
        // This would be used with a coordinator pattern
        // For now, we navigate to search
        navigate(to: .search)
    }
    
    /// Navigate to weather for a specific location
    /// - Parameter location: The location to show weather for
    func navigateToWeather(for location: LocationEntity) {
        navigate(to: .locationDetail(location: location))
    }
    
    /// Navigate to astronomy for current location
    /// - Parameter location: The location
    func navigateToAstronomy(for location: LocationEntity) {
        navigate(to: .astronomy(location: location))
    }
    
    /// Navigate to timezone for current location
    /// - Parameter location: The location
    func navigateToTimeZone(for location: LocationEntity) {
        navigate(to: .timeZone(location: location))
    }
    
    /// Navigate to history for current location
    /// - Parameter location: The location
    func navigateToHistory(for location: LocationEntity) {
        navigate(to: .history(location: location))
    }
}

// MARK: - View Extension for Router

extension View {
    /// Sets up navigation destinations for the Router
    func withNavigationDestinations(router: Router) -> some View {
        self.navigationDestination(for: Route.self) { route in
            RouteViewFactory.view(for: route, router: router)
        }
    }
}