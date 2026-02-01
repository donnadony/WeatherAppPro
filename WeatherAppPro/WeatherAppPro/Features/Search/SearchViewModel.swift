//
//  SearchViewModel.swift
//  WeatherAppPro
//
//  Created by Donnadony Mollo on Feb 1, 2026.
//

import Foundation
import Combine

@MainActor
final class SearchViewModel: ObservableObject, Sendable {
    
    // MARK: - Published State
    
    @Published var searchText = ""
    @Published var searchResults: [LocationEntity] = []
    @Published var recentSearches: [LocationEntity] = []
    @Published var isSearching = false
    @Published var errorMessage: String?
    @Published var showError = false
    
    // MARK: - Dependencies
    
    private let searchLocationsUseCase: SearchLocationsUseCase
    private var searchTask: Task<Void, Never>?
    
    // MARK: - Initialization
    
    init(searchLocationsUseCase: SearchLocationsUseCase) {
        self.searchLocationsUseCase = searchLocationsUseCase
        setupSearchDebounce()
        loadRecentSearches()
    }
    
    // MARK: - Search
    
    private func setupSearchDebounce() {
        $searchText
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .filter { !$0.isEmpty }
            .sink { [weak self] query in
                Task {
                    await self?.performSearch(query: query)
                }
            }
            .store(in: &cancellables)
    }
    
    private func performSearch(query: String) async {
        guard query.count >= 2 else { return }
        
        isSearching = true
        errorMessage = nil
        showError = false
        
        let result = await searchLocationsUseCase.execute(query: query)
        
        isSearching = false
        
        switch result {
        case .success(let locations):
            searchResults = locations
        case .failure(let error):
            searchResults = []
            errorMessage = error.localizedDescription
            showError = true
        }
    }
    
    // MARK: - Recent Searches
    
    func loadRecentSearches() {
        Task {
            recentSearches = await searchLocationsUseCase.getRecentSearches()
        }
    }
    
    func saveLocationToRecent(_ location: LocationEntity) {
        Task {
            await searchLocationsUseCase.saveRecentSearch(location)
            recentSearches = await searchLocationsUseCase.getRecentSearches()
        }
    }
    
    func clearSearch() {
        searchText = ""
        searchResults = []
    }
    
    // MARK: - Private
    
    private var cancellables = Set<AnyCancellable>()
}