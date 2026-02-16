import 'package:hive_flutter/hive_flutter.dart';
import '../models/download_history.dart';

class StorageService {
  static const String _historyBoxName = 'download_history';
  static const String _settingsBoxName = 'app_settings';

  Box<Map>? _historyBox;
  Box<dynamic>? _settingsBox;

  Future<void> init() async {
    await Hive.initFlutter();
    _historyBox = await Hive.openBox<Map>(_historyBoxName);
    _settingsBox = await Hive.openBox(_settingsBoxName);
  }

  // History operations
  Future<void> addToHistory(DownloadHistory item) async {
    final box = _historyBox;
    if (box == null) return;
    
    await box.put(item.id, item.toJson());
  }

  Future<List<DownloadHistory>> getHistory() async {
    final box = _historyBox;
    if (box == null) return [];
    
    final items = <DownloadHistory>[];
    for (final value in box.values) {
      try {
        final map = Map<String, dynamic>.from(value);
        items.add(DownloadHistory.fromJson(map));
      } catch (e) {
        // Skip invalid items
      }
    }
    
    // Sort by date (newest first)
    items.sort((a, b) => b.downloadedAt.compareTo(a.downloadedAt));
    return items;
  }

  Future<void> deleteFromHistory(String id) async {
    final box = _historyBox;
    if (box == null) return;
    
    await box.delete(id);
  }

  Future<void> clearHistory() async {
    final box = _historyBox;
    if (box == null) return;
    
    await box.clear();
  }

  // Settings operations
  Future<void> saveSetting(String key, dynamic value) async {
    final box = _settingsBox;
    if (box == null) return;
    
    await box.put(key, value);
  }

  T? getSetting<T>(String key, {T? defaultValue}) {
    final box = _settingsBox;
    if (box == null) return defaultValue;
    
    return box.get(key, defaultValue: defaultValue) as T?;
  }

  Future<void> deleteSetting(String key) async {
    final box = _settingsBox;
    if (box == null) return;
    
    await box.delete(key);
  }

  Future<void> clearSettings() async {
    final box = _settingsBox;
    if (box == null) return;
    
    await box.clear();
  }

  void dispose() {
    _historyBox?.close();
    _settingsBox?.close();
  }
}
