import '../constants/app_constants.dart';

class UrlParser {
  UrlParser._();

  static String? detectPlatform(String url) {
    for (final platform in AppConstants.supportedPlatforms) {
      final regex = RegExp(platform.pattern, caseSensitive: false);
      if (regex.hasMatch(url)) {
        return platform.name;
      }
    }
    return null;
  }

  static bool isValidUrl(String url) {
    final urlPattern = RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)',
      caseSensitive: false,
    );
    return urlPattern.hasMatch(url);
  }

  static bool isValidVideoUrl(String url) {
    // Check if URL is valid format first
    if (!isValidUrl(url)) {
      return false;
    }
    // Check if URL is from a supported video platform
    return detectPlatform(url) != null;
  }

  static String getPlatformIcon(String platform) {
    switch (platform.toLowerCase()) {
      case 'youtube':
        return '🎥';
      case 'tiktok':
        return '🎵';
      case 'instagram':
        return '📷';
      case 'twitter':
      case 'x':
        return '🐦';
      case 'facebook':
        return '👍';
      case 'reddit':
        return '🤖';
      case 'vimeo':
        return '▶️';
      case 'dailymotion':
        return '📹';
      default:
        return '🌐';
    }
  }
}
