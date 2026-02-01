//
//  HourlyForecastView.swift
//  WeatherAppPro
//
//  Created by Dony on 31/01/26
//

import SwiftUI

struct HourlyForecastView: View {
    let forecast: [HourlyWeather]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "clock")
                    .foregroundStyle(.white.opacity(0.8))
                Text("Now")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.8))
                    .textCase(.uppercase)
                Spacer()
            }
            .padding(.top, 12)
            Divider()
                .background(.white.opacity(0.3))
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 24) {
                    ForEach(forecast.prefix(24)) { hour in
                        HourCard(hour: hour)
                    }
                }
                .padding(.vertical, 12)
            }
        }
        .padding(.horizontal, 20)
        .liquidGlass()
    }
}

private struct HourCard: View {
    let hour: HourlyWeather
    @EnvironmentObject private var settings: SettingsViewModel
    
    var body: some View {
        VStack(spacing: 12) {
            Text(formatHour(hour.hour))
                .font(.subheadline)
                .foregroundStyle(.white)
            Image(systemName: hour.icon)
                .font(.title2)
                .foregroundStyle(.white)
                .symbolRenderingMode(.hierarchical)
                .frame(height: 30)
            Text("\(Int(settings.convert(hour.temperature)))°")
                .font(.title3)
                .foregroundStyle(.white)
        }
        .frame(width: 50)
    }
    
    private func formatHour(_ hourString: String) -> String {
        if hourString == "Now" {
            return "Now"
        }
        let components = hourString.split(separator: ":")
        guard let hourInt = Int(components[0]) else { return hourString }
        if hourInt == 0 {
            return "12 AM"
        } else if hourInt < 12 {
            return "\(hourInt) AM"
        } else if hourInt == 12 {
            return "12 PM"
        } else {
            return "\(hourInt - 12) PM"
        }
    }
}

#Preview {
    ZStack {
        Rectangle()
            .fill(Color.blue.gradient)
            .ignoresSafeArea()
        HourlyForecastView(
            forecast: [
                HourlyWeather(hour: "Now", temperature: 6, condition: "Cloudy", icon: "cloud.fill"),
                HourlyWeather(hour: "05:00", temperature: 6, condition: "Cloudy", icon: "cloud.fill"),
                HourlyWeather(hour: "06:00", temperature: 6, condition: "Cloudy", icon: "cloud.fill"),
                HourlyWeather(hour: "07:00", temperature: 7, condition: "Cloudy", icon: "cloud.fill"),
                HourlyWeather(hour: "07:58", temperature: 7, condition: "Sunrise", icon: "sunrise.fill"),
                HourlyWeather(hour: "08:00", temperature: 7, condition: "Cloudy", icon: "cloud.fill"),
                HourlyWeather(hour: "09:00", temperature: 7, condition: "Cloudy", icon: "cloud.fill")
            ]
        )
        .environmentObject(SettingsViewModel())
        .padding(20)
    }
}
