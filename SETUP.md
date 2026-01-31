# Setup Instructions 🚀

## Quick Start (5 minutes)

### Step 1: Open Project
1. Open `WeatherAppPro.xcodeproj` in Xcode

### Step 2: Clean Up Template Files
1. In Xcode Project Navigator, select `Item.swift`
2. Right-click → Delete → Move to Trash

### Step 3: Add New Files to Project
1. In Finder, navigate to:
   ```
   /Users/dony/Documents/Personal/WeatherAppPro/WeatherAppPro/WeatherAppPro/
   ```

2. Drag these folders into Xcode (into WeatherAppPro group):
   - `Core/`
   - `Features/`
   - `Extensions/`

3. When prompted:
   - ✅ **Copy items if needed**: NO (already in correct location)
   - ✅ **Create groups**: YES
   - ✅ **Add to targets**: WeatherAppPro

### Step 4: Verify Files
Your Xcode Project Navigator should now show:
```
WeatherAppPro/
├── WeatherAppProApp.swift
├── ContentView.swift
├── Core/
│   ├── Router/
│   ├── Network/
│   ├── Persistence/
│   └── Theme/
├── Features/
│   ├── Weather/
│   ├── Search/
│   └── Settings/
└── Extensions/
```

### Step 5: Configure Weather API
1. Go to https://www.weatherapi.com/signup.aspx
2. Create free account and copy your API Key
3. Open `Core/Network/APIConfig.swift`
4. Replace `"YOUR_API_KEY_HERE"` with your actual key:
   ```swift
   static let weatherAPIKey = "your_actual_key_here"
   ```

### Step 6: Build & Run
1. Select a simulator (iPhone 15 Pro recommended)
2. Press `⌘ + B` to build
3. Press `⌘ + R` to run

---

## Expected Result

You should see:
- ✅ App launches
- ✅ Weather screen with liquid glass cards
- ✅ Beautiful gradient background
- ✅ Mock weather data displayed
- ✅ Settings button in toolbar works

---

## Next Steps (Optional)

### Enable Real Weather Data
1. Get Apple Developer account
2. In Xcode: Signing & Capabilities → Add "WeatherKit"
3. Update `WeatherService.swift` with real WeatherKit implementation

### Add Widgets
1. File → New → Target → Widget Extension
2. Use liquid glass styling from `LiquidGlassCard`

---

## Troubleshooting

### Build Errors?
- Make sure all folders are added as **groups** (not folder references)
- Check that files are added to **WeatherAppPro target**
- Clean Build Folder: `⌘ + Shift + K`

### Files Not Showing?
- They're already in the correct location
- Just drag from Finder into Xcode
- Don't copy, just create groups

---

## File Structure Created

Total files created: **25**

### Core (10 files)
- Router/Router.swift
- Router/Route.swift
- Network/WeatherService.swift
- Network/WeatherServiceProtocol.swift
- Persistence/CoreDataManager.swift
- Theme/LiquidGlassCard.swift
- Theme/LiquidGlassModifier.swift
- Theme/AppTheme.swift

### Extensions (2 files)
- Color+Extensions.swift
- View+Extensions.swift

### Features (13 files)
Weather:
- Views/WeatherView.swift
- Views/CurrentWeatherView.swift
- Views/HourlyForecastView.swift
- Views/DailyForecastView.swift
- ViewModels/WeatherViewModel.swift
- Models/WeatherData.swift
- Models/Location.swift

Search:
- Views/SearchView.swift
- ViewModels/SearchViewModel.swift

Settings:
- Views/SettingsView.swift
- ViewModels/SettingsViewModel.swift

---

**Ready to showcase! 🎉**
