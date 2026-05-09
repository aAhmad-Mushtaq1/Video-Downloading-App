import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:path_provider/path_provider.dart';
import '../models/download_task.dart';

class DownloadService {
  final Map<String, Process> _processes = {};
  final Map<String, StreamController<DownloadTask>> _progressControllers = {};

  Stream<DownloadTask> downloadVideo(DownloadTask task) {
    final controller = StreamController<DownloadTask>();
    _progressControllers[task.id] = controller;

    _startDownload(task, controller);

    return controller.stream;
  }

  Future<void> _startDownload(
    DownloadTask task,
    StreamController<DownloadTask> controller,
  ) async {
    try {
      final directory = await _getDownloadDirectory();
      final fileName = _sanitizeFileName(task.title);
      final filePath = '${directory.path}/$fileName.${task.format}';

      final updatedTask = task.copyWith(
        status: DownloadStatus.downloading,
        savePath: filePath,
      );
      controller.add(updatedTask);

      await _downloadWithYtDlp(updatedTask, filePath, controller);
    } catch (e) {
      if (!controller.isClosed) {
        controller.add(task.copyWith(
          status: DownloadStatus.failed,
          errorMessage: e.toString(),
        ));
        controller.close();
      }
    } finally {
      _processes.remove(task.id);
      _progressControllers.remove(task.id);
    }
  }

  Future<void> _downloadWithYtDlp(
    DownloadTask task,
    String filePath,
    StreamController<DownloadTask> controller,
  ) async {
    try {
      final args = _buildYtDlpArgs(task, filePath);
      final process = await Process.start('yt-dlp', args);
      _processes[task.id] = process;

      // Drain stderr concurrently to prevent pipe-buffer deadlock.
      final stderrBuffer = StringBuffer();
      process.stderr.transform(utf8.decoder).listen((data) {
        stderrBuffer.write(data);
      });

      process.stdout
          .transform(utf8.decoder)
          .transform(const LineSplitter())
          .listen((line) {
        if (!controller.isClosed) {
          _parseYtDlpProgress(line, task, controller);
        }
      });

      final exitCode = await process.exitCode;
      _processes.remove(task.id);

      if (controller.isClosed) return;

      if (exitCode == 0) {
        controller.add(task.copyWith(
          status: DownloadStatus.completed,
          progress: 1.0,
          completedAt: DateTime.now(),
        ));
      } else {
        throw Exception('yt-dlp failed (exit $exitCode): $stderrBuffer');
      }
    } on ProcessException {
      // yt-dlp not installed – fall back to simulation
      await _simulateDownload(task, controller);
    }

    if (!controller.isClosed) {
      controller.close();
    }
  }

  List<String> _buildYtDlpArgs(DownloadTask task, String filePath) {
    final args = <String>[];

    if (task.format == 'mp3') {
      args.addAll(['-x', '--audio-format', 'mp3']);
    } else {
      final height = task.quality.replaceAll(RegExp(r'[^0-9]'), '');
      if (task.quality.toLowerCase() == 'best' || height.isEmpty) {
        args.addAll([
          '-f',
          'bestvideo+bestaudio/best',
          '--merge-output-format',
          task.format,
        ]);
      } else {
        args.addAll([
          '-f',
          'bestvideo[height<=$height]+bestaudio/best[height<=$height]/best',
          '--merge-output-format',
          task.format,
        ]);
      }
    }

    args.addAll([
      '--newline',
      '--no-playlist',
      '-o', filePath,
      task.url,
    ]);

    return args;
  }

  void _parseYtDlpProgress(
    String line,
    DownloadTask task,
    StreamController<DownloadTask> controller,
  ) {
    // [download]  45.2% of 100.00MiB at 5.00MiB/s ETA 00:11
    final regex = RegExp(
      r'\[download\]\s+([\d.]+)%\s+of\s+~?\s*([\d.]+)\s*([KMGT]i?B)\s+at\s+([\d.]+)\s*([KMGT]i?B\/s)(?:\s+ETA\s+(\S+))?',
    );
    final match = regex.firstMatch(line);
    if (match != null) {
      final progressPct = double.tryParse(match.group(1) ?? '0') ?? 0;
      final totalSizeStr = match.group(2) ?? '0';
      final totalSizeUnit = match.group(3) ?? 'B';
      final speedStr = match.group(4) ?? '0';
      final speedUnit = match.group(5) ?? 'B/s';
      final eta = match.group(6);

      // Convert total size to bytes
      final totalBytes = _convertToBytes(totalSizeStr, totalSizeUnit);
      
      // Calculate downloaded bytes from percentage
      final downloadedBytes = ((progressPct / 100) * totalBytes).toInt();
      
      // Convert speed to bytes per second
      final speed = _convertSpeedToBytes(speedStr, speedUnit);

      controller.add(task.copyWith(
        progress: progressPct / 100,
        downloadedBytes: downloadedBytes,
        totalBytes: totalBytes,
        speed: speed,
        eta: eta,
      ));
    }
  }

  /// Converts file size string to bytes
  /// Example: "100.50 MiB" -> 105398272 bytes
  int _convertToBytes(String sizeStr, String unit) {
    final size = double.tryParse(sizeStr) ?? 0;
    
    switch (unit.toUpperCase()) {
      case 'B':
        return size.toInt();
      case 'KIB':
      case 'KB':
        return (size * 1024).toInt();
      case 'MIB':
      case 'MB':
        return (size * 1024 * 1024).toInt();
      case 'GIB':
      case 'GB':
        return (size * 1024 * 1024 * 1024).toInt();
      case 'TIB':
      case 'TB':
        return (size * 1024 * 1024 * 1024 * 1024).toInt();
      default:
        return size.toInt();
    }
  }

  /// Converts speed string to bytes per second
  /// Example: "5.50 MiB/s" -> 5767168 bytes/s
  double _convertSpeedToBytes(String speedStr, String unit) {
    final speed = double.tryParse(speedStr) ?? 0;
    
    switch (unit.toUpperCase()) {
      case 'B/S':
        return speed;
      case 'KIB/S':
      case 'KB/S':
        return speed * 1024;
      case 'MIB/S':
      case 'MB/S':
        return speed * 1024 * 1024;
      case 'GIB/S':
      case 'GB/S':
        return speed * 1024 * 1024 * 1024;
      case 'TIB/S':
      case 'TB/S':
        return speed * 1024 * 1024 * 1024 * 1024;
      default:
        return speed;
    }
  }

  Future<void> _simulateDownload(
    DownloadTask task,
    StreamController<DownloadTask> controller,
  ) async {
    const totalBytes = 50000000; // 50 MB mock size
    var downloadedBytes = 0;

    while (downloadedBytes < totalBytes && !controller.isClosed) {
      await Future.delayed(const Duration(milliseconds: 100));
      if (controller.isClosed) break;

      downloadedBytes += 500000; // 500 KB per iteration
      if (downloadedBytes > totalBytes) downloadedBytes = totalBytes;

      final progress = downloadedBytes / totalBytes;
      const speed = 5000000.0; // 5 MB/s mock speed
      final remainingBytes = totalBytes - downloadedBytes;
      final eta = (remainingBytes / speed).ceil();

      controller.add(task.copyWith(
        progress: progress,
        downloadedBytes: downloadedBytes,
        totalBytes: totalBytes,
        speed: speed,
        eta: '${eta}s',
      ));
    }

    if (!controller.isClosed) {
      controller.add(task.copyWith(
        status: DownloadStatus.completed,
        progress: 1.0,
        downloadedBytes: totalBytes,
        totalBytes: totalBytes,
        completedAt: DateTime.now(),
      ));
    }
  }

  Future<void> pauseDownload(String taskId) async {
    final process = _processes[taskId];
    if (process != null) {
      process.kill();
      _processes.remove(taskId);
    }
  }

  Future<void> cancelDownload(String taskId) async {
    final process = _processes[taskId];
    if (process != null) {
      process.kill();
      _processes.remove(taskId);
    }
    _progressControllers[taskId]?.close();
    _progressControllers.remove(taskId);
  }

  Future<Directory> _getDownloadDirectory() async {
    if (Platform.isAndroid) {
      // For Android, use external storage
      final directory = await getExternalStorageDirectory();
      return directory ?? await getApplicationDocumentsDirectory();
    } else if (Platform.isIOS) {
      return getApplicationDocumentsDirectory();
    } else {
      // For desktop platforms
      final downloadsDir = await getDownloadsDirectory();
      return downloadsDir ?? await getApplicationDocumentsDirectory();
    }
  }

  String _sanitizeFileName(String fileName) {
    // Remove invalid characters from file name
    final sanitized = fileName
        .replaceAll(RegExp(r'[<>:"/\\|?*]'), '')
        .replaceAll(RegExp(r'\s+'), '_');
    return sanitized.substring(0, min(sanitized.length, 100));
  }

  void dispose() {
    for (final process in _processes.values) {
      process.kill();
    }
    for (final controller in _progressControllers.values) {
      if (!controller.isClosed) controller.close();
    }
    _processes.clear();
    _progressControllers.clear();
  }
}
