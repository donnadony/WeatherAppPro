# WeatherAPI.com Reference

## Your API Key
```
b3bde67f88694266abc43610263101
```

## Available APIs

### 1. Current Weather ✅ (Implemented)
```
GET https://api.weatherapi.com/v1/current.json?key={API_KEY}&q={location}
```
**Returns:** Temperature, feels like, humidity, wind, condition

### 2. Forecast ✅ (Implemented)
```
GET https://api.weatherapi.com/v1/forecast.json?key={API_KEY}&q={location}&days=7
```
**Returns:** Current + hourly (24h) + daily (7 days)

### 3. Search/Autocomplete ✅ (Implemented)
```
GET https://api.weatherapi.com/v1/search.json?key={API_KEY}&q={query}
```
**Returns:** Array of matching locations with name, country, lat, lon

### 4. Astronomy
```
GET https://api.weatherapi.com/v1/astronomy.json?key={API_KEY}&q={location}&dt={date}
```
**Returns:** Sunrise, sunset, moonrise, moonset, moon phase

### 5. Time Zone
```
GET https://api.weatherapi.com/v1/timezone.json?key={API_KEY}&q={location}
```
**Returns:** Local time, timezone info

### 6. History
```
GET https://api.weatherapi.com/v1/history.json?key={API_KEY}&q={location}&dt={date}
```
**Returns:** Historical weather data for specific date

---

## Location Formats Supported

WeatherAPI accepts these formats for `q` parameter:

1. **City name**: `Lima`, `London`, `New York`
2. **Lat/Lon**: `48.8567,2.3508` (Paris)
3. **US ZIP**: `10001`
4. **UK Postcode**: `SW1`
5. **Canada Postal**: `G2J`
6. **IP Address**: `100.0.0.1`
7. **Auto**: `auto:ip` (user's location by IP)

---

## Free Tier Limits

- **1,000,000 calls/month** (very generous)
- Real-time weather
- 14-day forecast
- No credit card required

---

## Current Implementation

✅ **Current Weather** - WeatherService.swift
✅ **7-day Forecast** - WeatherService.swift
✅ **Location Search** - LocationSearchService.swift

---

## Documentation

Full docs: https://www.weatherapi.com/docs/
