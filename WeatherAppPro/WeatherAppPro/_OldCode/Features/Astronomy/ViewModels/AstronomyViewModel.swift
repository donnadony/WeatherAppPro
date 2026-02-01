//
//  AstronomyViewModel.swift
//  WeatherAppPro
//
//  Created by Dony on 31/01/26
//

import Foundation
import Combine

@MainActor
final class AstronomyViewModel: ObservableObject {
    @Published var astronomyData: AstronomyData?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let service = AstronomyService()
    
    func fetchAstronomy(for location: Location) async {
        isLoading = true
        errorMessage = nil
        do {
            astronomyData = try await service.getAstronomy(for: location)
        } catch {
            errorMessage = error.localizedDescription
            astronomyData = generateMockData()
        }
        isLoading = false
    }
    
    private func generateMockData() -> AstronomyData {
        AstronomyData(
            sunrise: "06:45 AM",
            sunset: "05:30 PM",
            moonrise: "08:15 PM",
            moonset: "07:20 AM",
            moonPhase: "Waxing Crescent",
            moonIllumination: "35"
        )
    }
}
