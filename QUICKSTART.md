# Quick Start Guide

Get the Video Downloader app running in minutes!

## 🚀 Quick Setup (5 minutes)

### Step 1: Install Flutter
If you don't have Flutter installed:

**Windows**
```bash
# Download Flutter SDK from https://docs.flutter.dev/get-started/install/windows
# Extract and add to PATH
```

**macOS**
```bash
brew install flutter
```

**Linux**
```bash
snap install flutter --classic
```

Verify installation:
```bash
flutter doctor
```

### Step 2: Clone & Setup
```bash
# Clone the repository
git clone https://github.com/133ahmad133/Video-Downloader-.git
cd Video-Downloader-

# Get dependencies
flutter pub get
```

### Step 3: Run the App
```bash
# For mobile (connect device or start emulator first)
flutter run

# For desktop
flutter run -d windows    # Windows
flutter run -d macos      # macOS
flutter run -d linux      # Linux
```

That's it! The app should now be running. 🎉

---

## 📱 First Time Using the App

1. **Paste a Video URL**
   - Copy any video URL from YouTube, TikTok, Instagram, etc.
   - Paste it in the URL input field on the Home screen
   - Click "Fetch Video Info"

2. **Select Quality & Format**
   - Choose your preferred video quality (360p - 4K)
   - Select format (MP4, MKV, WEBM, MP3)

3. **Download**
   - Click the "Download Video" button
   - Monitor progress in the Downloads tab
   - Find completed downloads in the History tab

---

## 🎨 UI Features to Try

### Dark/Light Theme
- Go to Settings → Toggle "Dark Theme"
- See the smooth theme transition

### Responsive Layout
- Resize the window (desktop)
- Notice how the layout adapts between mobile and desktop views

### Animations
- Watch the glow effect when focusing on the URL input
- See smooth progress animations during downloads
- Experience page transitions between tabs

---

## ⚙️ Configuration

### Default Settings
Go to **Settings** to configure:
- Default video quality
- Default format
- Number of concurrent downloads
- Download location (desktop only)

---

## 🛠️ Development Mode

### Enable Hot Reload
When running in debug mode, you can make code changes and see them instantly:
- Press `r` in terminal to hot reload
- Press `R` to hot restart

### Debug Features
- Press `p` to toggle performance overlay
- Press `i` to toggle inspector
- Press `o` to toggle platform (Android/iOS)

---

## 📚 Learn More

- **Full Documentation**: See [README.md](README.md)
- **Development Guide**: See [DEVELOPMENT.md](DEVELOPMENT.md)
- **YT-DLP Setup**: See [YT-DLP_INTEGRATION.md](YT-DLP_INTEGRATION.md)

---

## 🐛 Troubleshooting

### App won't run?
```bash
flutter clean
flutter pub get
flutter run
```

### Dependencies issues?
```bash
flutter pub cache repair
flutter pub get
```

### Platform-specific issues?
```bash
flutter doctor -v
# Follow the suggestions
```

---

## 💡 Tips

1. **Use Mock Data**: The app currently uses mock data for video info. Real yt-dlp integration requires additional setup (see YT-DLP_INTEGRATION.md)

2. **Mobile Testing**: Use an emulator or real device. Connect via USB and enable developer mode.

3. **Desktop Testing**: Desktop builds are fastest for development and testing UI changes.

4. **Performance**: Always test release builds for true performance metrics:
   ```bash
   flutter run --release
   ```

---

## 🎯 Next Steps

After getting the app running:

1. ✅ Explore all four tabs (Home, Downloads, History, Settings)
2. ✅ Try the theme toggle in Settings
3. ✅ Test responsive layout by resizing window
4. ✅ Read the full README for all features
5. ✅ Check DEVELOPMENT.md to understand the architecture

**Ready to contribute?** See the Contributing section in README.md!

---

<div align="center">

**Questions?** Open an issue on GitHub

**Enjoy the app!** ⭐ Star the repo if you like it!

</div>
