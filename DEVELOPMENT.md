# Development Guide

## Getting Started

### Prerequisites
- Flutter SDK 3.0+
- Dart SDK 3.0+
- IDE: VS Code, Android Studio, or IntelliJ IDEA
- Git

### Setup Development Environment

1. **Clone the repository**
   ```bash
   git clone https://github.com/133ahmad133/Video-Downloader-.git
   cd Video-Downloader-
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

## Project Architecture

### Folder Structure
```
lib/
├── core/              # Core functionality
│   ├── theme/         # App theming
│   ├── constants/     # Constants
│   └── utils/         # Utility functions
├── models/            # Data models
├── services/          # Business logic layer
├── screens/           # UI screens
├── widgets/           # Reusable widgets
└── navigation/        # Navigation components
```

### Design Patterns

- **Clean Architecture**: Separation of concerns
- **Repository Pattern**: Data access abstraction
- **Provider Pattern**: State management with Riverpod
- **Widget Composition**: Reusable UI components

## State Management

Using **Riverpod** for state management:

```dart
// Define a provider
final myProvider = Provider((ref) => MyService());

// Use in widget
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final service = ref.watch(myProvider);
    return ...;
  }
}
```

## Theming

### Color Scheme
- Uses Material 3 design system
- Custom gradient definitions in `app_colors.dart`
- Glassmorphism effects for modern UI

### Typography
- Inter font family via Google Fonts
- Proper type scale following Material 3

### Dark/Light Modes
Toggle in Settings screen, controlled by `themeModeProvider`

## Code Style

### Follow Flutter Best Practices
- Use `const` constructors where possible
- Prefer composition over inheritance
- Use named parameters for widgets
- Add trailing commas for better formatting

### Linting
The project uses strict lint rules defined in `analysis_options.yaml`

Run analysis:
```bash
flutter analyze
```

Format code:
```bash
flutter format .
```

## Adding New Features

### 1. Create a New Screen

```dart
// lib/screens/my_screen/my_screen.dart
class MyScreen extends StatelessWidget {
  const MyScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Screen')),
      body: // Your UI
    );
  }
}
```

### 2. Add to Navigation

Update `app.dart` to include the new screen in the navigation

### 3. Create Reusable Widgets

Place in `lib/widgets/` if used across multiple screens
Place in `lib/screens/*/widgets/` if specific to one screen

### 4. Add Services

```dart
// lib/services/my_service.dart
class MyService {
  Future<void> doSomething() async {
    // Implementation
  }
}

// Create provider
final myServiceProvider = Provider((ref) => MyService());
```

## Testing

### Run Tests
```bash
flutter test
```

### Widget Tests
```dart
testWidgets('My widget test', (WidgetTester tester) async {
  await tester.pumpWidget(MyApp());
  expect(find.text('Hello'), findsOneWidget);
});
```

## Building

### Debug Build
```bash
flutter run
```

### Release Build

**Android**
```bash
flutter build apk --release
flutter build appbundle --release
```

**iOS**
```bash
flutter build ios --release
```

**Windows**
```bash
flutter build windows --release
```

**macOS**
```bash
flutter build macos --release
```

**Linux**
```bash
flutter build linux --release
```

## Common Tasks

### Add a New Dependency
1. Add to `pubspec.yaml`
2. Run `flutter pub get`
3. Import in your Dart files

### Update App Icon
1. Place icon in `assets/images/app_icon.png`
2. Use flutter_launcher_icons package
3. Run `flutter pub run flutter_launcher_icons`

### Change App Name
Update in:
- `pubspec.yaml`
- `android/app/src/main/AndroidManifest.xml`
- `ios/Runner/Info.plist`
- Platform-specific configuration files

## Debugging

### Debug Tools
- Flutter DevTools: `flutter pub global run devtools`
- Flutter Inspector in IDE
- Dart Observatory for performance

### Common Issues

**Hot Reload Not Working**
```bash
flutter clean
flutter pub get
flutter run
```

**Build Errors**
```bash
flutter clean
flutter pub cache repair
flutter pub get
```

## Performance Optimization

### Tips
- Use `const` constructors
- Implement `ListView.builder` for long lists
- Use `RepaintBoundary` for complex widgets
- Lazy load images with `CachedNetworkImage`
- Profile with DevTools before optimizing

### AOT Compilation
Release builds automatically use AOT compilation for best performance

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Write/update tests
5. Submit a pull request

## Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Dart Documentation](https://dart.dev/guides)
- [Material Design 3](https://m3.material.io/)
- [Riverpod Documentation](https://riverpod.dev/)
