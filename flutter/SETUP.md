# DIEP-W Flutter - Setup Instructions

## Prerequisites

Before building the app, you need:

1. **Flutter SDK** installed and configured
2. **Android Studio** (for Android builds)
3. **Xcode** (for iOS builds - macOS only)

## Step 1: Install Flutter

### macOS

Download and install Flutter:

```bash
# Option 1: Direct download
cd ~
curl -O https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/flutter_macos_arm64_3.24.5-stable.zip
unzip flutter_macos_arm64_3.24.5-stable.zip
rm flutter_macos_arm64_3.24.5-stable.zip
```

Add Flutter to your PATH by adding this to your `~/.zshrc` or `~/.bash_profile`:

```bash
export PATH="$PATH:$HOME/flutter/bin"
```

Then reload your shell:
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

## Step 2: Install Android Studio

1. Download from: https://developer.android.com/studio
2. Install Android SDK and Android SDK Command-line Tools
3. Accept Android licenses:
   ```bash
   flutter doctor --android-licenses
   ```

## Step 3: Setup the Project

Navigate to the project directory:
```bash
cd diep_w_flutter
```

Get dependencies:
```bash
flutter pub get
```

## Step 4: Build the APK

### Option A: Use the build script (recommended)

```bash
./build.sh
```

Then choose option 2 for release APK or option 1 for debug APK.

### Option B: Manual build commands

**Debug APK:**
```bash
flutter build apk --debug
```

**Release APK:**
```bash
flutter build apk --release
```

**App Bundle (for Play Store):**
```bash
flutter build appbundle --release
```

## Step 5: Install on Device

### Via USB:
```bash
flutter install
```

### Manual installation:
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

### Build errors
Clean and rebuild:
```bash
flutter clean
flutter pub get
flutter build apk --release
```

## Next Steps

After successful build:

1. **Test the app** on a device or emulator
2. **Distribute the APK** to users or upload to Play Store
3. **Sign the app** for production release (see Flutter documentation)

## Support

For Flutter-specific issues, see:
- Flutter documentation: https://flutter.dev/docs
- Flutter community: https://flutter.dev/community

For app-specific issues, refer to the medical publication cited in README.md
