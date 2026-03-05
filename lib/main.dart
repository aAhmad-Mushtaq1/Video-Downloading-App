import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'core/constants/app_constants.dart';
import 'providers/storage_provider.dart';
import 'screens/settings/settings_screen.dart';
import 'services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final storageService = StorageService();
  await storageService.init();

  final themeStr = storageService.getSetting<String>(AppConstants.themeKey);
  final themeMode =
      themeStr == 'light' ? ThemeMode.light : ThemeMode.dark;

  runApp(
    ProviderScope(
      overrides: [
        storageServiceProvider.overrideWithValue(storageService),
        themeModeProvider.overrideWith((ref) => themeMode),
      ],
      child: const App(),
    ),
  );
}
