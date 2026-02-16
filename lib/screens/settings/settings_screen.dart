import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_constants.dart';
import '../../widgets/glassmorphic_card.dart';

final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.dark);

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  String _defaultQuality = AppConstants.defaultQuality;
  String _defaultFormat = AppConstants.defaultFormat;
  int _concurrentDownloads = AppConstants.defaultConcurrentDownloads;

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);
    final isDark = themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Appearance Section
          _buildSectionTitle('Appearance'),
          const SizedBox(height: 12),
          GlassmorphicCard(
            padding: const EdgeInsets.all(0),
            child: SwitchListTile(
              title: const Text('Dark Theme'),
              subtitle: const Text('Use dark theme for better visibility'),
              value: isDark,
              onChanged: (value) {
                ref.read(themeModeProvider.notifier).state =
                    value ? ThemeMode.dark : ThemeMode.light;
              },
              secondary: Icon(isDark ? Icons.dark_mode : Icons.light_mode),
            ),
          ),
          const SizedBox(height: 24),

          // Download Settings
          _buildSectionTitle('Download Settings'),
          const SizedBox(height: 12),
          GlassmorphicCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Default Quality',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: _defaultQuality,
                  decoration: const InputDecoration(
                    labelText: 'Video Quality',
                    border: OutlineInputBorder(),
                  ),
                  items: AppConstants.qualityOptions.map((quality) {
                    return DropdownMenuItem(
                      value: quality,
                      child: Text(quality),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _defaultQuality = value);
                    }
                  },
                ),
                const SizedBox(height: 16),
                Text(
                  'Default Format',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: _defaultFormat,
                  decoration: const InputDecoration(
                    labelText: 'Video Format',
                    border: OutlineInputBorder(),
                  ),
                  items: AppConstants.formatOptions.map((format) {
                    return DropdownMenuItem(
                      value: format,
                      child: Text(format.toUpperCase()),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _defaultFormat = value);
                    }
                  },
                ),
                const SizedBox(height: 16),
                Text(
                  'Concurrent Downloads',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Slider(
                        value: _concurrentDownloads.toDouble(),
                        min: 1,
                        max: 5,
                        divisions: 4,
                        label: _concurrentDownloads.toString(),
                        onChanged: (value) {
                          setState(() => _concurrentDownloads = value.toInt());
                        },
                      ),
                    ),
                    SizedBox(
                      width: 40,
                      child: Text(
                        _concurrentDownloads.toString(),
                        style: Theme.of(context).textTheme.titleMedium,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Storage
          _buildSectionTitle('Storage'),
          const SizedBox(height: 12),
          GlassmorphicCard(
            padding: const EdgeInsets.all(0),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.folder),
                  title: const Text('Download Location'),
                  subtitle: const Text('Default/Downloads'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // Open folder picker
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.storage),
                  title: const Text('Storage Usage'),
                  subtitle: const Text('0 MB used'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    // Show storage details
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // About
          _buildSectionTitle('About'),
          const SizedBox(height: 12),
          GlassmorphicCard(
            padding: const EdgeInsets.all(0),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.info),
                  title: const Text('Version'),
                  subtitle: Text(AppConstants.appVersion),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.description),
                  title: const Text('Licenses'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    showLicensePage(context: context);
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.code),
                  title: const Text('GitHub Repository'),
                  trailing: const Icon(Icons.open_in_new),
                  onTap: () {
                    // Open GitHub repo
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
  }
}
