//
//  SettingsView.swift
//  WeatherAppPro
//
//  Created by Dony on 31/01/26
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var settings: SettingsViewModel
    @EnvironmentObject private var router: Router
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.weatherBackground(for: "Cloudy"))
                .ignoresSafeArea()
            ScrollView {
                VStack(spacing: 20) {
                    LiquidGlassCard {
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Image(systemName: "thermometer.medium")
                                    .foregroundStyle(.white)
                                Text("Temperature Unit")
                                    .font(AppTheme.Typography.headline)
                                    .foregroundStyle(.white)
                            }
                            Picker("Unit", selection: $settings.temperatureUnit) {
                                ForEach(TemperatureUnit.allCases, id: \.self) { unit in
                                    Text(unit.rawValue).tag(unit)
                                }
                            }
                            .pickerStyle(.segmented)
                        }
                        .padding(.vertical, 8)
                    }
                    LiquidGlassCard {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "info.circle")
                                    .foregroundStyle(.white)
                                Text("About")
                                    .font(AppTheme.Typography.headline)
                                    .foregroundStyle(.white)
                                Spacer(minLength: 0)
                            }
                            Text("WeatherAppPro")
                                .font(.body)
                                .foregroundStyle(.white.opacity(0.8))
                            Text("Real-time weather data powered by WeatherAPI.com")
                                .font(.caption)
                                .foregroundStyle(.white.opacity(0.6))
                        }
                        .padding(.vertical, 8)
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
    NavigationStack {
        SettingsView()
            .environmentObject(Router())
            .environmentObject(SettingsViewModel())
    }
}
