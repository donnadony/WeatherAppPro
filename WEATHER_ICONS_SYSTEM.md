# Weather Icons System 🌤️

## ✅ Sistema de Íconos Automáticos

Ahora **todos los íconos se generan automáticamente** según la condición real del clima de la API.

---

## 🎯 WeatherIconMapper

### Archivo: `Core/Helpers/WeatherIconMapper.swift`

Mapea condiciones de texto → SF Symbols icons

### Condiciones Soportadas:

| Condición API | SF Symbol Icon | Visual |
|---------------|----------------|--------|
| **Clear / Sunny** | `sun.max.fill` | ☀️ |
| **Partly Cloudy** | `cloud.sun.fill` | ⛅ |
| **Cloudy / Overcast** | `cloud.fill` | ☁️ |
| **Light Rain / Patchy Rain** | `cloud.drizzle.fill` | 🌦️ |
| **Rain / Shower** | `cloud.rain.fill` | 🌧️ |
| **Heavy Rain** | `cloud.heavyrain.fill` | ⛈️ |
| **Snow** | `cloud.snow.fill` | ❄️ |
| **Heavy Snow** | `cloud.snow.fill` | 🌨️ |
| **Thunder / Storm** | `cloud.bolt.rain.fill` | ⚡ |
| **Mist / Fog / Haze** | `cloud.fog.fill` | 🌫️ |
| **Wind** | `wind` | 💨 |

---

## 🔄 Uso en el Proyecto

### 1. **WeatherService.swift**
Genera íconos al convertir datos de la API:

```swift
let hourlyForecast = response.forecast?.forecastday.first?.hour.map { hour in
    HourlyWeather(
        hour: formatHour(hour.time),
        temperature: hour.temp_c,
        condition: hour.condition.text,
        icon: WeatherIconMapper.icon(for: hour.condition.text) // ✅ Automático
    )
}
```

### 2. **CurrentWeatherView.swift**
Usa el mapper para el ícono principal:

```swift
private var weatherIcon: String {
    WeatherIconMapper.icon(for: weather.condition)
}
```

### 3. **Mock Data (WeatherViewModel.swift)**
Incluso los datos de prueba usan el mapper:

```swift
let condition = ["Sunny", "Cloudy", "Light rain"].randomElement()!
return HourlyWeather(
    hour: "\(hour):00",
    temperature: Double.random(in: 18...28),
    condition: condition,
    icon: WeatherIconMapper.icon(for: condition) // ✅ Automático
)
```

---

## 🌙 Variaciones Día/Noche (Bonus)

El mapper incluye soporte para íconos nocturnos:

```swift
WeatherIconMapper.icon(for: "Clear", isNight: true) 
// → "moon.stars.fill" 🌙

WeatherIconMapper.icon(for: "Partly Cloudy", isNight: true) 
// → "cloud.moon.fill" 🌙☁️
```

**Nota:** Actualmente no implementado en vistas, pero disponible para uso futuro.

---

## 📋 Ejemplo con Datos Reales

### API devuelve:
```json
{
  "condition": {
    "text": "Patchy rain possible"
  }
}
```

### WeatherIconMapper procesa:
```swift
"Patchy rain possible" 
  .lowercased()           // "patchy rain possible"
  .contains("rain")       // ✅ true
  → "cloud.drizzle.fill"  // 🌦️
```

### Resultado en UI:
- **Hourly:** 🌦️ `cloud.drizzle.fill`
- **Daily:** 🌦️ `cloud.drizzle.fill`
- **Current:** 🌦️ `cloud.drizzle.fill`

---

## ✅ Ventajas del Sistema

1. **Consistencia** - Mismo ícono para misma condición en toda la app
2. **Automático** - No necesitas actualizar manualmente
3. **Extensible** - Fácil agregar nuevas condiciones
4. **Preciso** - Refleja condiciones reales de la API
5. **Mantenible** - Un solo archivo controla todos los íconos

---

## 🧪 Condiciones de WeatherAPI.com

La API puede devolver condiciones como:

- "Clear"
- "Sunny"
- "Partly cloudy"
- "Cloudy"
- "Overcast"
- "Mist"
- "Patchy rain possible"
- "Light rain"
- "Moderate rain at times"
- "Heavy rain"
- "Light snow"
- "Heavy snow"
- "Blizzard"
- "Thundery outbreaks possible"
- "Patchy light drizzle"
- "Freezing fog"
- Y muchas más...

**Todas están cubiertas** con matching inteligente usando `.contains()`

---

## 📂 Archivos Actualizados

1. ✅ `Core/Helpers/WeatherIconMapper.swift` - **NUEVO**
2. ✅ `Core/Network/WeatherService.swift` - Usa mapper
3. ✅ `Features/Weather/Views/CurrentWeatherView.swift` - Usa mapper
4. ✅ `Features/Weather/ViewModels/WeatherViewModel.swift` - Mock data usa mapper

---

## 🎨 Ejemplo Visual

**Liverpool - Light rain:**
```
CurrentWeather: 🌧️ (cloud.rain.fill)

Hourly:
Now   5AM   6AM   7AM
🌧️    🌧️    🌧️    ⛅

Daily:
Today  🌧️  90%  ▬▬▬  8°
Sun    🌧️  85%  ▬▬▬  8°
Mon    ☁️       ▬▬▬  7°
```

**Miami - Sunny:**
```
CurrentWeather: ☀️ (sun.max.fill)

Hourly:
Now   1PM   2PM   3PM
☀️    ☀️    ☀️    ⛅

Daily:
Today  ☀️      ▬▬▬  28°
Sun    ☀️      ▬▬▬  30°
Mon    ⛅      ▬▬▬  29°
```

---

**Build & Run para ver íconos automáticos basados en clima real** 🚀
