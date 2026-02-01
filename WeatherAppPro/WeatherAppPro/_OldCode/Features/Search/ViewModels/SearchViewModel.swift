//
//  SearchViewModel.swift
//  WeatherAppPro
//
//  Created by Donnadony Mollo on Feb 1, 2026.
//

import Combine

@MainActor
final class SearchViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var results: [Location] = []
    @Published var isSearching = false
    
    private let searchService = LocationSearchService()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        $searchText
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] query in
                Task {
                    await self?.searchLocations(query: query)
                }
            }
            .store(in: &cancellables)
    }
    
    private func searchLocations(query: String) async {
        guard !query.isEmpty else {
            results = []
            return
        }
        isSearching = true
        do {
            results = try await searchService.searchLocations(query: query)
        } catch {
            print("Search error: \(error)")
            results = []
        }
        isSearching = false
    }
}
