import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/storage_service.dart';

/// Single shared instance of [StorageService] used across the app.
/// The service is initialized once at app startup in main.dart.
final storageServiceProvider = Provider<StorageService>((ref) {
  final service = StorageService();
  ref.onDispose(service.dispose);
  return service;
});
