# Setup Instructions

## Prerequisites

1. **Flutter SDK** installed and configured
2. **Android Studio** (for Android builds)
3. **Xcode** (for iOS builds - macOS only)

## Install Flutter

### macOS

Download and install Flutter:

```bash
# Download from official site
curl -O https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/flutter_macos_arm64_3.24.5-stable.zip
unzip flutter_macos_arm64_3.24.5-stable.zip
rm flutter_macos_arm64_3.24.5-stable.zip
```

Add Flutter to your PATH by adding this to your `~/.zshrc` or `~/.bash_profile`:

```bash
export PATH="$PATH:$HOME/flutter/bin"
```

Reload your shell:
```bash
source ~/.zshrc  # or source ~/.bash_profile
```

Verify installation:
```bash
flutter doctor
```

### Alternative: Install via Homebrew

```bash
brew install --cask flutter
```

## Install Android Studio

1. Download from: https://developer.android.com/studio
2. Install Android SDK and Android SDK Command-line Tools
3. Accept Android licenses:
   ```bash
   flutter doctor --android-licenses
   ```

## Setup the Project

Get dependencies:
```bash
flutter pub get
```

## Build Options

### Debug APK
```bash
flutter build apk --debug
```

### Release APK
```bash
flutter build apk --release
```

### App Bundle (for Play Store)
```bash
flutter build appbundle --release
```

### Web Build
```bash
flutter build web --release --web-renderer canvaskit
```

## Install on Device

### Via USB
```bash
flutter install
```

### Manual Installation
1. Enable "Unknown sources" on your Android device
2. Transfer the APK file from `build/app/outputs/flutter-apk/`
3. Open the APK on your device to install

## Troubleshooting

### "Flutter SDK not found"
Make sure Flutter is in your PATH and run:
```bash
flutter doctor -v
```

### "Android SDK not found"
Install Android Studio and set up Android SDK, then:
```bash
flutter config --android-sdk /path/to/android/sdk
```

### "No devices found"
- For emulator: Launch Android emulator from Android Studio
- For physical device: Enable USB debugging in Developer Options

### Build Errors
Clean and rebuild:
```bash
flutter clean
flutter pub get
flutter build apk --release
```

## Resources

- Flutter documentation: https://flutter.dev/docs
- Flutter community: https://flutter.dev/community
