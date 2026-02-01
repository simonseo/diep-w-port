# DIEP-W Calculator

DIEP flap weight estimation calculator for breast reconstruction surgery.

## 🌐 Live Demo

**Try it now:** [https://simonseo.github.io/diep-w-port/](https://simonseo.github.io/diep-w-port/)

[![Deploy Status](https://img.shields.io/badge/deploy-GitHub%20Pages-success)](https://simonseo.github.io/diep-w-port/)
[![Flutter](https://img.shields.io/badge/Flutter-Web%20%7C%20iOS%20%7C%20Android-02569B?logo=flutter)](https://flutter.dev)
[![PWA](https://img.shields.io/badge/PWA-enabled-5A0FC8?logo=pwa)](https://simonseo.github.io/diep-w-port/)

## ✨ Features

- **Three Calculation Modes:**
  - 📏 Pinch Test - Measure abdominal tissue thickness
  - 🔬 CT Measurement - CT scan-based estimation
  - 📊 BMI Calculator - Body mass index calculation
  
- **Modern Features:**
  - 🎨 Material Design 3 UI
  - 🌓 Dark mode support
  - 📱 Progressive Web App (PWA) - Install on any device
  - 💾 Calculation history with localStorage
  - 📴 Offline support
  - 🌍 Cross-platform (Web, iOS, Android)
  - ⚡ Fast, responsive interface

## 📁 Repository Structure

```
diep-w-port/
├── docs/           # GitHub Pages deployment
├── flutter/        # Modern Flutter application - RECOMMENDED
│   ├── lib/        # Dart source code
│   ├── assets/     # Images and resources
│   ├── build/web/  # Production web build
│   └── README.md   # Flutter app documentation
└── cordova/        # Legacy Cordova/Ionic app (archived)
```

## 🚀 Quick Start

### Web App (Deployed)

Simply visit: **[https://simonseo.github.io/diep-w-port/](https://simonseo.github.io/diep-w-port/)**

### Install as PWA

1. Visit the web app
2. Look for "Install" button in browser address bar
3. Or use "Add to Home Screen" on mobile

### Local Development

See [`flutter/README.md`](flutter/README.md) for setup instructions.

## 📖 About

This calculator implements the DIEP-W formula for estimating DIEP (Deep Inferior Epigastric Perforator) flap weight in breast reconstruction surgery. The formula is based on clinical research conducted at Samsung Medical Center.

### Clinical Use

The DIEP-W calculator helps plastic surgeons estimate the weight of tissue available for autologous breast reconstruction, aiding in:
- Pre-operative planning
- Patient consultation
- Bilateral reconstruction symmetry planning

## 🏥 Clinical Validation

Based on clinical research from Samsung Medical Center, Department of Plastic Surgery.

### Citation

Woo KJ, et al. "DIEP Flap Weight Estimation for Breast Reconstruction." Journal of Reconstructive Microsurgery. [Publication details pending]

## 🛠️ Technical Stack

- **Framework:** Flutter (Web, iOS, Android)
- **Language:** Dart
- **UI:** Material Design 3
- **State Management:** Provider
- **Storage:** SharedPreferences / localStorage
- **Deployment:** GitHub Pages
- **PWA:** Service Workers, Web Manifest

## 📄 License

MIT License - See LICENSE file for details.

## 👥 Contact

- **Developer:** simon.myunggun.seo@gmail.com
- **Medical Lead:** economywoo@gmail.com (Dr. Kyongje Woo, MD, PhD)
- **Institution:** Samsung Medical Center, Seoul, South Korea
- **Department:** Department of Plastic and Reconstructive Surgery

## 🔗 Links

- **Live App:** [https://simonseo.github.io/diep-w-port/](https://simonseo.github.io/diep-w-port/)
- **Repository:** [https://github.com/simonseo/diep-w-port](https://github.com/simonseo/diep-w-port)

---

**Note:** The legacy Cordova/Ionic version in `cordova/` is archived and no longer maintained. Please use the Flutter version.
