import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/download_task.dart';
import '../services/download_service.dart';

final downloadServiceProvider = Provider((ref) => DownloadService());

class DownloadNotifier extends StateNotifier<List<DownloadTask>> {
  final DownloadService _service;

  DownloadNotifier(this._service) : super([]);

  void startDownload(DownloadTask task) {
    state = [...state, task];

    _service.downloadVideo(task).listen(
      (updatedTask) {
        state = [
          for (final t in state)
            if (t.id == updatedTask.id) updatedTask else t,
        ];
      },
      onError: (Object error) {
        state = [
          for (final t in state)
            if (t.id == task.id)
              t.copyWith(
                status: DownloadStatus.failed,
                errorMessage: error.toString(),
              )
            else
              t,
        ];
      },
    );
  }

  Future<void> pauseDownload(String taskId) async {
    await _service.pauseDownload(taskId);
    state = [
      for (final t in state)
        if (t.id == taskId) t.copyWith(status: DownloadStatus.paused) else t,
    ];
  }

  Future<void> cancelDownload(String taskId) async {
    await _service.cancelDownload(taskId);
    state = state.where((t) => t.id != taskId).toList();
  }

  void clearCompleted() {
    state = state.where((t) => t.status != DownloadStatus.completed).toList();
  }
}

final downloadNotifierProvider =
    StateNotifierProvider<DownloadNotifier, List<DownloadTask>>(
  (ref) {
    final service = ref.watch(downloadServiceProvider);
    ref.onDispose(service.dispose);
    return DownloadNotifier(service);
  },
);
