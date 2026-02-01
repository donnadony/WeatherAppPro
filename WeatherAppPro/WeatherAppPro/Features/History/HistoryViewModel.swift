//
//  HistoryViewModel.swift
//  WeatherAppPro
//
//  Refactored History ViewModel using Clean Architecture
//

import Foundation

enum HistoryViewState: Equatable {
    case idle
    case loading
    case success
    case error(String)
    case invalidDate
    
    var isLoading: Bool {
        if case .loading = self { return true }
        return false
    }
}

@MainActor
final class HistoryViewModel: ObservableObject, Sendable {
    
    // MARK: - Published State
    
    @Published var historyData: HistoricalWeatherEntity?
    @Published var viewState: HistoryViewState = .idle
    @Published var selectedDate: Date = Date().addingTimeInterval(-24 * 60 * 60) // Yesterday
    
    let location: LocationEntity
    
    // MARK: - Dependencies
    
    private let getHistoryUseCase: GetHistoryUseCase
    
    // MARK: - Initialization
    
    init(
        location: LocationEntity,
        getHistoryUseCase: GetHistoryUseCase
    ) {
        self.location = location
        self.getHistoryUseCase = getHistoryUseCase
    }
    
    // MARK: - Public Methods
    
    func fetchHistory() async {
        // Validate date
        guard getHistoryUseCase.isValidDate(selectedDate) else {
            viewState = .invalidDate
            return
        }
        
        viewState = .loading
        
        let result = await getHistoryUseCase.execute(for: location, date: selectedDate)
        
        switch result {
        case .success(let history):
            historyData = history
            viewState = .success
        case .failure(let error):
            viewState = .error(error.localizedDescription)
            // Use mock data as fallback
            historyData = MockData.historyData(for: location, date: selectedDate)
        }
    }
    
    func changeDate(_ date: Date) async {
        selectedDate = date
        await fetchHistory()
    }
    
    /// Returns the valid date range for history queries
    var validDateRange: ClosedRange<Date> {
        let calendar = Calendar.current
        let now = Date()
        
        // Earliest: Jan 1, 2010
        let earliest = calendar.date(from: DateComponents(year: 2010, month: 1, day: 1))!
        
        // Latest: Yesterday
        let yesterday = calendar.date(byAdding: .day, value: -1, to: now)!
        
        return earliest...yesterday
    }
    
    // MARK: - Computed Properties
    
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: selectedDate)
    }
    
    var maxTemp: Double {
        historyData?.maxTemp ?? 0
    }
    
    var minTemp: Double {
        historyData?.minTemp ?? 0
    }
    
    var avgTemp: Double {
        historyData?.avgTemp ?? 0
    }
    
    var condition: String {
        historyData?.condition ?? "Unknown"
    }
    
    var maxWind: Double {
        historyData?.maxWind ?? 0
    }
    
    var avgHumidity: Double {
        historyData?.avgHumidity ?? 0
    }
}

// MARK: - Mock Data

extension MockData {
    static func historyData(for location: LocationEntity, date: Date) -> HistoricalWeatherEntity {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        return HistoricalWeatherEntity(
            locationId: location.id,
            date: date,
            dateString: formatter.string(from: date),
            maxTemp: 25.0,
            minTemp: 15.0,
            avgTemp: 20.0,
            condition: "Partly cloudy",
            maxWind: 15.0,
            avgHumidity: 65.0,
            totalPrecipitation: 0.5,
            uvIndex: 6.0
        )
    }
}