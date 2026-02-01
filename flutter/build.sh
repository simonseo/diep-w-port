#!/bin/bash

# DIEP-W Flutter Build Script
# This script helps you build the DIEP-W app for different platforms

set -e

echo "======================================"
echo "DIEP-W Flutter Build Script"
echo "======================================"
echo ""

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "Error: Flutter is not installed or not in PATH"
    echo "Please install Flutter from: https://flutter.dev/docs/get-started/install"
    echo ""
    echo "For macOS:"
    echo "  1. Download from https://flutter.dev"
    echo "  2. Extract to ~/flutter"
    echo "  3. Add to PATH: export PATH=\"\$PATH:\$HOME/flutter/bin\""
    exit 1
fi

echo "Flutter version:"
flutter --version
echo ""

# Get dependencies
echo "Installing dependencies..."
flutter pub get
echo ""

# Run Flutter doctor
echo "Checking Flutter setup..."
flutter doctor
echo ""

# Ask what to build
echo "What would you like to build?"
echo "1) Debug APK (for testing)"
echo "2) Release APK (for distribution)"
echo "3) App Bundle (for Google Play Store)"
echo "4) Run on connected device"
echo "5) Exit"
echo ""
read -p "Enter choice [1-5]: " choice

case $choice in
    1)
        echo "Building debug APK..."
        flutter build apk --debug
        echo ""
        echo "✅ Debug APK created at: build/app/outputs/flutter-apk/app-debug.apk"
        ;;
    2)
        echo "Building release APK..."
        flutter build apk --release
        echo ""
        echo "✅ Release APK created at: build/app/outputs/flutter-apk/app-release.apk"
        echo ""
        echo "You can now install this APK on Android devices."
        ;;
    3)
        echo "Building app bundle..."
        flutter build appbundle --release
        echo ""
        echo "✅ App bundle created at: build/app/outputs/bundle/release/app-release.aab"
        echo ""
        echo "Upload this to Google Play Console for distribution."
        ;;
    4)
        echo "Available devices:"
        flutter devices
        echo ""
        echo "Running app..."
        flutter run
        ;;
    5)
        echo "Exiting..."
        exit 0
        ;;
    *)
        echo "Invalid choice. Exiting..."
        exit 1
        ;;
esac

echo ""
echo "======================================"
echo "Build completed successfully!"
echo "======================================"
