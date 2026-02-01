//
//  TimeZoneView.swift
//  WeatherAppPro
//
//  Created by Dony on 31/01/26
//

import SwiftUI

struct TimeZoneView: View {
    @StateObject private var viewModel = TimeZoneViewModel()
    let location: Location
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(LinearGradient(colors: [.cyan, .blue], startPoint: .topLeading, endPoint: .bottomTrailing))
                .ignoresSafeArea()
            VStack(spacing: 24) {
                if let tz = viewModel.timeZoneData {
                    LiquidGlassCard {
                        VStack(spacing: 24) {
                            Image(systemName: "clock.fill")
                                .font(.system(size: 80))
                                .foregroundStyle(.white)
                            Text(tz.locationName)
                                .font(AppTheme.Typography.title)
                                .foregroundStyle(.white)
                            Text(tz.country)
                                .foregroundStyle(.white.opacity(0.8))
                            Divider()
                                .background(.white.opacity(0.3))
                            VStack(spacing: 16) {
                                InfoRow(label: "Local Time", value: tz.localtime)
                                InfoRow(label: "Time Zone", value: tz.timezone)
                            }
                        }
                        .padding(.vertical, 20)
                    }
                    if let error = viewModel.errorMessage {
                        Text("Using sample data. API Error: \(error)")
                            .font(.caption)
                            .foregroundStyle(.white.opacity(0.6))
                            .multilineTextAlignment(.center)
                    }
                } else if viewModel.isLoading {
                    ProgressView()
                        .scaleEffect(1.5)
                }
                Spacer()
            }
            .padding(20)
        }
        .navigationTitle("Time Zone")
        .task {
            await viewModel.fetchTimeZone(for: location)
        }
    }
}

private struct InfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundStyle(.white.opacity(0.7))
            Spacer()
            Text(value)
                .font(.headline)
                .foregroundStyle(.white)
        }
        .padding(.horizontal)
    }
}

#Preview {
    NavigationStack {
        TimeZoneView(location: .sample)
    }
}
