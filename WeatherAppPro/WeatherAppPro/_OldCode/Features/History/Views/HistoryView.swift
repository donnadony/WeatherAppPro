//
//  HistoryView.swift
//  WeatherAppPro
//
//  Created by Dony on 31/01/26
//

import SwiftUI

struct HistoryView: View {
    @StateObject private var viewModel = HistoryViewModel()
    let location: Location
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(LinearGradient(colors: [.orange, .red], startPoint: .topLeading, endPoint: .bottomTrailing))
                .ignoresSafeArea()
            ScrollView {
                VStack(spacing: 24) {
                    LiquidGlassCard {
                        VStack(spacing: 12) {
                            Text("Select Date")
                                .font(AppTheme.Typography.headline)
                                .foregroundStyle(.white)
                            DatePicker("", selection: $viewModel.selectedDate, in: ...Date(), displayedComponents: .date)
                                .datePickerStyle(.graphical)
                                .colorScheme(.dark)
                                .onChange(of: viewModel.selectedDate) { _, newDate in
                                    Task {
                                        await viewModel.fetchHistory(for: location, date: newDate)
                                    }
                                }
                        }
                    }
                    if let history = viewModel.historyData {
                        LiquidGlassCard {
                            VStack(spacing: 20) {
                                Image(systemName: "calendar")
                                    .font(.system(size: 60))
                                    .foregroundStyle(.white)
                                Text(history.date)
                                    .font(AppTheme.Typography.title)
                                    .foregroundStyle(.white)
                                Text(history.condition)
                                    .foregroundStyle(.white.opacity(0.8))
                                Divider()
                                    .background(.white.opacity(0.3))
                                VStack(spacing: 16) {
                                    HStack {
                                        Text("Average Temp")
                                            .foregroundStyle(.white.opacity(0.7))
                                        Spacer()
                                        Text("\(Int(history.avgTemp))°C")
                                            .font(.headline)
                                            .foregroundStyle(.white)
                                    }
                                    HStack {
                                        Text("High / Low")
                                            .foregroundStyle(.white.opacity(0.7))
                                        Spacer()
                                        Text("\(Int(history.maxTemp))° / \(Int(history.minTemp))°")
                                            .font(.headline)
                                            .foregroundStyle(.white)
                                    }
                                    HStack {
                                        Text("Max Wind")
                                            .foregroundStyle(.white.opacity(0.7))
                                        Spacer()
                                        Text("\(Int(history.maxWind)) km/h")
                                            .font(.headline)
                                            .foregroundStyle(.white)
                                    }
                                    HStack {
                                        Text("Avg Humidity")
                                            .foregroundStyle(.white.opacity(0.7))
                                        Spacer()
                                        Text("\(Int(history.avgHumidity))%")
                                            .font(.headline)
                                            .foregroundStyle(.white)
                                    }
                                }
                                .padding(.horizontal)
                            }
                            .padding(.vertical)
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
                            .padding()
                    }
                }
                .padding(20)
            }
        }
        .navigationTitle("Historical Weather")
        .task {
            await viewModel.fetchHistory(for: location, date: viewModel.selectedDate)
        }
    }
}

#Preview {
    NavigationStack {
        HistoryView(location: .sample)
    }
}
