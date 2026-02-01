# DIEP-W

**Estimate the Weight of the DIEP Flap in Breast Reconstruction**

A mobile application for calculating DIEP (Deep Inferior Epigastric Artery Perforator) flap weight using validated medical formulas.

## 📱 About

This app helps surgeons estimate DIEP flap weight before breast reconstruction surgery using two methods:

- **Pinch Method** - Manual measurements
- **CT Method** - CT scan measurements

Based on peer-reviewed research: [Woo et al., 2016](https://pubmed.ncbi.nlm.nih.gov/27050336/)

## 🚀 Quick Start

### Install Flutter

```bash
# Download Flutter (choose your platform)
# macOS: https://docs.flutter.dev/get-started/install/macos
# Or use Homebrew:
brew install --cask flutter
```

### Build the App

```bash
cd flutter
flutter pub get
flutter build apk --release
```

Your APK will be at: `build/app/outputs/flutter-apk/app-release.apk`

### Run on Device

```bash
flutter run
```

## 📖 How to Use

1. Choose **Pinch** or **CT** tab
2. Enter measurements:
   - BMI (or use built-in calculator)
   - R, L, I (thickness in mm)
   - H, W (dimensions in cm)
3. Tap **Calculate**
4. View estimated flap weight in grams

## 🔬 Medical Formulas

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

## 📚 Documentation

- **TECHNICAL.md** - Complete technical documentation
- **SETUP.md** - Detailed setup instructions
- **DEPLOYMENT.md** - Build and deployment guide

## ⚠️ Disclaimer

This app is for **qualified medical professionals only**. Use clinical judgment and verify all measurements. Not a substitute for professional medical advice.

## 🎓 Credits

**Original Research:**
- Kyongje Woo, MD
- Goohyun Mun, MD

*Department of Plastic Surgery, Samsung Medical Center*

**Citation:** Woo KJ, et al. "A Novel Method to Estimate the Weight of the DIEP Flap in Breast Reconstruction." *J Reconstr Microsurg.* 2016;32(7):520-7. [PMID: 27050336](https://pubmed.ncbi.nlm.nih.gov/27050336/)

## 📄 License

For educational and clinical use. Please cite the original research.
