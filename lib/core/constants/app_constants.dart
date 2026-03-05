class AppConstants {
  AppConstants._();

  static const String appName = 'Video Downloader';
  static const String appVersion = '1.0.0';
  
  // Storage keys
  static const String themeKey = 'theme_mode';
  static const String downloadPathKey = 'download_path';
  static const String defaultQualityKey = 'default_quality';
  static const String defaultFormatKey = 'default_format';
  static const String concurrentDownloadsKey = 'concurrent_downloads';
  
  // Default values
  static const String defaultQuality = '720p';
  static const String defaultFormat = 'mp4';
  static const int defaultConcurrentDownloads = 3;
  
  // Supported platforms
  static const List<PlatformInfo> supportedPlatforms = [
    PlatformInfo(name: 'YouTube', pattern: r'(youtube\.com|youtu\.be)'),
    PlatformInfo(name: 'TikTok', pattern: r'tiktok\.com'),
    PlatformInfo(name: 'Instagram', pattern: r'instagram\.com'),
    PlatformInfo(name: 'Twitter', pattern: r'(twitter\.com|x\.com)'),
    PlatformInfo(name: 'Facebook', pattern: r'facebook\.com'),
    PlatformInfo(name: 'Reddit', pattern: r'reddit\.com'),
    PlatformInfo(name: 'Vimeo', pattern: r'vimeo\.com'),
    PlatformInfo(name: 'Dailymotion', pattern: r'dailymotion\.com'),
  ];
  
  // Quality options
  static const List<String> qualityOptions = [
    '360p',
    '480p',
    '720p',
    '1080p',
    '1440p',
    '2160p',
  ];
  
  // Format options
  static const List<String> formatOptions = [
    'mp4',
    'mkv',
    'webm',
    'mp3',
  ];
}

class PlatformInfo {
  final String name;
  final String pattern;

  const PlatformInfo({
    required this.name,
    required this.pattern,
  });
}
