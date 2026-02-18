import 'package:flutter/material.dart';
import '../core/utils/url_parser.dart';

class PlatformBadge extends StatelessWidget {
  final String platform;
  final double size;

  const PlatformBadge({
    super.key,
    required this.platform,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getPlatformColor().withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _getPlatformColor(),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            UrlParser.getPlatformIcon(platform),
            style: TextStyle(fontSize: size * 0.8),
          ),
          const SizedBox(width: 4),
          Text(
            platform,
            style: TextStyle(
              color: _getPlatformColor(),
              fontSize: size * 0.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Color _getPlatformColor() {
    switch (platform.toLowerCase()) {
      case 'youtube':
        return const Color(0xFFFF0000);
      case 'tiktok':
        return const Color(0xFF000000);
      case 'instagram':
        return const Color(0xFFE4405F);
      case 'twitter':
      case 'x':
        return const Color(0xFF1DA1F2);
      case 'facebook':
        return const Color(0xFF1877F2);
      case 'reddit':
        return const Color(0xFFFF4500);
      case 'vimeo':
        return const Color(0xFF1AB7EA);
      case 'dailymotion':
        return const Color(0xFF0066DC);
      default:
        return const Color(0xFF667EEA);
    }
  }
}
