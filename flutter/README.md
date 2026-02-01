# DIEP-W Flutter App

DIEP (Deep Inferior Epigastric Artery Perforator) flap weight estimation calculator for breast reconstruction surgery.

## Live Demo

**[https://simonseo.github.io/diep-w-port/](https://simonseo.github.io/diep-w-port/)**

Available as a Progressive Web App (PWA) - install directly from your browser.

## About

This app helps surgeons estimate DIEP flap weight before breast reconstruction surgery using three methods:

- **Pinch Method** - Manual tissue measurements
- **CT Method** - CT scan measurements
- **BMI Calculator** - Body mass index calculation tool

Based on peer-reviewed research: [Woo et al., 2016](https://pubmed.ncbi.nlm.nih.gov/27050336/)

## Quick Start

### Use the Web App

Visit: **[https://simonseo.github.io/diep-w-port/](https://simonseo.github.io/diep-w-port/)**

### Build for Mobile

#### Prerequisites

- Flutter SDK installed
- Android Studio (for Android builds)
- Xcode (for iOS builds - macOS only)

See [SETUP.md](SETUP.md) for detailed installation instructions.

#### Build Android APK

```bash
flutter pub get
flutter build apk --release
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

#### Build for Web

```bash
flutter build web --release --web-renderer canvaskit --base-href /diep-w-port/
```

#### Run on Device

```bash
flutter run
```

## How to Use

1. Select **Pinch** or **CT** tab
2. Enter measurements:
   - BMI (or use built-in calculator)
   - R, L, I (thickness in mm)
   - H, W (dimensions in cm)
3. Tap **Calculate**
4. View estimated flap weight in grams

## Medical Formulas

### Pinch Method
```
Weight (g) = -1308 + 24.57×BMI + 6.8×(R+L)/2 + 7.89×I + 20.51×H + 32.55×W
```

### CT Method
```
Weight (g) = -435 + 11.61×BMI - 23.23×(R+L)/2 + 8.74×I + 37.72×H - 4.63×W + 1.0884×(R+L)/2×W
```

**Where:**
- BMI = Body Mass Index
- R, L, I = Thickness measurements (mm) at 5cm right, left, inferior from umbilicus
- H = Flap height (cm)
- W = Flap width (cm)

## Documentation

- [SETUP.md](SETUP.md) - Installation and setup instructions
- [DEPLOYMENT.md](DEPLOYMENT.md) - Deployment guide for GitHub Pages
- [TECHNICAL.md](TECHNICAL.md) - Technical implementation details

## Disclaimer

This app is for **qualified medical professionals only**. Use clinical judgment and verify all measurements. Not a substitute for professional medical advice.

## Credits

**Original Research:**
- Kyongje Woo, MD, PhD
- Goohyun Mun, MD

*Department of Plastic Surgery, Samsung Medical Center*

**Citation:** 

Woo KJ, Kim EJ, Lee KT, Mun GH. "A Novel Method to Estimate the Weight of the DIEP Flap in Breast Reconstruction: DIEP-W, a Simple Calculation Formula Using Paraumbilical Flap Thickness." *Journal of Reconstructive Microsurgery*. 2016 Sep;32(7):520-7. PMID: 27050336

## License

MIT License - For educational and clinical use.
