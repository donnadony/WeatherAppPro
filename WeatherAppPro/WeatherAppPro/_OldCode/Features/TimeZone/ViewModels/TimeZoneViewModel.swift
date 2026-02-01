//
//  TimeZoneViewModel.swift
//  WeatherAppPro
//
//  Created by Dony on 31/01/26
//

import Foundation
import Combine

@MainActor
final class TimeZoneViewModel: ObservableObject {
    @Published var timeZoneData: TimeZoneData?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let service = TimeZoneService()
    
    func fetchTimeZone(for location: Location) async {
        isLoading = true
        errorMessage = nil
        do {
            timeZoneData = try await service.getTimeZone(for: location)
        } catch {
            errorMessage = error.localizedDescription
            timeZoneData = generateMockData(for: location)
        }
        isLoading = false
    }
    
    private func generateMockData(for location: Location) -> TimeZoneData {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let now = formatter.string(from: Date())
        return TimeZoneData(
            locationName: location.name,
            country: location.country,
            localtime: now,
            timezone: "UTC"
        )
    }
}
