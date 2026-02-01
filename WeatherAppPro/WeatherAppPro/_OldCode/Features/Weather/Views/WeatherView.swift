//
//  WeatherView.swift
//  WeatherAppPro
//
//  Created by Dony on 31/01/26
//

import SwiftUI

struct WeatherView: View {
    @EnvironmentObject private var viewModel: WeatherViewModel
    @EnvironmentObject private var router: Router
    
    var body: some View {
        ZStack {
            backgroundGradient
                .ignoresSafeArea()
            ScrollView {
                VStack(spacing: 24) {
                    if let weather = viewModel.weatherData {
                        CurrentWeatherView(weather: weather)
                        HourlyForecastView(forecast: weather.hourlyForecast)
                            .padding(.horizontal)
                        DailyForecastView(forecast: weather.dailyForecast)
                            .padding(.horizontal)
                        moreInfoSection
                            .padding(.horizontal)
                    } else if viewModel.isLoading {
                        loadingView
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical)
            }
            .refreshable {
                await viewModel.refresh()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.fetchWeather()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    router.navigate(to: .search)
                } label: {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(.white)
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    router.navigate(to: .settings)
                } label: {
                    Image(systemName: "gearshape.fill")
                        .foregroundStyle(.white)
                }
            }
        }
    }
    
    private var backgroundGradient: some View {
        Rectangle()
            .fill(Color.weatherBackground(for: viewModel.weatherData?.condition ?? "Sunny"))
    }
    
    private var loadingView: some View {
        LiquidGlassCard {
            ProgressView()
                .scaleEffect(1.5)
                .frame(height: 200)
        }
    }
    
    private var moreInfoSection: some View {
        VStack(spacing: 12) {
            Text("More Information")
                .font(AppTheme.Typography.headline)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            MoreInfoButton(
                icon: "magnifyingglass.circle.fill",
                title: "Search Cities"
            ) {
                router.navigate(to: .search)
            }
            HStack(spacing: 12) {
                MoreInfoButton(
                    icon: "sun.and.horizon.fill",
                    title: "Astronomy"
                ) {
                    router.navigate(to: .astronomy(location: viewModel.selectedLocation))
                }
                MoreInfoButton(
                    icon: "clock.fill",
                    title: "Time Zone"
                ) {
                    router.navigate(to: .timeZone(location: viewModel.selectedLocation))
                }
            }
            MoreInfoButton(
                icon: "calendar",
                title: "Historical Weather"
            ) {
                router.navigate(to: .history(location: viewModel.selectedLocation))
            }
        }
    }
}

private struct MoreInfoButton: View {
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
                .padding(.vertical, 8)
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    NavigationStack {
        WeatherView()
            .environmentObject(Router())
            .environmentObject(WeatherViewModel())
            .environmentObject(SettingsViewModel())
    }
}
