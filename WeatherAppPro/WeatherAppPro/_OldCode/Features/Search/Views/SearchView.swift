//
//  SearchView.swift
//  WeatherAppPro
//
//  Created by Dony on 31/01/26
//

import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()
    @EnvironmentObject private var router: Router
    @EnvironmentObject private var weatherViewModel: WeatherViewModel
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.weatherBackground(for: "Cloudy"))
                .ignoresSafeArea()
            VStack {
                SearchBar(text: $viewModel.searchText)
                    .padding()
                if viewModel.isSearching {
                    ProgressView()
                        .scaleEffect(1.5)
                        .padding()
                } else if viewModel.searchText.isEmpty {
                    emptyState
                } else if viewModel.results.isEmpty {
                    noResults
                } else {
                    searchResults
                }
                Spacer()
            }
        }
        .navigationTitle("Search")
    }
    
    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 60))
                .foregroundStyle(.white.opacity(0.6))
            Text("Search for a city")
                .foregroundStyle(.white.opacity(0.8))
                .font(AppTheme.Typography.headline)
        }
        .padding(.top, 60)
    }
    
    private var noResults: some View {
        VStack(spacing: 12) {
            Image(systemName: "questionmark.circle")
                .font(.system(size: 60))
                .foregroundStyle(.white.opacity(0.6))
            Text("No locations found")
                .foregroundStyle(.white.opacity(0.8))
                .font(AppTheme.Typography.headline)
        }
        .padding(.top, 60)
    }
    
    private var searchResults: some View {
        ScrollView {
            VStack(spacing: 12) {
                ForEach(viewModel.results) { location in
                    LocationRow(location: location)
                        .onTapGesture {
                            Task {
                                weatherViewModel.selectedLocation = location
                                await weatherViewModel.fetchWeather()
                                router.navigateToRoot()
                            }
                        }
                }
            }
            .padding(.horizontal)
        }
    }
}

private struct LocationRow: View {
    let location: Location
    
    var body: some View {
        LiquidGlassCard {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(location.name)
                        .foregroundStyle(.white)
                        .font(AppTheme.Typography.headline)
                    Text(location.country)
                        .foregroundStyle(.white.opacity(0.6))
                        .font(.caption)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundStyle(.white.opacity(0.4))
            }
            .padding(.vertical, 8)
        }
    }
}

private struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.white.opacity(0.6))
            TextField("Search city", text: $text)
                .foregroundStyle(.white)
                .autocorrectionDisabled()
        }
        .padding()
        .liquidGlass()
    }
}

#Preview {
    NavigationStack {
        SearchView()
            .environmentObject(Router())
            .environmentObject(WeatherViewModel())
            .environmentObject(SettingsViewModel())
    }
}
