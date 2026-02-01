# Deployment Guide

## Current Deployment

**Live URL:** [https://simonseo.github.io/diep-w-port/](https://simonseo.github.io/diep-w-port/)

**Repository:** [https://github.com/simonseo/diep-w-port](https://github.com/simonseo/diep-w-port)

**Method:** GitHub Pages using `/docs` folder from `main` branch

## Repository Structure

```
diep-w-port/
├── docs/           # GitHub Pages deployment (copy of flutter/build/web/)
├── flutter/        # Flutter app source + build
│   ├── build/web/  # Production build
│   └── ...
└── cordova/        # Legacy app (archived)
```

## Updating the Deployment

### 1. Make Changes
Edit Flutter code in the `flutter/` directory

### 2. Rebuild
```bash
flutter build web --release --web-renderer canvaskit --base-href /diep-w-port/
```

**Important:** Always include `--base-href /diep-w-port/` for GitHub Pages subpath deployment.

### 3. Copy to Docs
```bash
# From repository root
rm -rf docs
cp -r flutter/build/web docs
```

### 4. Commit and Push
```bash
git add -A
git commit -m "Update deployment: [describe changes]"
git push origin main
```

GitHub Pages will automatically rebuild within 1-2 minutes.

### 5. Verify
Check the live site: [https://simonseo.github.io/diep-w-port/](https://simonseo.github.io/diep-w-port/)

## Alternative Deployment Options

### Prerequisites
- GitHub account
- Git installed locally
- Flutter web build completed

### Step 1: Initialize Git Repository (if not already done)
```bash
cd /Users/sseo/Documents/diep-w/diep_w_flutter
git init
git add .
git commit -m "Initial commit: DIEP-W Flutter app"
```

### Step 2: Create GitHub Repository
1. Go to https://github.com/new
2. Repository name: `diep-w-flutter` (or your choice)
3. Description: "DIEP flap weight estimation calculator for breast reconstruction surgery"
4. Select "Public" (required for free GitHub Pages)
5. Do NOT initialize with README (we already have code)
6. Click "Create repository"

### Step 3: Connect Local Repository to GitHub
```bash
git remote add origin https://github.com/YOUR_USERNAME/diep-w-flutter.git
git branch -M main
git push -u origin main
```

### Step 4: Deploy to GitHub Pages

#### Option A: Using gh-pages branch (Recommended)
```bash
# Install gh-pages tool (if not already)
# This creates a separate branch for deployment

# Build the web app
~/flutter/bin/flutter build web --release --base-href "/diep-w-flutter/"

# Create gh-pages branch and push build
git checkout --orphan gh-pages
git rm -rf .
cp -r build/web/* .
git add .
git commit -m "Deploy to GitHub Pages"
git push origin gh-pages
git checkout main
```

#### Option B: Using GitHub Actions (Automated)
Create `.github/workflows/deploy.yml`:
```yaml
name: Deploy to GitHub Pages

on:
  push:
    branches: [ main ]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.16.0'
      
      - name: Install dependencies
        run: flutter pub get
      
      - name: Build web
        run: flutter build web --release --base-href "/diep-w-flutter/"
      
      - name: Deploy to GitHub Pages
        uses: peaceiris/actions-gh-pages@v3
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: ./build/web
```

### Step 5: Enable GitHub Pages
1. Go to your repository on GitHub
2. Click "Settings" → "Pages"
3. Under "Source", select:
   - **Branch:** `gh-pages`
   - **Folder:** `/ (root)`
4. Click "Save"

### Step 6: Access Your Deployed App
After 1-2 minutes, your app will be live at:
```
https://YOUR_USERNAME.github.io/diep-w-flutter/
```

## Important Notes

### Base HREF
When building for GitHub Pages with a repository name, you MUST include the base-href:
```bash
flutter build web --release --base-href "/REPO_NAME/"
```

Without this, assets won't load correctly.

### Custom Domain (Optional)
To use a custom domain:
1. Add a `CNAME` file to your gh-pages branch with your domain
2. Configure DNS with your domain provider:
   - Add A records pointing to GitHub's IPs
   - Or add CNAME record pointing to `YOUR_USERNAME.github.io`
3. In repository settings, add your custom domain under "Custom domain"

### Updating the Deployment
To update the deployed app:
```bash
# Make changes to your code
git add .
git commit -m "Update: description of changes"
git push origin main

# Rebuild and redeploy
~/flutter/bin/flutter build web --release --base-href "/diep-w-flutter/"
git checkout gh-pages
cp -r build/web/* .
git add .
git commit -m "Update deployment"
git push origin gh-pages
git checkout main
```

Or if using GitHub Actions, just push to main and it deploys automatically!

## Alternative Deployment Options

### Netlify (Easier, Free)
1. Drag and drop `build/web` folder to https://app.netlify.com/drop
2. Get instant HTTPS URL
3. Optional: Configure custom domain

### Firebase Hosting (Free, Fast CDN)
```bash
npm install -g firebase-tools
firebase login
firebase init hosting
# Select build/web as public directory
firebase deploy
```

### Vercel (Free, Auto-deploy from GitHub)
1. Import GitHub repository at https://vercel.com
2. Set build settings:
   - Build Command: `flutter build web --release`
   - Output Directory: `build/web`
3. Deploy automatically on every push

## Testing Locally
```bash
# Serve the built files
python3 -m http.server 8080 -d build/web

# Or use Flutter's built-in server
flutter run -d chrome
```

## Troubleshooting

### Assets not loading (404 errors)
- Check `--base-href` flag matches your repository name
- Ensure all asset paths are relative, not absolute

### Service Worker issues
- Clear browser cache
- Disable service worker in DevTools during development
- Check browser console for errors

### PWA not installable
- Ensure site is served over HTTPS (GitHub Pages does this automatically)
- Check manifest.json is accessible
- Verify icons are loading correctly

## Security Considerations

### No Sensitive Data
This app processes medical calculations but:
- All calculations happen client-side (no data sent to server)
- History stored in browser localStorage only
- No backend database or API calls
- HTTPS ensures data in transit security (via GitHub Pages)

### Medical Disclaimer
Remember to keep the disclaimer visible and prominent!
