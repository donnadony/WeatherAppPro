//
//  Router.swift
//  WeatherAppPro
//
//  Created by Dony on 31/01/26
//

import Foundation
import SwiftUI
import Combine

final class Router: ObservableObject {
    @Published var path = NavigationPath()
    
    @MainActor
    func navigate(to route: Route) {
        path.append(route)
    }
    
    @MainActor
    func navigateBack() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }
    
    @MainActor
    func navigateToRoot() {
        path.removeLast(path.count)
    }
    
    @MainActor
    func pop(count: Int) {
        guard count <= path.count else { return }
        path.removeLast(count)
    }
}
