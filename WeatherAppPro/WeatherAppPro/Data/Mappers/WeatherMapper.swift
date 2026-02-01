//
//  WeatherMapper.swift
//  WeatherAppPro
//
//  Created by Donnadony Mollo on Feb 1, 2026.
//


/// Maps Weather API responses to Domain entities
enum WeatherMapper {
    
    /// Maps API location to domain entity
    static func mapLocation(_ api: APILocation) -> LocationEntity {
        LocationEntity(
            name: api.name,
            latitude: api.lat,
            longitude: api.lon,
            country: api.country,
            region: api.region,
            timezoneId: api.tz_id
        )
    }
    
    /// Maps API search result to domain entity
    static func mapSearchResult(_ api: APISearchResult) -> LocationEntity {
        LocationEntity(
            name: api.name,
            latitude: api.lat,
            longitude: api.lon,
            country: api.country,
            region: api.region,
            timezoneId: api.tz_id
        )
    }
    
    /// Maps complete API response to domain entity
    static func mapWeatherData(_ api: WeatherAPIResponse) -> WeatherDataEntity {
        let location = mapLocation(api.location)
        let current = mapCurrent(api.current, locationId: location.id)
        let hourly = mapHourly(api.forecast?.forecastday.first?.hour ?? [], locationId: location.id)
        let daily = mapDaily(api.forecast?.forecastday ?? [], locationId: location.id)
        
        return WeatherDataEntity(
            location: location,
            current: current,
            hourlyForecast: hourly,
            dailyForecast: daily,
            lastUpdated: Date(),
            dataSource: .remote
        )
    }
    
    /// Maps current conditions
    static func mapCurrent(_ api: APICurrent, locationId: UUID) -> WeatherEntity {
        WeatherEntity(
            locationId: locationId,
            temperature: api.temp_c,
            feelsLike: api.feelslike_c,
            condition: api.condition.text,
            conditionCode: api.condition.code,
            humidity: api.humidity,
            windSpeed: api.wind_kph,
            windDirection: api.wind_dir,
            pressure: api.pressure_mb,
            uvIndex: api.uv,
            visibility: api.vis_km,
            timestamp: Date(),
            isDay: api.is_day == 1
        )
    }
    
    /// Maps hourly forecast
    static func mapHourly(_ api: [APIHour], locationId: UUID) -> [HourlyWeatherEntity] {
        api.map { hour in
            HourlyWeatherEntity(
                hour: formatHour(hour.time),
                temperature: hour.temp_c,
                condition: hour.condition.text,
                icon: WeatherIconMapper.icon(for: hour.condition.text, isNight: hour.is_day == 0),
                chanceOfRain: hour.chance_of_rain,
                isDay: hour.is_day == 1
            )
        }
    }
    
    /// Maps daily forecast
    static func mapDaily(_ api: [APIForecastDay], locationId: UUID) -> [DailyWeatherEntity] {
        api.map { day in
            DailyWeatherEntity(
                date: parseDate(day.date) ?? Date(),
                dayName: formatDay(day.date),
                high: day.day.maxtemp_c,
                low: day.day.mintemp_c,
                condition: day.day.condition.text,
                icon: WeatherIconMapper.icon(for: day.day.condition.text),
                chanceOfRain: day.day.daily_chance_of_rain,
                sunrise: day.astro?.sunrise,
                sunset: day.astro?.sunset
            )
        }
    }
    
    /// Maps astronomy API response
    static func mapAstronomy(_ api: AstronomyAPIResponse, locationId: UUID, date: Date) -> AstronomyEntity {
        AstronomyEntity(
            locationId: locationId,
            date: date,
            sunrise: api.astronomy.astro.sunrise,
            sunset: api.astronomy.astro.sunset,
            moonrise: api.astronomy.astro.moonrise,
            moonset: api.astronomy.astro.moonset,
            moonPhase: api.astronomy.astro.moon_phase,
            moonIllumination: Int(api.astronomy.astro.moon_illumination) ?? 0,
            isMoonUp: api.astronomy.astro.is_moon_up == 1,
            isSunUp: api.astronomy.astro.is_sun_up == 1
        )
    }
    
    /// Maps timezone API response
    static func mapTimeZone(_ api: TimeZoneAPIResponse, locationId: UUID) -> TimeZoneEntity {
        TimeZoneEntity(
            locationId: locationId,
            locationName: api.location.name,
            country: api.location.country,
            localtime: api.location.localtime,
            timezone: api.location.tz_id
        )
    }
    
    /// Maps history API response
    static func mapHistory(_ api: HistoryAPIResponse, locationId: UUID, date: Date) -> HistoricalWeatherEntity {
        guard let day = api.forecast.forecastday.first?.day else {
            fatalError("Invalid history response")
        }
        
        return HistoricalWeatherEntity(
            locationId: locationId,
            date: date,
            dateString: api.forecast.forecastday.first?.date ?? "",
            maxTemp: day.maxtemp_c,
            minTemp: day.mintemp_c,
            avgTemp: day.avgtemp_c,
            condition: day.condition.text,
            maxWind: day.maxwind_kph,
            avgHumidity: day.avghumidity,
            totalPrecipitation: day.totalprecip_mm,
            uvIndex: day.uv
        )
    }
    
    // MARK: - Helper Methods
    
    private static func formatHour(_ timeString: String) -> String {
        let components = timeString.split(separator: " ")
        return components.count > 1 ? String(components[1]) : timeString
    }
    
    private static func formatDay(_ dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let date = formatter.date(from: dateString) else {
            return dateString
        }
        formatter.dateFormat = "EEE"
        return formatter.string(from: date)
    }
    
    private static func parseDate(_ dateString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: dateString)
    }
}