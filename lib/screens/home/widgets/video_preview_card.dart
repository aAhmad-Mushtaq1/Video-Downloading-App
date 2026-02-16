import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../models/video_info.dart';
import '../../../widgets/glassmorphic_card.dart';
import '../../../widgets/platform_badge.dart';
import '../../../core/utils/format_utils.dart';

class VideoPreviewCard extends StatelessWidget {
  final VideoInfo videoInfo;

  const VideoPreviewCard({
    super.key,
    required this.videoInfo,
  });

  @override
  Widget build(BuildContext context) {
    return GlassmorphicCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: videoInfo.thumbnail != null
                  ? CachedNetworkImage(
                      imageUrl: videoInfo.thumbnail!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.grey[800],
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[800],
                        child: const Icon(
                          Icons.video_library,
                          size: 48,
                          color: Colors.white54,
                        ),
                      ),
                    )
                  : Container(
                      color: Colors.grey[800],
                      child: const Icon(
                        Icons.video_library,
                        size: 48,
                        color: Colors.white54,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Title
          Text(
            videoInfo.title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          
          // Author and Duration
          Row(
            children: [
              if (videoInfo.author != null) ...[
                Icon(
                  Icons.person,
                  size: 16,
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
                const SizedBox(width: 4),
                Text(
                  videoInfo.author!,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(width: 16),
              ],
              if (videoInfo.duration != null) ...[
                Icon(
                  Icons.access_time,
                  size: 16,
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
                const SizedBox(width: 4),
                Text(
                  FormatUtils.formatDuration(videoInfo.duration),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),
          
          // Platform Badge
          PlatformBadge(platform: videoInfo.platform),
        ],
      ),
    );
  }
}
