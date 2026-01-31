# Weather API Setup

## Get Your Free API Key

1. Go to: https://www.weatherapi.com/signup.aspx
2. Sign up (free account)
3. Copy your API Key from dashboard

## Configure the App

Open `APIConfig.swift` and replace:

```swift
static let weatherAPIKey = "YOUR_API_KEY_HERE"
```

With your actual key:

```swift
static let weatherAPIKey = "abc123def456"
```

## That's It!

The app will now fetch **real weather data** for Lima, Peru (or any location you set).

## Features Enabled

- ✅ Current temperature
- ✅ Feels like, humidity, wind
- ✅ 24-hour forecast
- ✅ 7-day forecast
- ✅ Real weather conditions
- ✅ Accurate icons

## Free Tier Limits

- 1,000,000 API calls per month
- More than enough for development & testing

## Fallback

If API key is invalid or network fails, the app shows mock data automatically (no crashes).
