//
//  SettingsView.swift
//  WeatherAppPro
//
//  Settings View - 100% UI only
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var viewModel: SettingsViewModel
    @EnvironmentObject private var router: Router
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.weatherBackground(for: "Cloudy"))
                .ignoresSafeArea()
            
            Form {
                Section {
                    Picker("Temperature Unit", selection: $viewModel.temperatureUnit) {
                        ForEach(TemperatureUnit.allCases) { unit in
                            Text("\(unit.rawValue) (\(unit.symbol))").tag(unit)
                        }
                    }
                    .pickerStyle(.navigationLink)
                } header: {
                    Text("Units")
                        .textCase(.uppercase)
                }
                
                Section {
                    Picker("Wind Speed", selection: $viewModel.windSpeedUnit) {
                        ForEach(WindSpeedUnit.allCases) { unit in
                            Text(unit.rawValue).tag(unit)
                        }
                    }
                    .pickerStyle(.navigationLink)
                } footer: {
                    Text("Choose your preferred units for displaying weather data.")
                }
                
                Section {
                    Button(role: .destructive) {
                        viewModel.resetToDefaults()
                    } label: {
                        Label("Reset to Defaults", systemImage: "arrow.counterclockwise")
                    }
                }
                
                Section {
                    HStack {
                        Text("App Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundStyle(.secondary)
                    }
                } header: {
                    Text("About")
                        .textCase(.uppercase)
                }
            }
            .scrollContentBackground(.hidden)
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        SettingsView()
            .environmentObject(SettingsViewModel())
            .environmentObject(Router())
    }
}