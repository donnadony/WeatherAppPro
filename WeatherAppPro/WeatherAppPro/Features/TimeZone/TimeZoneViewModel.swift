//
//  TimeZoneViewModel.swift
//  WeatherAppPro
//
//  Created by Donnadony Mollo on Feb 1, 2026.
//


enum TimeZoneViewState: Equatable {
    case idle
    case loading
    case success
    case error(String)
    
    var isLoading: Bool {
        if case .loading = self { return true }
        return false
    }
}

@MainActor
final class TimeZoneViewModel: ObservableObject, Sendable {
    
    // MARK: - Published State
    
    @Published var timeZoneData: TimeZoneEntity?
    @Published var viewState: TimeZoneViewState = .idle
    
    let location: LocationEntity
    
    // MARK: - Dependencies
    
    private let getTimeZoneUseCase: GetTimeZoneUseCase
    
    // MARK: - Initialization
    
    init(
        location: LocationEntity,
        getTimeZoneUseCase: GetTimeZoneUseCase
    ) {
        self.location = location
        self.getTimeZoneUseCase = getTimeZoneUseCase
    }
    
    // MARK: - Public Methods
    
    func fetchTimeZone() async {
        viewState = .loading
        
        let result = await getTimeZoneUseCase.execute(for: location)
        
        switch result {
        case .success(let timeZone):
            timeZoneData = timeZone
            viewState = .success
        case .failure(let error):
            viewState = .error(error.localizedDescription)
            // Use mock data as fallback
            timeZoneData = MockData.timeZoneData(for: location)
        }
    }
    
    // MARK: - Computed Properties
    
    var locationName: String {
        timeZoneData?.locationName ?? location.name
    }
    
    var country: String {
        timeZoneData?.country ?? location.country
    }
    
    var localTime: String {
        timeZoneData?.localtime ?? formatCurrentDate()
    }
    
    var timeZone: String {
        timeZoneData?.timezone ?? location.timezoneId ?? "UTC"
    }
    
    private func formatCurrentDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter.string(from: Date())
    }
}

// MARK: - Mock Data

extension MockData {
    static func timeZoneData(for location: LocationEntity) -> TimeZoneEntity {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let now = formatter.string(from: Date())
        
        return TimeZoneEntity(
            locationId: location.id,
            locationName: location.name,
            country: location.country,
            localtime: now,
            timezone: location.timezoneId ?? "UTC"
        )
    }
}