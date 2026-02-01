//
//  WeatherHomeView.swift
//  WeatherAppPro
//
//  Created by Donnadony Mollo on Feb 1, 2026.
//

import SwiftUI

struct WeatherHomeView: View {
    @EnvironmentObject private var viewModel: WeatherViewModel
    @EnvironmentObject private var router: Router
    @EnvironmentObject private var settingsViewModel: SettingsViewModel
    
    var body: some View {
        ZStack {
            backgroundGradient
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    if viewModel.viewState.isLoading {
                        loadingView
                    } else if let weather = viewModel.weatherData {
                        weatherContent(weather: weather)
                    } else if let error = viewModel.viewState.errorMessage {
                        errorView(message: error)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical)
            }
            .refreshable {
                await viewModel.refresh()
            }
        }
        .navigationTitle(viewModel.locationName)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                searchButton
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                settingsButton
            }
        }
        .task {
            if viewModel.weatherData == nil {
                await viewModel.fetchWeather()
            }
        }
    }
    
    // MARK: - Subviews
    
    private var backgroundGradient: some View {
        Rectangle()
            .fill(Color.weatherBackground(for: viewModel.weatherCondition))
    }
    
    private func weatherContent(weather: WeatherDataEntity) -> some View {
        VStack(spacing: 24) {
            CurrentWeatherSection(weather: weather)
            
            if !weather.hourlyForecast.isEmpty {
                HourlyForecastSection(
                    forecast: weather.hourlyForecast,
                    onSelect: {
                        router.navigate(to: .hourlyDetail(dayIndex: 0))
                    }
                )
            }
            
            if !weather.dailyForecast.isEmpty {
                DailyForecastSection(
                    forecast: weather.dailyForecast,
                    onSelect: { index in
                        router.navigate(to: .dailyDetail(dayIndex: index))
                    }
                )
            }
            
            MoreInfoSection(
                location: weather.location,
                onAstronomy: {
                    router.navigateToAstronomy(for: weather.location)
                },
                onTimeZone: {
                    router.navigateToTimeZone(for: weather.location)
                },
                onHistory: {
                    router.navigateToHistory(for: weather.location)
                },
                onSearch: {
                    router.navigate(to: .search)
                }
            )
            
            if viewModel.isShowingCachedData {
                cachedDataBanner
            }
            
            lastUpdatedText
        }
    }
    
    private var loadingView: some View {
        LiquidGlassCard {
            ProgressView()
                .scaleEffect(1.5)
                .frame(height: 200)
        }
    }
    
    private func errorView(message: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 60))
                .foregroundStyle(.white)
            Text(message)
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
            Button("Try Again") {
                Task { await viewModel.refresh() }
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
    
    private var cachedDataBanner: some View {
        HStack {
            Image(systemName: "arrow.clockwise.circle.fill")
            Text("Showing cached data")
                .font(.caption)
        }
        .foregroundStyle(.yellow)
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(.ultraThinMaterial)
        .cornerRadius(8)
    }
    
    private var lastUpdatedText: some View {
        Text(viewModel.lastUpdatedText)
            .font(.caption2)
            .foregroundStyle(.white.opacity(0.5))
    }
    
    private var searchButton: some View {
        Button {
            router.navigate(to: .search)
        } label: {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.white)
        }
    }
    
    private var settingsButton: some View {
        Button {
            router.navigate(to: .settings)
        } label: {
            Image(systemName: "gearshape.fill")
                .foregroundStyle(.white)
        }
    }
}

// MARK: - Section Views

struct CurrentWeatherSection: View {
    let weather: WeatherDataEntity
    @EnvironmentObject private var settingsViewModel: SettingsViewModel
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: WeatherIconMapper.icon(for: weather.current.condition))
                .font(.system(size: 80))
                .foregroundStyle(.white)
            
            Text(settingsViewModel.formatTemperature(weather.current.temperature))
                .font(.system(size: 72, weight: .thin))
                .foregroundStyle(.white)
            
            Text(weather.current.condition)
                .font(.title2)
                .foregroundStyle(.white)
            
            HStack(spacing: 24) {
                WeatherDetailItem(
                    icon: "humidity.fill",
                    label: "\(weather.current.humidity)%"
                )
                WeatherDetailItem(
                    icon: "wind",
                    label: settingsViewModel.formatWindSpeed(weather.current.windSpeed)
                )
            }
        }
        .padding(.vertical, 20)
    }
}

struct HourlyForecastSection: View {
    let forecast: [HourlyWeatherEntity]
    let onSelect: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Hourly Forecast")
                .font(AppTheme.Typography.headline)
                .foregroundStyle(.white)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(forecast) { hour in
                        HourlyItem(hour: hour)
                    }
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 12)
        .background(.ultraThinMaterial)
        .cornerRadius(16)
        .onTapGesture(perform: onSelect)
    }
}

struct HourlyItem: View {
    let hour: HourlyWeatherEntity
    @EnvironmentObject private var settingsViewModel: SettingsViewModel
    
    var body: some View {
        VStack(spacing: 8) {
            Text(hour.hour)
                .font(.caption)
                .foregroundStyle(.white.opacity(0.8))
            
            Image(systemName: hour.icon)
                .font(.title3)
                .foregroundStyle(.white)
            
            Text(settingsViewModel.formatTemperature(hour.temperature))
                .font(.subheadline)
                .foregroundStyle(.white)
        }
        .frame(width: 50)
    }
}

struct DailyForecastSection: View {
    let forecast: [DailyWeatherEntity]
    let onSelect: (Int) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("7-Day Forecast")
                .font(AppTheme.Typography.headline)
                .foregroundStyle(.white)
            
            VStack(spacing: 8) {
                ForEach(Array(forecast.enumerated()), id: \.element.id) { index, day in
                    DailyItem(day: day)
                        .onTapGesture {
                            onSelect(index)
                        }
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 12)
        .background(.ultraThinMaterial)
        .cornerRadius(16)
    }
}

struct DailyItem: View {
    let day: DailyWeatherEntity
    @EnvironmentObject private var settingsViewModel: SettingsViewModel
    
    var body: some View {
        HStack {
            Text(day.dayName)
                .font(.subheadline)
                .foregroundStyle(.white)
                .frame(width: 40, alignment: .leading)
            
            Image(systemName: day.icon)
                .foregroundStyle(.white)
                .frame(width: 30)
            
            Text(day.condition)
                .font(.caption)
                .foregroundStyle(.white.opacity(0.8))
                .lineLimit(1)
            
            Spacer()
            
            HStack(spacing: 8) {
                Text(settingsViewModel.formatTemperature(day.high))
                    .font(.subheadline)
                    .foregroundStyle(.white)
                
                Text(settingsViewModel.formatTemperature(day.low))
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.6))
            }
        }
        .padding(.vertical, 4)
    }
}

struct MoreInfoSection: View {
    let location: LocationEntity
    let onAstronomy: () -> Void
    let onTimeZone: () -> Void
    let onHistory: () -> Void
    let onSearch: () -> Void
    
    var body: some View {
        VStack(spacing: 12) {
            Text("More Information")
                .font(AppTheme.Typography.headline)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            MoreInfoButton(
                icon: "magnifyingglass.circle.fill",
                title: "Search Cities",
                action: onSearch
            )
            
            HStack(spacing: 12) {
                MoreInfoButton(
                    icon: "sun.and.horizon.fill",
                    title: "Astronomy",
                    action: onAstronomy
                )
                
                MoreInfoButton(
                    icon: "clock.fill",
                    title: "Time Zone",
                    action: onTimeZone
                )
            }
            
            MoreInfoButton(
                icon: "calendar",
                title: "Historical Weather",
                action: onHistory
            )
        }
    }
}

struct MoreInfoButton: View {
    let icon: String
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            LiquidGlassCard(cornerRadius: 16) {
                VStack(spacing: 8) {
                    Image(systemName: icon)
                        .font(.title)
                        .foregroundStyle(.white)
                    Text(title)
                        .font(.caption)
                        .foregroundStyle(.white)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
            }
        }
        .buttonStyle(.plain)
    }
}

struct WeatherDetailItem: View {
    let icon: String
    let label: String
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .foregroundStyle(.white.opacity(0.8))
            Text(label)
                .font(.subheadline)
                .foregroundStyle(.white)
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        WeatherHomeView()
            .environmentObject(Container.preview.makeWeatherViewModel())
            .environmentObject(Router())
            .environmentObject(SettingsViewModel())
    }
}