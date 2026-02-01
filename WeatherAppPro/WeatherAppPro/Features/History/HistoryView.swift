//
//  HistoryView.swift
//  WeatherAppPro
//
//  History View - 100% UI only
//

import SwiftUI

struct HistoryView: View {
    @StateObject private var viewModel: HistoryViewModel
    @EnvironmentObject private var router: Router
    @EnvironmentObject private var settingsViewModel: SettingsViewModel
    
    init(location: LocationEntity) {
        _viewModel = StateObject(wrappedValue: Container.shared.makeHistoryViewModel(location: location))
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.weatherBackground(for: "Cloudy"))
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    datePickerSection
                    
                    if viewModel.viewState.isLoading {
                        loadingView
                    } else if viewModel.viewState == .invalidDate {
                        invalidDateView
                    } else {
                        historyContent
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Historical Weather")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.fetchHistory()
        }
    }
    
    // MARK: - Subviews
    
    private var datePickerSection: some View {
        VStack(spacing: 12) {
            Text("Select Date")
                .font(AppTheme.Typography.headline)
                .foregroundStyle(.white)
            
            DatePicker(
                "",
                selection: $viewModel.selectedDate,
                in: viewModel.validDateRange,
                displayedComponents: .date
            )
            .datePickerStyle(.compact)
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(12)
            .colorScheme(.dark)
            .onChange(of: viewModel.selectedDate) { _ in
                Task {
                    await viewModel.fetchHistory()
                }
            }
            
            Text("Data available from 2010 to yesterday")
                .font(.caption)
                .foregroundStyle(.white.opacity(0.6))
        }
    }
    
    private var historyContent: some View {
        VStack(spacing: 24) {
            dateHeader
            temperatureCard
            conditionsCard
            
            if let error = viewModel.viewState.errorMessage {
                errorBanner(message: error)
            }
        }
    }
    
    private var dateHeader: some View {
        VStack(spacing: 8) {
            Text(viewModel.dateString)
                .font(.title2)
                .foregroundStyle(.white)
            
            Text("Historical Weather Data")
                .font(.caption)
                .foregroundStyle(.white.opacity(0.7))
        }
    }
    
    private var temperatureCard: some View {
        LiquidGlassCard {
            VStack(spacing: 16) {
                HStack {
                    Image(systemName: "thermometer")
                        .font(.title2)
                        .foregroundStyle(.white)
                    Text("Temperature")
                        .font(AppTheme.Typography.headline)
                        .foregroundStyle(.white)
                    Spacer()
                }
                
                HStack(spacing: 24) {
                    TemperatureItem(
                        label: "Max",
                        value: settingsViewModel.formatTemperature(viewModel.maxTemp),
                        color: .orange
                    )
                    
                    TemperatureItem(
                        label: "Avg",
                        value: settingsViewModel.formatTemperature(viewModel.avgTemp),
                        color: .yellow
                    )
                    
                    TemperatureItem(
                        label: "Min",
                        value: settingsViewModel.formatTemperature(viewModel.minTemp),
                        color: .cyan
                    )
                }
            }
            .padding()
        }
    }
    
    private var conditionsCard: some View {
        LiquidGlassCard {
            VStack(spacing: 16) {
                HStack {
                    Image(systemName: "cloud.sun.fill")
                        .font(.title2)
                        .foregroundStyle(.white)
                    Text("Conditions")
                        .font(AppTheme.Typography.headline)
                        .foregroundStyle(.white)
                    Spacer()
                }
                
                VStack(spacing: 12) {
                    ConditionRow(icon: "cloud.fill", label: "Condition", value: viewModel.condition)
                    ConditionRow(icon: "wind", label: "Max Wind", value: "\(Int(viewModel.maxWind)) km/h")
                    ConditionRow(icon: "humidity.fill", label: "Avg Humidity", value: "\(Int(viewModel.avgHumidity))%")
                }
            }
            .padding()
        }
    }
    
    private var loadingView: some View {
        VStack {
            Spacer()
            ProgressView()
                .scaleEffect(1.5)
                .foregroundStyle(.white)
            Spacer()
        }
        .frame(height: 200)
    }
    
    private var invalidDateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "calendar.badge.exclamationmark")
                .font(.system(size: 60))
                .foregroundStyle(.white.opacity(0.6))
            Text("Invalid Date")
                .font(.headline)
                .foregroundStyle(.white)
            Text("Please select a date between 2010 and yesterday.")
                .font(.caption)
                .foregroundStyle(.white.opacity(0.7))
                .multilineTextAlignment(.center)
        }
        .padding()
    }
    
    private func errorBanner(message: String) -> some View {
        HStack {
            Image(systemName: "exclamationmark.triangle.fill")
            Text(message)
                .font(.caption)
        }
        .foregroundStyle(.yellow)
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(8)
    }
}

struct TemperatureItem: View {
    let label: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 4) {
            Text(label)
                .font(.caption)
                .foregroundStyle(.white.opacity(0.7))
            Text(value)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundStyle(color)
        }
        .frame(maxWidth: .infinity)
    }
}

struct ConditionRow: View {
    let icon: String
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundStyle(.white.opacity(0.7))
                .frame(width: 24)
            Text(label)
                .foregroundStyle(.white.opacity(0.7))
            Spacer()
            Text(value)
                .foregroundStyle(.white)
                .fontWeight(.medium)
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        HistoryView(location: .sampleLima)
            .environmentObject(Router())
            .environmentObject(SettingsViewModel())
    }
}