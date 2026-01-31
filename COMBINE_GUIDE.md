# Combine Import Guide - CORREGIDO

## ✅ SIEMPRE importa Combine con ObservableObject

`ObservableObject` y `@Published` **pertenecen al framework Combine**, no a SwiftUI.

Aunque SwiftUI re-exporta estos tipos por conveniencia, la **best practice** es importar explícitamente Combine.

### ✅ Correcto:

```swift
import Foundation
import Combine  // ✅ SIEMPRE con ObservableObject

@MainActor
final class MyViewModel: ObservableObject {
    @Published var data: String = ""
    @Published var isLoading = false
}
```

### ❌ Incorrecto (aunque compile):

```swift
import SwiftUI  // ❌ Solo funciona porque SwiftUI re-exporta Combine

class MyViewModel: ObservableObject {
    @Published var data: String = ""
}
```

---

## 📋 Imports estándar para ViewModels

```swift
import Foundation  // Para tipos básicos (String, Date, etc.)
import Combine     // Para ObservableObject, @Published
```

Si necesitas SwiftUI en el ViewModel (raro):
```swift
import Foundation
import SwiftUI
import Combine
```

---

## 🎯 WeatherAppPro - Todos los ViewModels

**Todos** tienen ahora:
```swift
import Foundation
import Combine
```

- ✅ `AstronomyViewModel.swift`
- ✅ `TimeZoneViewModel.swift`
- ✅ `HistoryViewModel.swift`
- ✅ `SettingsViewModel.swift`
- ✅ `WeatherViewModel.swift`
- ✅ `SearchViewModel.swift`
- ✅ `Router.swift`

---

## 📚 Razón Técnica

`ObservableObject` está definido en:
```
Combine.framework/ObservableObject
```

SwiftUI simplemente hace `@_exported import Combine` internamente, por eso funciona sin importarlo explícitamente.

**Pero la best practice es ser explícito** y declarar todas tus dependencias.

---

## ✅ Resumen

**Regla simple:**

**¿Usas `ObservableObject` o `@Published`?**
→ **SIEMPRE `import Combine`**

Gracias por la corrección. 🙏
