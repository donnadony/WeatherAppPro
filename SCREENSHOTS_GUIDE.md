# Screenshots & Video Guide 📸

## Carpeta de Screenshots

Crea esta estructura de carpetas:

```
WeatherAppPro/
└── screenshots/
    ├── weather.png
    ├── hourly.png
    ├── daily.png
    ├── search.png
    ├── astronomy.png
    ├── timezone.png
    ├── history.png
    ├── settings.png
    ├── demo.mp4 (o .gif)
    └── app-icon.png (opcional)
```

---

## 📱 Screenshots Necesarios

### 1. **weather.png** - Pantalla Principal
Captura la vista principal con:
- Ciudad (ej: Liverpool)
- Temperatura grande
- Feels Like + H/L
- Descripción del clima

**Sugerencia:** Captura cuando muestre datos reales (no loading)

---

### 2. **hourly.png** - Forecast por Hora
Captura mostrando:
- Header "NOW"
- Scroll horizontal con íconos
- Temperaturas por hora
- Al menos 6-7 horas visibles

---

### 3. **daily.png** - Forecast 7 Días
Captura mostrando:
- Header "7-DAY FORECAST"
- Lista de días (Today, Sun, Mon...)
- Íconos del clima
- Porcentajes de lluvia (si aplica)
- Barras de temperatura
- High/Low visibles

---

### 4. **search.png** - Búsqueda de Ciudades
Captura mostrando:
- Campo de búsqueda con texto (ej: "New York")
- Lista de resultados
- Al menos 3-4 ciudades visibles
- Liquid Glass cards

---

### 5. **astronomy.png** - Datos Astronómicos
Captura mostrando:
- Card del Sol (Sunrise/Sunset)
- Card de la Luna (Moonrise/Moonset)
- Fase lunar visible
- Porcentaje de iluminación

---

### 6. **timezone.png** - Zona Horaria
Captura mostrando:
- Ícono de reloj grande
- Ciudad y país
- Hora local
- Nombre de la zona horaria

---

### 7. **history.png** - Clima Histórico
Captura mostrando:
- Date picker (calendario)
- Card con datos históricos
- Temperatura promedio
- High/Low
- Viento y humedad

---

### 8. **settings.png** - Configuración
Captura mostrando:
- Selector de unidades (Celsius/Fahrenheit)
- Card "About"
- Liquid Glass design

---

## 🎥 Video Demo

### Duración: 30-60 segundos

**Flujo sugerido:**
1. **Inicio** - Mostrar pantalla principal (3s)
2. **Pull to refresh** - Jalar para actualizar (2s)
3. **Scroll** - Bajar para ver hourly/daily (5s)
4. **Tap Search** - Abrir búsqueda (2s)
5. **Escribir ciudad** - Ej: "Tokyo" (3s)
6. **Seleccionar** - Tap en resultado (2s)
7. **Ver cambio** - Clima actualizado (3s)
8. **More Info** - Tap en Astronomy (2s)
9. **Ver astronomy** - Datos sol/luna (4s)
10. **Settings** - Cambiar a Fahrenheit (3s)
11. **Ver cambio** - Temperaturas convertidas (3s)
12. **Final** - Volver a home (2s)

**Total:** ~34 segundos

---

## 📐 Especificaciones Técnicas

### Screenshots
- **Dispositivo:** iPhone 15 Pro (simulador)
- **Orientación:** Portrait (vertical)
- **Formato:** PNG (mejor calidad)
- **Resolución:** Native (1179 × 2556 para iPhone 15 Pro)
- **Tamaño:** Sin escalar (100%)

### Video
- **Formato:** MP4 o GIF
- **Resolución:** 1080p (1920×1080) o nativa
- **Frame rate:** 30 FPS
- **Duración:** 30-60 segundos
- **Tamaño:** < 10 MB (para GitHub)

**Alternativa GIF:**
- Usar [ezgif.com](https://ezgif.com/video-to-gif) para convertir
- Max 15 FPS para reducir tamaño
- 600px de ancho (escalado)

---

## 🎬 Cómo Capturar en Xcode

### Screenshots

1. **Ejecuta la app** en simulador
2. **Navega** a la pantalla que quieres capturar
3. Presiona **⌘ + S** (o File → New Screen Shot)
4. Se guarda en el escritorio automáticamente

**O desde el simulador:**
- Device → Trigger Screenshot
- Se guarda en Desktop

### Video

**Opción 1: QuickTime**
1. Abre **QuickTime Player**
2. File → **New Screen Recording**
3. Click en **flecha** → selecciona iPhone simulator
4. Click **grabar**
5. Stop cuando termines
6. File → Save

**Opción 2: Xcode (solo debugging)**
1. Window → Devices and Simulators
2. Selecciona tu simulador
3. Click el botón de **record**

**Opción 3: xcrun (Terminal)**
```bash
xcrun simctl io booted recordVideo demo.mp4
# Presiona Ctrl+C para detener
```

---

## 📤 Envío de Archivos

### Método 1: Telegram (recomendado)
- Envía las fotos directamente al chat
- Envía el video (MP4 < 50 MB)
- Yo las organizo y las agrego al README

### Método 2: GitHub
1. Sube a un nuevo issue en tu repo
2. Arrastra las imágenes/video
3. Copia los URLs generados
4. Los agrego al README

### Método 3: Cloud Storage
- Sube a Google Drive / Dropbox
- Comparte el link
- Yo las descargo y organizo

---

## ✅ Checklist

Antes de enviar, verifica:

- [ ] 8 screenshots en PNG
- [ ] Todas las capturas son del mismo dispositivo
- [ ] Screenshots muestran contenido real (no "Loading...")
- [ ] Video muestra flujo completo (30-60s)
- [ ] Video tiene buena calidad
- [ ] Archivos tienen nombres descriptivos

---

## 💡 Tips

### Para Screenshots
- ✅ Usa **modo claro** (no dark mode)
- ✅ Captura con **datos reales** de la API
- ✅ Elige ciudades con **clima interesante** (lluvia, sol, etc.)
- ✅ Asegúrate que el **glassmorphism se vea bien**

### Para Video
- ✅ **Velocidad natural** (no muy rápido)
- ✅ **Muestra interacciones** (taps, scroll)
- ✅ **Espera las animaciones** (no cortes abruptos)
- ✅ **Sin audio** está bien

---

**Listo para enviar:** Envíame las fotos/video por Telegram y yo las integro al README perfectamente 🎯
