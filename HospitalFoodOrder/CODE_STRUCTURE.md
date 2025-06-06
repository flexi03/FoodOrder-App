# Verbesserte Code-Struktur 📁

## 📂 Neue Verzeichnisstruktur

```
HospitalFoodOrder/
├── Views/
│   ├── Screens/           # Hauptbildschirme der App
│   │   ├── ContentView.swift
│   │   ├── iPadContentView.swift
│   │   ├── InfoView.swift
│   │   └── SplashView.swift
│   └── Components/        # Wiederverwendbare UI-Komponenten
│       └── NavigationBarViews/
├── Models/
│   ├── Data/             # Datenmodelle
│   │   └── SettingsModel.swift
│   └── UI/               # UI-bezogene Modelle
│       ├── ColorSchemeModel.swift
│       └── TabPosition.swift
├── Components/
│   ├── Animations/       # Animationskomponenten
│   │   ├── LottieView.swift
│   │   └── LottieAnimationView2.swift
│   ├── UI/              # Allgemeine UI-Komponenten
│   │   ├── CustomTabBar2.swift
│   │   ├── TabShape.swift
│   │   └── AnimatedColorWheelOverlay.swift
│   └── Navigation/      # Navigationskomponenten
│       └── Tabs.swift
└── Utils/               # Hilfsfunktionen und Utilities
```

## 🔄 Umstrukturierungsplan

### 1. Views-Ordner
- **Screens/**: Hauptbildschirme der App
  - Alle Hauptansichten hierher verschieben
  - ViewModels in separaten Dateien
  - Klare Trennung zwischen iPhone und iPad Views

- **Components/**: Wiederverwendbare Komponenten
  - NavigationBarViews bleibt als Unterordner
  - Neue Komponenten hier hinzufügen

### 2. Models-Ordner
- **Data/**: Datenmodelle
  - SettingsModel.swift hierher verschieben
  - Neue Datenmodelle hier hinzufügen

- **UI/**: UI-bezogene Modelle
  - ColorSchemeModel.swift
  - TabPosition.swift
  - Weitere UI-Modelle

### 3. Components-Ordner
- **Animations/**: Animationskomponenten
  - Lottie-bezogene Dateien
  - Weitere Animationen

- **UI/**: Allgemeine UI-Komponenten
  - CustomTabBar2.swift
  - TabShape.swift
  - AnimatedColorWheelOverlay.swift

- **Navigation/**: Navigationskomponenten
  - Tabs.swift
  - Weitere Navigationskomponenten

### 4. Utils-Ordner
- Hilfsfunktionen
- Erweiterungen
- Konstanten
- Typdefinitionen

## 📝 Best Practices

### Code-Organisation
1. **MVVM-Pattern**
   - Views in Views/
   - ViewModels in Models/
   - Klare Trennung von UI und Logik

2. **Dateinamen**
   - Konsistente Benennung
   - Klare Unterscheidung zwischen Views und ViewModels
   - Präfixe für spezielle Komponenten

3. **Komponenten**
   - Wiederverwendbare Komponenten in Components/
   - Klare Dokumentation
   - Einheitliche Schnittstellen

### Datenschutz
1. **Lokale Datenspeicherung**
   - Core Data für persistente Daten
   - UserDefaults für Einstellungen
   - Keine Cloud-Synchronisation

2. **Datenbereinigung**
   - Automatische Bereinigung alter Daten
   - Temporäre Speicherung
   - DSGVO-Konformität

### Geräteunterstützung
1. **iPhone**
   - Optimierte Layouts
   - Dynamic Island Integration
   - Touch-freundliche UI

2. **iPad**
   - Dedizierte Layouts
   - Split-View Unterstützung
   - Optimierte Navigation

## 🚀 Nächste Schritte

1. Dateien in neue Struktur verschieben
2. Code-Review durchführen
3. Dokumentation aktualisieren
4. Tests anpassen
5. Performance optimieren 