//
//  AstronomyView.swift
//  WeatherAppPro
//
//  Created by Donnadony Mollo on Feb 1, 2026.
//

import SwiftUI

struct AstronomyView: View {
    @StateObject private var viewModel: AstronomyViewModel
    @EnvironmentObject private var router: Router
    
    init(location: LocationEntity) {
        _viewModel = StateObject(wrappedValue: Container.shared.makeAstronomyViewModel(location: location))
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.weatherBackground(for: "Night"))
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    if viewModel.viewState.isLoading {
                        loadingView
                    } else {
                        astronomyContent
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Astronomy")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.fetchAstronomy()
        }
    }
    
    // MARK: - Subviews
    
    private var astronomyContent: some View {
        VStack(spacing: 24) {
            datePicker
            
            sunCard
            
            moonCard
            
            if let error = viewModel.viewState.errorMessage {
                errorBanner(message: error)
            }
        }
    }
    
    private var datePicker: some View {
        VStack(spacing: 8) {
            Text("Select Date")
                .font(AppTheme.Typography.headline)
                .foregroundStyle(.white)
            
            DatePicker(
                "",
                selection: $viewModel.selectedDate,
                displayedComponents: .date
            )
            .datePickerStyle(.graphical)
            .background(.ultraThinMaterial)
            .cornerRadius(12)
            .colorScheme(.dark)
            .onChange(of: viewModel.selectedDate) { _ in
                Task {
                    await viewModel.fetchAstronomy()
                }
            }
        }
    }
    
    private var sunCard: some View {
        LiquidGlassCard {
            VStack(spacing: 16) {
                HStack {
                    Image(systemName: "sun.max.fill")
                        .font(.title)
                        .foregroundStyle(.yellow)
                    Text("Sun")
                        .font(AppTheme.Typography.headline)
                        .foregroundStyle(.white)
                    Spacer()
                }
                
                HStack(spacing: 24) {
                    SunMoonTimeItem(
                        icon: "sunrise.fill",
                        label: "Sunrise",
                        time: viewModel.sunriseTime,
                        color: .orange
                    )
                    
                    SunMoonTimeItem(
                        icon: "sunset.fill",
                        label: "Sunset",
                        time: viewModel.sunsetTime,
                        color: .red
                    )
                }
            }
            .padding()
        }
    }
    
    private var moonCard: some View {
        LiquidGlassCard {
            VStack(spacing: 16) {
                HStack {
                    Image(systemName: viewModel.moonIcon)
                        .font(.title)
                        .foregroundStyle(.white)
                    Text("Moon")
                        .font(AppTheme.Typography.headline)
                        .foregroundStyle(.white)
                    Spacer()
                }
                
                HStack(spacing: 24) {
                    SunMoonTimeItem(
                        icon: "arrow.up.circle.fill",
                        label: "Moonrise",
                        time: viewModel.moonriseTime,
                        color: .white
                    )
                    
                    SunMoonTimeItem(
                        icon: "arrow.down.circle.fill",
                        label: "Moonset",
                        time: viewModel.moonsetTime,
                        color: .gray
                    )
                }
                
                Divider()
                    .background(.white.opacity(0.2))
                
                VStack(spacing: 8) {
                    Text(viewModel.moonPhase)
                        .font(.headline)
                        .foregroundStyle(.white)
                    
                    Text("\(viewModel.moonIllumination)% illuminated")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.7))
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
        .frame(height: 400)
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

struct SunMoonTimeItem: View {
    let icon: String
    let label: String
    let time: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(color)
            Text(label)
                .font(.caption)
                .foregroundStyle(.white.opacity(0.7))
            Text(time)
                .font(.headline)
                .foregroundStyle(.white)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        AstronomyView(location: .sampleLima)
            .environmentObject(Router())
    }
}