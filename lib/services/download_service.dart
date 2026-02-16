import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import '../models/download_task.dart';

class DownloadService {
  final Dio _dio = Dio();
  final Map<String, CancelToken> _cancelTokens = {};
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
      final cancelToken = CancelToken();
      _cancelTokens[task.id] = cancelToken;

      // Get download directory
      final directory = await _getDownloadDirectory();
      final fileName = _sanitizeFileName(task.title);
      final filePath = '${directory.path}/$fileName.${task.format}';

      // Update task to downloading status
      var updatedTask = task.copyWith(
        status: DownloadStatus.downloading,
        savePath: filePath,
      );
      controller.add(updatedTask);

      // Simulate download progress (in real app, use yt-dlp or dio download)
      await _simulateDownload(updatedTask, controller, cancelToken);

    } catch (e) {
      final errorTask = task.copyWith(
        status: DownloadStatus.failed,
        errorMessage: e.toString(),
      );
      controller.add(errorTask);
      controller.close();
    } finally {
      _cancelTokens.remove(task.id);
      _progressControllers.remove(task.id);
    }
  }

  Future<void> _simulateDownload(
    DownloadTask task,
    StreamController<DownloadTask> controller,
    CancelToken cancelToken,
  ) async {
    const totalBytes = 50000000; // 50 MB mock size
    var downloadedBytes = 0;
    
    while (downloadedBytes < totalBytes && !cancelToken.isCancelled) {
      await Future.delayed(const Duration(milliseconds: 100));
      
      downloadedBytes += 500000; // 500 KB per iteration
      if (downloadedBytes > totalBytes) downloadedBytes = totalBytes;
      
      final progress = downloadedBytes / totalBytes;
      final speed = 5000000.0; // 5 MB/s mock speed
      final remainingBytes = totalBytes - downloadedBytes;
      final eta = (remainingBytes / speed).ceil();
      
      final updatedTask = task.copyWith(
        progress: progress,
        downloadedBytes: downloadedBytes,
        totalBytes: totalBytes,
        speed: speed,
        eta: '${eta}s',
      );
      
      controller.add(updatedTask);
    }
    
    if (!cancelToken.isCancelled) {
      final completedTask = task.copyWith(
        status: DownloadStatus.completed,
        progress: 1.0,
        downloadedBytes: totalBytes,
        totalBytes: totalBytes,
        completedAt: DateTime.now(),
      );
      controller.add(completedTask);
    }
    
    controller.close();
  }

  Future<void> pauseDownload(String taskId) async {
    final cancelToken = _cancelTokens[taskId];
    if (cancelToken != null && !cancelToken.isCancelled) {
      cancelToken.cancel('Paused by user');
    }
  }

  Future<void> cancelDownload(String taskId) async {
    final cancelToken = _cancelTokens[taskId];
    if (cancelToken != null && !cancelToken.isCancelled) {
      cancelToken.cancel('Cancelled by user');
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
      return getDownloadsDirectory() ?? await getApplicationDocumentsDirectory();
    }
  }

  String _sanitizeFileName(String fileName) {
    // Remove invalid characters from file name
    return fileName
        .replaceAll(RegExp(r'[<>:"/\\|?*]'), '')
        .replaceAll(RegExp(r'\s+'), '_')
        .substring(0, fileName.length > 100 ? 100 : fileName.length);
  }

  void dispose() {
    for (final token in _cancelTokens.values) {
      if (!token.isCancelled) {
        token.cancel();
      }
    }
    for (final controller in _progressControllers.values) {
      controller.close();
    }
    _cancelTokens.clear();
    _progressControllers.clear();
  }
}
