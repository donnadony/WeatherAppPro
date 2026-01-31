# Temperature Units System 🌡️

## ✅ Conversión Celsius ↔ Fahrenheit Implementada

Ahora puedes cambiar entre Celsius y Fahrenheit en Settings y **todas las temperaturas se actualizan automáticamente**.

---

## 🎯 Cómo Funciona

### 1. **SettingsViewModel (Global)**

El ViewModel de Settings ahora se comparte globalmente usando `@EnvironmentObject`:

```swift
@MainActor
final class SettingsViewModel: ObservableObject {
    @Published var temperatureUnit: TemperatureUnit
    
    func convert(_ celsius: Double) -> Double {
        switch temperatureUnit {
        case .celsius:
            return celsius
        case .fahrenheit:
            return celsius * 9/5 + 32
        }
    }
}
```

### 2. **Persistencia con UserDefaults**

La selección se guarda automáticamente:

```swift
@Published var temperatureUnit: TemperatureUnit {
    didSet {
        UserDefaults.standard.set(temperatureUnit.rawValue, forKey: "temperatureUnit")
    }
}
```

### 3. **Conversión en Todas las Vistas**

Cada vista usa `settings.convert()` o `settings.format()`:

**CurrentWeatherView:**
```swift
Text(settings.format(weather.temperature))  // "43°" o "6°"
```

**HourlyForecastView:**
```swift
Text(settings.format(hour.temperature))  // Auto-convertido
```

**DailyForecastView:**
```swift
Text(settings.format(day.high))  // Auto-convertido
```

---

## 📐 Fórmula de Conversión

### Celsius → Fahrenheit:
```
°F = (°C × 9/5) + 32
```

**Ejemplos:**
- 0°C → 32°F
- 6°C → 42.8°F (muestra 43°F)
- 20°C → 68°F
- 100°C → 212°F

### Fahrenheit → Celsius:
```
°C = (°F - 32) × 5/9
```

---

## 🎛️ Uso en Settings

### Antes:
```swift
@AppStorage("temperatureUnit") private var temperatureUnit = "celsius"
```
❌ No sincronizaba con otras vistas

### Ahora:
```swift
@EnvironmentObject private var settings: SettingsViewModel

Picker("Unit", selection: $settings.temperatureUnit) {
    ForEach(TemperatureUnit.allCases, id: \.self) { unit in
        Text(unit.rawValue).tag(unit)
    }
}
```
✅ Sincroniza globalmente en **tiempo real**

---

## 🔄 Flujo de Actualización

1. **Usuario cambia a Fahrenheit** en Settings
2. **SettingsViewModel** actualiza `@Published var temperatureUnit`
3. **UserDefaults** guarda la selección
4. **Todas las vistas** se re-renderizan automáticamente
5. **Temperaturas** se muestran en Fahrenheit

**Instantáneo, sin recargar datos de la API** ✨

---

## 📋 Vistas Actualizadas

Todas estas vistas ahora soportan conversión automática:

- ✅ **CurrentWeatherView** - Temperatura principal + feels like + H/L
- ✅ **HourlyForecastView** - 24 horas de forecast
- ✅ **DailyForecastView** - 7 días de forecast
- ✅ **SettingsView** - Selector de unidades

---

## 🧪 Prueba

### Paso 1: Build & Run
```
⌘ + B
⌘ + R
```

### Paso 2: Observa las temperaturas
```
Liverpool - Celsius
6°C
Feels Like: -1°C
H:8° L:6°
```

### Paso 3: Cambia a Fahrenheit
- Tap Settings (⚙️)
- Selecciona "Fahrenheit"
- Tap Back

### Paso 4: Verifica cambio instantáneo
```
Liverpool - Fahrenheit
43°F
Feels Like: 30°F
H:46° L:43°
```

---

## 💡 Características

### ✅ Instantáneo
No recarga datos de la API, solo convierte los valores existentes

### ✅ Persistente
Tu elección se guarda en UserDefaults

### ✅ Global
Un cambio actualiza **todas las pantallas**:
- Main Weather
- Hourly Forecast
- Daily Forecast
- Search results
- Astronomy (si muestra temperatura)
- Time Zone (si muestra temperatura)
- History (si muestra temperatura)

### ✅ Reactivo
Usa Combine + SwiftUI para updates automáticos

---

## 🎨 Formato de Temperatura

### Método `format()`:
```swift
settings.format(6.5)
// Celsius: "7°"
// Fahrenheit: "43°"
```

### Método `formatWithUnit()`:
```swift
settings.formatWithUnit(6.5)
// Celsius: "7°C"
// Fahrenheit: "43°F"
```

---

## 📂 Archivos Modificados

1. ✅ `SettingsViewModel.swift` - Enum + conversión + UserDefaults
2. ✅ `SettingsView.swift` - Picker mejorado
3. ✅ `ContentView.swift` - SettingsViewModel en environment
4. ✅ `CurrentWeatherView.swift` - Usa conversión
5. ✅ `HourlyForecastView.swift` - Usa conversión
6. ✅ `DailyForecastView.swift` - Usa conversión

---

## ✨ Resultado

**Ahora tienes un sistema completo de unidades de temperatura:**
- 🌡️ Celsius / Fahrenheit
- 💾 Persistente
- ⚡ Instantáneo
- 🌐 Global
- ✅ Reactivo

**Cambia una vez en Settings, se actualiza en TODAS partes** 🎯
