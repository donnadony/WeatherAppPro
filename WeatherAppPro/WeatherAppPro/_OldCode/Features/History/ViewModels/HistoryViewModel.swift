//
//  HistoryViewModel.swift
//  WeatherAppPro
//
//  Created by Donnadony Mollo on Feb 1, 2026.
//

import Combine

@MainActor
final class HistoryViewModel: ObservableObject {
    @Published var historyData: HistoricalWeatherData?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var selectedDate = Date()
    
    private let service = HistoryService()
    
    func fetchHistory(for location: Location, date: Date) async {
        isLoading = true
        errorMessage = nil
        do {
            historyData = try await service.getHistory(for: location, date: date)
        } catch {
            errorMessage = error.localizedDescription
            historyData = generateMockData(for: date)
        }
        isLoading = false
    }
    
    private func generateMockData(for date: Date) -> HistoricalWeatherData {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return HistoricalWeatherData(
            date: formatter.string(from: date),
            maxTemp: 25.0,
            minTemp: 15.0,
            avgTemp: 20.0,
            condition: "Partly cloudy",
            maxWind: 15.0,
            avgHumidity: 65.0
        )
    }
}
