# 🎬 Video Downloader

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-3.0+-02569B?style=for-the-badge&logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.0+-0175C2?style=for-the-badge&logo=dart)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)

A stunning, cross-platform video downloader app with premium UI supporting **1700+ websites**

[Features](#features) • [Screenshots](#screenshots) • [Installation](#installation) • [Build](#build) • [Tech Stack](#tech-stack)

</div>

---

## ✨ Features

### 🎯 Core Functionality
- ✅ **Universal Video Support** - Download from YouTube, TikTok, Instagram, Twitter/X, Facebook, Reddit, Vimeo, Dailymotion, and 1700+ more sites
- ✅ **Quality Selection** - Choose from 360p, 480p, 720p, 1080p, 1440p, 2160p (4K)
- ✅ **Multiple Formats** - Download as MP4, MKV, WEBM, or extract audio as MP3
- ✅ **Batch Downloads** - Queue multiple videos for simultaneous downloading
- ✅ **Real-time Progress** - Live download speed, ETA, and progress tracking
- ✅ **Download Management** - Pause, resume, and cancel downloads
- ✅ **Download History** - Keep track of all completed downloads
- ✅ **Smart URL Detection** - Automatically detects video platform from URL

### 🎨 Premium UI/UX
- ✅ **Material 3 Design** - Modern, clean interface following Material Design 3 guidelines
- ✅ **Dark/Light Themes** - Beautiful dark theme (default) with light theme option
- ✅ **Glassmorphism Effects** - Frosted glass cards with blur backgrounds
- ✅ **Gradient Accents** - Smooth animated gradients on buttons and progress bars
- ✅ **Smooth Animations** - Page transitions, micro-interactions, and progress animations
- ✅ **Responsive Layout** - Adapts perfectly between mobile and desktop
- ✅ **Modern Typography** - Clean Inter font family with proper hierarchy
- ✅ **Platform Badges** - Visual indicators for each supported platform

### 📱 Cross-Platform
- ✅ **Android** - Optimized for phones and tablets
- ✅ **iOS** - Native iOS experience
- ✅ **Windows** - Full desktop functionality
- ✅ **macOS** - Native macOS experience
- ✅ **Linux** - Complete Linux support

### ⚡ Performance
- ✅ **AOT Compilation** - Ahead-of-Time compilation for maximum performance
- ✅ **Tree Shaking** - Minimized app size through dead code elimination
- ✅ **Optimized Builds** - Release builds configured for best performance
- ✅ **Efficient State Management** - Using Riverpod for reactive state management

---

## 📸 Screenshots

> Screenshots will be added here once the app is built and running

---

## 🚀 Installation

### Prerequisites
- Flutter SDK 3.0 or higher
- Dart SDK 3.0 or higher
- For mobile: Android Studio / Xcode
- For desktop: Visual Studio (Windows), Xcode (macOS), or build tools (Linux)

### Clone the Repository
```bash
git clone https://github.com/133ahmad133/Video-Downloader-.git
cd Video-Downloader-
```

### Install Dependencies
```bash
flutter pub get
```

### Run the App
```bash
# Mobile/Desktop
flutter run

# Specific platform
flutter run -d android
flutter run -d ios
flutter run -d windows
flutter run -d macos
flutter run -d linux
```

---

## 🔨 Build

### Build for Android
```bash
flutter build apk --release
# or for app bundle
flutter build appbundle --release
```

### Build for iOS
```bash
flutter build ios --release
```

### Build for Windows
```bash
flutter build windows --release
```

### Build for macOS
```bash
flutter build macos --release
```

### Build for Linux
```bash
flutter build linux --release
```

---

## 🛠️ Tech Stack

### Framework & Language
- **Flutter** - Cross-platform UI framework
- **Dart** - Programming language

### State Management
- **Riverpod** - Modern reactive state management

### Networking & Downloads
- **Dio** - Powerful HTTP client
- **yt-dlp** - Universal video downloader (supports 1700+ sites)

### Storage
- **Hive** - Fast, lightweight NoSQL database
- **Path Provider** - Access to file system paths

### UI Components
- **Google Fonts** - Modern Inter font family
- **Flutter Animate** - Declarative animations
- **Shimmer** - Beautiful loading placeholders
- **Cached Network Image** - Image caching for thumbnails

### Utilities
- **URL Launcher** - Open files and folders
- **Share Plus** - Share downloaded files
- **Permission Handler** - Handle storage permissions
- **Intl** - Date and number formatting

---

## 📁 Project Structure

```
lib/
├── main.dart                     # App entry point
├── app.dart                      # Main app widget
├── core/
│   ├── theme/                    # Theme configuration
│   │   ├── app_theme.dart        # Material 3 themes
│   │   ├── app_colors.dart       # Color palette
│   │   └── app_typography.dart   # Font styles
│   ├── constants/                # App constants
│   └── utils/                    # Utility functions
├── models/                       # Data models
│   ├── video_info.dart
│   ├── download_task.dart
│   └── download_history.dart
├── services/                     # Business logic
│   ├── video_extraction_service.dart
│   ├── download_service.dart
│   └── storage_service.dart
├── screens/                      # UI screens
│   ├── home/
│   ├── downloads/
│   ├── history/
│   └── settings/
├── widgets/                      # Reusable widgets
│   ├── glassmorphic_card.dart
│   ├── gradient_button.dart
│   ├── animated_progress.dart
│   ├── skeleton_loader.dart
│   ├── platform_badge.dart
│   └── responsive_layout.dart
└── navigation/                   # Navigation components
    ├── bottom_nav_bar.dart
    └── side_nav_rail.dart
```

---

## ⚙️ Configuration

### Android
- **Min SDK**: 21 (Android 5.0 Lollipop)
- **Target SDK**: 34 (Android 14)
- **AOT**: Enabled in release mode
- **Minification**: Enabled with ProGuard

### iOS
- **Min iOS**: 12.0
- **Build mode**: Release with optimizations

### Desktop
- Configured for Windows, macOS, and Linux with native runners

---

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

---

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

---

## 🙏 Acknowledgments

- **yt-dlp** - For the amazing universal video downloader
- **Flutter Team** - For the incredible cross-platform framework
- **Material Design** - For the design guidelines

---

<div align="center">

Made with ❤️ using Flutter

**[⬆ back to top](#-video-downloader)**

</div>
