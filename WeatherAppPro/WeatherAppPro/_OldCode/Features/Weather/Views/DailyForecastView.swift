//
//  DailyForecastView.swift
//  WeatherAppPro
//
//  Created by Dony on 31/01/26
//

import SwiftUI

struct DailyForecastView: View {
    
    // MARK: - Properties
    
    let forecast: [DailyWeather]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Image(systemName: "calendar")
                    .foregroundStyle(.white.opacity(0.8))
                Text("\(forecast.count)-Day Forecast")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.8))
                    .textCase(.uppercase)
            }
            .padding(.top, 8)
            .padding(.bottom, 12)
            Divider()
                .background(.white.opacity(0.3))
            ForEach(Array(forecast.enumerated()), id: \.element.id) { index, day in
                DayRow(day: day, isFirst: index == 0)
                if index < forecast.count - 1 {
                    Divider()
                        .background(.white.opacity(0.2))
                        .padding(.leading, 60)
                }
            }
            Spacer(minLength: 0)
                
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 12)
        .liquidGlass()
    }
}

private struct DayRow: View {
    
    // MARK: - Properties
    
    let day: DailyWeather
    let isFirst: Bool
    @EnvironmentObject private var settings: SettingsViewModel
    
    var body: some View {
        HStack(spacing: 16) {
            Text(isFirst ? "Today" : day.day)
                .font(.body)
                .foregroundStyle(.white)
                .frame(width: 50, alignment: .leading)
            Image(systemName: day.icon)
                .font(.title3)
                .foregroundStyle(.white)
                .symbolRenderingMode(.hierarchical)
                .frame(width: 30)
            if shouldShowRainPercentage(day.condition) {
                HStack(spacing: 4) {
                    Image(systemName: "drop.fill")
                        .font(.caption)
                    Text(rainPercentage(for: day.condition))
                        .font(.caption)
                }
                .foregroundStyle(.cyan)
                .frame(width: 40)
            } else {
                Spacer(minLength: 0)
            }
            Spacer()
            HStack(spacing: 8) {
                Text("\(Int(settings.convert(day.low)))°")
                    .font(.body)
                    .foregroundStyle(.white.opacity(0.6))
                    .frame(width: 35, alignment: .trailing)
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(.white.opacity(0.2))
                        Capsule()
                            .fill(LinearGradient(colors: [.cyan, .blue], startPoint: .leading, endPoint: .trailing))
                            .frame(width: geo.size.width * 0.7)
                    }
                }
                .frame(width: 100, height: 4)
                Text("\(Int(settings.convert(day.high)))°")
                    .font(.body)
                    .foregroundStyle(.white)
                    .frame(width: 35, alignment: .leading)
            }
        }
        .padding(.vertical, 14)
        
    }
    
    private func shouldShowRainPercentage(_ condition: String) -> Bool {
        condition.lowercased().contains("rain") || 
        condition.lowercased().contains("storm") ||
        condition.lowercased().contains("drizzle")
    }
    
    private func rainPercentage(for condition: String) -> String {
        let lowercased = condition.lowercased()
        if lowercased.contains("heavy") {
            return "90%"
        } else if lowercased.contains("light") {
            return "60%"
        } else {
            return "85%"
        }
    }
}

#Preview {
    ZStack {
        Rectangle()
            .fill(Color.blue.gradient)
            .ignoresSafeArea()
        DailyForecastView(
            forecast: [
                DailyWeather(day: "Today", high: 8, low: 6, condition: "Heavy rain", icon: "cloud.heavyrain.fill"),
                DailyWeather(day: "Sun", high: 8, low: 4, condition: "Light rain", icon: "cloud.drizzle.fill"),
                DailyWeather(day: "Mon", high: 7, low: 2, condition: "Cloudy", icon: "cloud.fill"),
                DailyWeather(day: "Tue", high: 5, low: 3, condition: "Light rain", icon: "cloud.rain.fill"),
                DailyWeather(day: "Wed", high: 7, low: 3, condition: "Partly cloudy", icon: "cloud.sun.fill"),
                DailyWeather(day: "Thu", high: 7, low: 2, condition: "Cloudy", icon: "cloud.fill"),
                DailyWeather(day: "Fri", high: 6, low: 2, condition: "Clear", icon: "sun.max.fill")
            ]
        )
        .environmentObject(SettingsViewModel())
        .padding(20)
    }
}
