import 'package:flutter/material.dart';
import '../../../models/download_task.dart';
import '../../../widgets/animated_progress.dart';
import '../../../core/utils/format_utils.dart';
import '../../../widgets/glassmorphic_card.dart';
import 'package:cached_network_image/cached_network_image.dart';

class DownloadTile extends StatelessWidget {
  final DownloadTask task;
  final VoidCallback? onPause;
  final VoidCallback? onResume;
  final VoidCallback? onCancel;

  const DownloadTile({
    super.key,
    required this.task,
    this.onPause,
    this.onResume,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return GlassmorphicCard(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thumbnail
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 80,
                  height: 60,
                  child: task.thumbnail != null
                      ? CachedNetworkImage(
                          imageUrl: task.thumbnail!,
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) => Container(
                            color: Colors.grey[800],
                            child: const Icon(Icons.video_library, color: Colors.white54),
                          ),
                        )
                      : Container(
                          color: Colors.grey[800],
                          child: const Icon(Icons.video_library, color: Colors.white54),
                        ),
                ),
              ),
              const SizedBox(width: 12),
              
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${task.quality} • ${task.format.toUpperCase()}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              
              // Status Icon
              _buildStatusIcon(),
            ],
          ),
          const SizedBox(height: 12),
          
          // Progress Bar
          AnimatedProgress(progress: task.progress),
          const SizedBox(height: 8),
          
          // Download Info
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _getProgressText(),
                style: Theme.of(context).textTheme.bodySmall,
              ),
              if (task.speed != null)
                Text(
                  FormatUtils.formatSpeed(task.speed!),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Action Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (task.status == DownloadStatus.downloading)
                TextButton.icon(
                  onPressed: onPause,
                  icon: const Icon(Icons.pause, size: 18),
                  label: const Text('Pause'),
                )
              else if (task.status == DownloadStatus.paused)
                TextButton.icon(
                  onPressed: onResume,
                  icon: const Icon(Icons.play_arrow, size: 18),
                  label: const Text('Resume'),
                ),
              const SizedBox(width: 8),
              if (task.status != DownloadStatus.completed)
                TextButton.icon(
                  onPressed: onCancel,
                  icon: const Icon(Icons.close, size: 18),
                  label: const Text('Cancel'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.red,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusIcon() {
    switch (task.status) {
      case DownloadStatus.downloading:
        return const SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 2),
        );
      case DownloadStatus.paused:
        return const Icon(Icons.pause_circle, color: Colors.orange);
      case DownloadStatus.completed:
        return const Icon(Icons.check_circle, color: Colors.green);
      case DownloadStatus.failed:
        return const Icon(Icons.error, color: Colors.red);
      default:
        return const Icon(Icons.schedule, color: Colors.blue);
    }
  }

  String _getProgressText() {
    if (task.status == DownloadStatus.completed) {
      return 'Completed';
    }
    if (task.status == DownloadStatus.failed) {
      return 'Failed: ${task.errorMessage ?? "Unknown error"}';
    }
    if (task.downloadedBytes != null && task.totalBytes != null) {
      final downloaded = FormatUtils.formatFileSize(task.downloadedBytes!);
      final total = FormatUtils.formatFileSize(task.totalBytes!);
      final percent = (task.progress * 100).toInt();
      return '$percent% • $downloaded / $total';
    }
    return '${(task.progress * 100).toInt()}%';
  }
}
