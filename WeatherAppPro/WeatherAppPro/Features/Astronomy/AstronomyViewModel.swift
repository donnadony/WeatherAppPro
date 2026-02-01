//
//  AstronomyViewModel.swift
//  WeatherAppPro
//
//  Created by Donnadony Mollo on Feb 1, 2026.
//

import Foundation
import Combine

enum AstronomyViewState: Equatable {
    case idle
    case loading
    case success
    case error(String)
    
    var isLoading: Bool {
        if case .loading = self { return true }
        return false
    }
    
    var errorMessage: String? {
        if case .error(let msg) = self { return msg }
        return nil
    }
}

@MainActor
final class AstronomyViewModel: ObservableObject, Sendable {
    
    // MARK: - Published State
    
    @Published var astronomyData: AstronomyEntity?
    @Published var viewState: AstronomyViewState = .idle
    @Published var selectedDate: Date = Date()
    
    let location: LocationEntity
    
    // MARK: - Dependencies
    
    private let getAstronomyUseCase: GetAstronomyUseCase
    
    // MARK: - Initialization
    
    init(
        location: LocationEntity,
        getAstronomyUseCase: GetAstronomyUseCase
    ) {
        self.location = location
        self.getAstronomyUseCase = getAstronomyUseCase
    }
    
    // MARK: - Public Methods
    
    func fetchAstronomy() async {
        viewState = .loading
        
        let result = await getAstronomyUseCase.execute(for: location, date: selectedDate)
        
        switch result {
        case .success(let astronomy):
            astronomyData = astronomy
            viewState = .success
        case .failure(let error):
            viewState = .error(error.localizedDescription)
            // Use mock data as fallback
            astronomyData = MockData.astronomyData(for: location, date: selectedDate)
        }
    }
    
    func changeDate(_ date: Date) async {
        selectedDate = date
        await fetchAstronomy()
    }
    
    // MARK: - Computed Properties
    
    var sunriseTime: String {
        astronomyData?.sunrise ?? "--:--"
    }
    
    var sunsetTime: String {
        astronomyData?.sunset ?? "--:--"
    }
    
    var moonriseTime: String {
        astronomyData?.moonrise ?? "--:--"
    }
    
    var moonsetTime: String {
        astronomyData?.moonset ?? "--:--"
    }
    
    var moonPhase: String {
        astronomyData?.moonPhase ?? "Unknown"
    }
    
    var moonIllumination: Int {
        astronomyData?.moonIllumination ?? 0
    }
    
    var moonIcon: String {
        astronomyData?.moonPhaseIcon ?? "moon.fill"
    }
}

// MARK: - Mock Data

extension MockData {
    static func astronomyData(for location: LocationEntity, date: Date) -> AstronomyEntity {
        AstronomyEntity(
            locationId: location.id,
            date: date,
            sunrise: "06:45 AM",
            sunset: "05:30 PM",
            moonrise: "08:15 PM",
            moonset: "07:20 AM",
            moonPhase: "Waxing Crescent",
            moonIllumination: 35
        )
    }
}