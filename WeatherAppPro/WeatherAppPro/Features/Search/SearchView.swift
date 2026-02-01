//
//  SearchView.swift
//  WeatherAppPro
//
//  Created by Donnadony Mollo on Feb 1, 2026.
//

import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = Container.shared.makeSearchViewModel()
    @EnvironmentObject private var router: Router
    @EnvironmentObject private var weatherViewModel: WeatherViewModel
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.weatherBackground(for: "Cloudy"))
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                SearchBar(text: $viewModel.searchText)
                    .padding()
                
                if viewModel.isSearching {
                    loadingState
                } else if viewModel.searchText.isEmpty {
                    if viewModel.recentSearches.isEmpty {
                        emptyState
                    } else {
                        recentSearchesList
                    }
                } else if viewModel.searchResults.isEmpty {
                    noResultsState
                } else {
                    searchResultsList
                }
            }
        }
        .navigationTitle("Search")
        .alert("Error", isPresented: $viewModel.showError) {
            Button("OK") { viewModel.showError = false }
        } message: {
            Text(viewModel.errorMessage ?? "An error occurred")
        }
    }
    
    // MARK: - Subviews
    
    private var loadingState: some View {
        VStack {
            Spacer()
            ProgressView()
                .scaleEffect(1.5)
                .foregroundStyle(.white)
            Spacer()
        }
    }
    
    private var emptyState: some View {
        VStack(spacing: 12) {
            Spacer()
            Image(systemName: "magnifyingglass")
                .font(.system(size: 60))
                .foregroundStyle(.white.opacity(0.6))
            Text("Search for a city")
                .foregroundStyle(.white.opacity(0.8))
                .font(AppTheme.Typography.headline)
            Spacer()
        }
    }
    
    private var noResultsState: some View {
        VStack(spacing: 12) {
            Spacer()
            Image(systemName: "questionmark.circle")
                .font(.system(size: 60))
                .foregroundStyle(.white.opacity(0.6))
            Text("No locations found")
                .foregroundStyle(.white.opacity(0.8))
                .font(AppTheme.Typography.headline)
            Spacer()
        }
    }
    
    private var recentSearchesList: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Recent Searches")
                    .font(AppTheme.Typography.headline)
                    .foregroundStyle(.white)
                Spacer()
                Button("Clear") {
                    viewModel.clearSearch()
                }
                .foregroundStyle(.white.opacity(0.6))
            }
            .padding(.horizontal)
            
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(viewModel.recentSearches) { location in
                        LocationRow(location: location)
                            .onTapGesture {
                                selectLocation(location)
                            }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    private var searchResultsList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.searchResults) { location in
                    LocationRow(location: location)
                        .onTapGesture {
                            selectLocation(location)
                        }
                }
            }
            .padding(.horizontal)
        }
    }
    
    // MARK: - Actions
    
    private func selectLocation(_ location: LocationEntity) {
        viewModel.saveLocationToRecent(location)
        Task {
            await weatherViewModel.selectLocation(location)
            router.navigateToRoot()
        }
    }
}

// MARK: - Components

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.white.opacity(0.6))
            
            TextField("Search city", text: $text)
                .foregroundStyle(.white)
                .autocorrectionDisabled()
            
            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.white.opacity(0.6))
                }
            }
        }
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(12)
    }
}

struct LocationRow: View {
    let location: LocationEntity
    
    var body: some View {
        LiquidGlassCard {
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(location.name)
                        .foregroundStyle(.white)
                        .font(AppTheme.Typography.headline)
                    
                    HStack(spacing: 4) {
                        Text(location.country)
                            .foregroundStyle(.white.opacity(0.6))
                            .font(.caption)
                        
                        if let region = location.region, !region.isEmpty {
                            Text("•")
                                .foregroundStyle(.white.opacity(0.4))
                            Text(region)
                                .foregroundStyle(.white.opacity(0.6))
                                .font(.caption)
                        }
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundStyle(.white.opacity(0.4))
                    .font(.caption)
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 8)
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        SearchView()
            .environmentObject(Router())
            .environmentObject(Container.preview.makeWeatherViewModel())
    }
}