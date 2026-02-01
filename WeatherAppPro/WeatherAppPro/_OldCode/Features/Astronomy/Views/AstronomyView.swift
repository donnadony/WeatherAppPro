//
//  AstronomyView.swift
//  WeatherAppPro
//
//  Created by Dony on 31/01/26
//

import SwiftUI

struct AstronomyView: View {
    @StateObject private var viewModel = AstronomyViewModel()
    let location: Location
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(LinearGradient(colors: [.indigo, .purple, .pink], startPoint: .topLeading, endPoint: .bottomTrailing))
                .ignoresSafeArea()
            ScrollView {
                VStack(spacing: 24) {
                    if let astro = viewModel.astronomyData {
                        LiquidGlassCard {
                            VStack(spacing: 20) {
                                Image(systemName: "sun.max.fill")
                                    .font(.system(size: 60))
                                    .foregroundStyle(.yellow)
                                Text("Sun")
                                    .font(AppTheme.Typography.title)
                                    .foregroundStyle(.white)
                                HStack(spacing: 40) {
                                    InfoColumn(icon: "sunrise.fill", label: "Sunrise", value: astro.sunrise)
                                    Spacer(minLength: 0)
                                    InfoColumn(icon: "sunset.fill", label: "Sunset", value: astro.sunset)
                                }
                            }
                            .padding(.vertical)
                        }
                        LiquidGlassCard {
                            VStack(spacing: 20) {
                                Image(systemName: moonIcon(for: astro.moonPhase))
                                    .font(.system(size: 60))
                                    .foregroundStyle(.white)
                                Text("Moon")
                                    .font(AppTheme.Typography.title)
                                    .foregroundStyle(.white)
                                Text(astro.moonPhase)
                                    .font(AppTheme.Typography.headline)
                                    .foregroundStyle(.white.opacity(0.8))
                                Text("\(astro.moonIllumination)% Illuminated")
                                    .foregroundStyle(.white.opacity(0.6))
                                Divider()
                                    .background(.white.opacity(0.3))
                                    .padding(.vertical, 8)
                                HStack(spacing: 40) {
                                    InfoColumn(icon: "moonrise.fill", label: "Moonrise", value: astro.moonrise)
                                    InfoColumn(icon: "moonset.fill", label: "Moonset", value: astro.moonset)
                                }
                            }
                            .padding(.vertical)
                        }
                        if let error = viewModel.errorMessage {
                            Text("Using sample data. API Error: \(error)")
                                .font(.caption)
                                .foregroundStyle(.white.opacity(0.6))
                                .multilineTextAlignment(.center)
                                .padding()
                        }
                    } else if viewModel.isLoading {
                        ProgressView()
                            .scaleEffect(1.5)
                            .padding()
                    }
                }
                .padding(20)
            }
        }
        .navigationTitle("Astronomy")
        .task {
            await viewModel.fetchAstronomy(for: location)
        }
    }
    
    private func moonIcon(for phase: String) -> String {
        let lowercased = phase.lowercased()
        if lowercased.contains("new") {
            return "moon.fill"
        } else if lowercased.contains("full") {
            return "moon.circle.fill"
        } else if lowercased.contains("first quarter") {
            return "moonphase.first.quarter"
        } else if lowercased.contains("last quarter") {
            return "moonphase.last.quarter"
        } else {
            return "moon.stars.fill"
        }
    }
}

private struct InfoColumn: View {
    let icon: String
    let label: String
    let value: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(.white)
            Text(label)
                .font(.caption)
                .foregroundStyle(.white.opacity(0.7))
            Text(value)
                .font(.headline)
                .foregroundStyle(.white)
        }
    }
}

#Preview {
    NavigationStack {
        AstronomyView(location: .sample)
    }
}
