class FormatUtils {
  FormatUtils._();

  static String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    }
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  static String formatDuration(String? durationString) {
    if (durationString == null) return 'Unknown';
    
    try {
      final seconds = int.tryParse(durationString);
      if (seconds == null) return durationString;
      
      final hours = seconds ~/ 3600;
      final minutes = (seconds % 3600) ~/ 60;
      final secs = seconds % 60;
      
      if (hours > 0) {
        return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
      }
      return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
    } catch (e) {
      return durationString;
    }
  }

  static String formatSpeed(double bytesPerSecond) {
    if (bytesPerSecond < 1024) {
      return '${bytesPerSecond.toStringAsFixed(0)} B/s';
    }
    if (bytesPerSecond < 1024 * 1024) {
      return '${(bytesPerSecond / 1024).toStringAsFixed(1)} KB/s';
    }
    return '${(bytesPerSecond / (1024 * 1024)).toStringAsFixed(1)} MB/s';
  }

  static String formatEta(int seconds) {
    if (seconds < 60) {
      return '$seconds sec';
    }
    if (seconds < 3600) {
      final minutes = seconds ~/ 60;
      return '$minutes min';
    }
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    return '${hours}h ${minutes}m';
  }
}
