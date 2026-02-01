#!/bin/bash

echo "=========================================="
echo "DIEP-W Flutter - Quick Start"
echo "=========================================="
echo ""
echo "This will set up and build your DIEP-W app"
echo ""

# Check if Flutter exists
if [ -d "$HOME/flutter" ]; then
    echo "✅ Flutter SDK found at $HOME/flutter"
    export PATH="$PATH:$HOME/flutter/bin"
else
    echo "❌ Flutter SDK not found"
    echo ""
    echo "Would you like to download Flutter now? (y/n)"
    read -r response
    if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
        echo "Downloading Flutter..."
        cd "$HOME"
        curl -O https://storage.googleapis.com/flutter_infra_release/releases/stable/macos/flutter_macos_arm64_3.24.5-stable.zip
        unzip -q flutter_macos_arm64_3.24.5-stable.zip
        rm flutter_macos_arm64_3.24.5-stable.zip
        export PATH="$PATH:$HOME/flutter/bin"
        echo "✅ Flutter installed!"
    else
        echo "Please install Flutter manually from: https://flutter.dev"
        exit 1
    fi
fi

echo ""
echo "Setting up project..."
cd "$(dirname "$0")"

flutter pub get

echo ""
echo "=========================================="
echo "Setup complete! 🎉"
echo "=========================================="
echo ""
echo "What would you like to do?"
echo ""
echo "1) Build APK now"
echo "2) Open in VS Code"
echo "3) Show project info"
echo "4) Exit"
echo ""
read -p "Enter choice [1-4]: " choice

case $choice in
    1)
        ./build.sh
        ;;
    2)
        code .
        echo "Opening in VS Code..."
        ;;
    3)
        echo ""
        echo "Project: DIEP-W Flutter"
        echo "Location: $(pwd)"
        echo ""
        echo "To build:"
        echo "  ./build.sh"
        echo ""
        echo "To run:"
        echo "  flutter run"
        echo ""
        echo "Documentation:"
        echo "  README.md - Full documentation"
        echo "  SETUP.md - Setup instructions"
        echo "  DEPLOYMENT.md - Deployment guide"
        ;;
    4)
        echo "Goodbye!"
        exit 0
        ;;
esac
