# Technical Documentation

## Project Overview

Flutter-based cross-platform application for DIEP flap weight estimation in breast reconstruction surgery.

## Technology Stack

- **Framework:** Flutter 3.x
- **Language:** Dart
- **UI:** Material Design 3
- **State Management:** Provider
- **Storage:** SharedPreferences (mobile), localStorage (web)
- **Web Renderer:** CanvasKit

## Project Structure

```
flutter/
├── lib/
│   ├── main.dart                          # App entry & navigation
│   ├── screens/
│   │   ├── pinch_screen.dart             # Pinch calculator
│   │   ├── ct_screen.dart                # CT calculator
│   │   ├── bmi_screen.dart               # BMI calculator
│   │   ├── history_screen.dart           # Calculation history
│   │   └── about_screen.dart             # Credits & info
│   ├── widgets/
│   │   ├── bmi_calculator_dialog.dart    # BMI calculator dialog
│   │   ├── measurement_input.dart        # Reusable input widget
│   │   └── info_dialog.dart              # Info tooltips
│   ├── services/
│   │   └── calculation_history_service.dart  # History persistence
│   └── models/
│       └── calculation_result.dart       # Data models
├── assets/
│   └── images/                           # App icons and images
├── web/
│   ├── index.html                        # Web entry point
│   ├── manifest.json                     # PWA manifest
│   └── icons/                            # PWA icons
├── android/                              # Android configuration
├── ios/                                  # iOS configuration
└── pubspec.yaml                          # Dependencies
```

## Core Features

### Calculation Methods

**Pinch Method:**
```dart
Weight (g) = -1308 + 24.57×BMI + 6.8×(R+L)/2 + 7.89×I + 20.51×H + 32.55×W
```

**CT Method:**
```dart
Weight (g) = -435 + 11.61×BMI - 23.23×(R+L)/2 + 8.74×I + 37.72×H - 4.63×W + 1.0884×(R+L)/2×W
```

### Data Persistence

- **Web:** Uses `dart:html` localStorage directly
- **Mobile:** Uses SharedPreferences plugin
- **Format:** JSON serialization for calculation history

### Web-Specific Implementation

The app includes a web-specific workaround for SharedPreferences plugin issues on Flutter web:

```dart
if (kIsWeb) {
  // Use localStorage directly
  html.window.localStorage['key'] = jsonEncode(data);
} else {
  // Use SharedPreferences plugin
  await prefs.setString('key', jsonEncode(data));
}
```

This ensures calculation history persists correctly across all platforms.

## Build Configuration

### Web Build

```bash
flutter build web --release --web-renderer canvaskit --base-href /diep-w-port/
```

**Base HREF:** Required for GitHub Pages deployment at subpath.

### Android Build

```bash
flutter build apk --release
```

### iOS Build

```bash
flutter build ios --release
```

## Dependencies

Key packages used:
- `shared_preferences` - Local storage (mobile)
- `provider` - State management
- `intl` - Number formatting

See `pubspec.yaml` for complete list.

## Medical Formula Implementation

All calculations implement peer-reviewed formulas exactly as published:

**Citation:** Woo KJ, Kim EJ, Lee KT, Mun GH. "A Novel Method to Estimate the Weight of the DIEP Flap in Breast Reconstruction." *J Reconstr Microsurg*. 2016 Sep;32(7):520-7. PMID: 27050336

Mean absolute percentage error: 7.7% (as per original research)

## Platform Support

- **Web:** Chrome, Safari, Firefox, Edge (PWA installable)
- **Android:** API 21+ (Android 5.0 Lollipop)
- **iOS:** iOS 11.0+

## Known Issues & Solutions

### Issue: SharedPreferences MissingPluginException on Web
**Solution:** Direct localStorage usage for web platform (see `calculation_history_service.dart`)

### Issue: Asset loading 404 on GitHub Pages
**Solution:** Use `--base-href` flag during build to set correct base path

## Future Enhancements

Potential improvements:
- Multi-language support
- PDF export of results
- Cloud sync for calculation history
- Statistical analysis dashboard
