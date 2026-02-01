//
//  CurrentWeatherView.swift
//  WeatherAppPro
//
//  Created by Dony on 31/01/26
//

import SwiftUI

struct CurrentWeatherView: View {
    let weather: WeatherData
    @EnvironmentObject private var settings: SettingsViewModel
    
    var body: some View {
        VStack(spacing: 16) {
            Text("MY LOCATION")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(.white.opacity(0.8))
                .tracking(1.5)
            Text(weather.location.name)
                .font(.system(size: 36, weight: .medium))
                .foregroundStyle(.white)
            Text("\(Int(settings.convert(weather.temperature)))°")
                .font(.system(size: 96, weight: .thin))
                .foregroundStyle(.white)
            VStack(spacing: 4) {
                Text("Feels Like: \(Int(settings.convert(weather.feelsLike)))°")
                    .font(.title3)
                    .foregroundStyle(.white.opacity(0.9))
                if let daily = weather.dailyForecast.first {
                    Text("H:\(Int(settings.convert(daily.high)))° L:\(Int(settings.convert(daily.low)))°")
                        .font(.title3)
                        .foregroundStyle(.white.opacity(0.9))
                }
            }
            Spacer()
                .frame(height: 20)
            Text(weatherDescription)
                .font(.body)
                .foregroundStyle(.white.opacity(0.9))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .padding(.vertical, 40)
    }
    
    private var weatherIcon: String {
        WeatherIconMapper.icon(for: weather.condition)
    }
    
    private var weatherDescription: String {
        let condition = weather.condition
        let temp = Int(settings.convert(weather.temperature))
        let feelsLike = Int(settings.convert(weather.feelsLike))
        if condition.lowercased().contains("rain") {
            return "Rainy conditions expected. The lowest Feels Like temperature will be \(feelsLike)°."
        } else if condition.lowercased().contains("cloud") {
            return "Cloudy conditions throughout the day. Temperature around \(temp)°."
        } else if condition.lowercased().contains("clear") || condition.lowercased().contains("sunny") {
            return "Clear and sunny conditions. Perfect weather with temperature at \(temp)°."
        } else if condition.lowercased().contains("snow") {
            return "Snow expected. Stay warm as temperature drops to \(feelsLike)°."
        } else {
            return "\(condition) conditions. Current temperature: \(temp)°."
        }
    }
}

#Preview {
    ZStack {
        Rectangle()
            .fill(LinearGradient(colors: [Color(hex: "3A6EA5"), Color(hex: "004E92")], startPoint: .topLeading, endPoint: .bottomTrailing))
            .ignoresSafeArea()
        CurrentWeatherView(
            weather: WeatherData(
                temperature: 6,
                feelsLike: -1,
                condition: "Light rain",
                humidity: 90,
                windSpeed: 15,
                location: Location(name: "Liverpool", latitude: 53.4084, longitude: -2.9916, country: "UK"),
                hourlyForecast: [],
                dailyForecast: [DailyWeather(day: "Today", high: 8, low: 6, condition: "Rainy", icon: "cloud.rain.fill")]
            )
        )
        .environmentObject(SettingsViewModel())
    }
}
