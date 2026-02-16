import 'package:flutter/material.dart';
import '../../models/download_task.dart';
import 'widgets/download_tile.dart';

class DownloadsScreen extends StatefulWidget {
  const DownloadsScreen({super.key});

  @override
  State<DownloadsScreen> createState() => _DownloadsScreenState();
}

class _DownloadsScreenState extends State<DownloadsScreen> {
  final List<DownloadTask> _activeTasks = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Active Downloads'),
        actions: [
          if (_activeTasks.isNotEmpty)
            TextButton.icon(
              onPressed: _clearCompleted,
              icon: const Icon(Icons.clear_all),
              label: const Text('Clear Completed'),
            ),
        ],
      ),
      body: _activeTasks.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _activeTasks.length,
              itemBuilder: (context, index) {
                final task = _activeTasks[index];
                return DownloadTile(
                  task: task,
                  onPause: () => _pauseDownload(task),
                  onResume: () => _resumeDownload(task),
                  onCancel: () => _cancelDownload(task),
                );
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.download_done,
            size: 80,
            color: Theme.of(context).textTheme.bodySmall?.color,
          ),
          const SizedBox(height: 16),
          Text(
            'No active downloads',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Downloads will appear here when you start them',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _pauseDownload(DownloadTask task) {
    setState(() {
      final index = _activeTasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        _activeTasks[index] = task.copyWith(status: DownloadStatus.paused);
      }
    });
  }

  void _resumeDownload(DownloadTask task) {
    setState(() {
      final index = _activeTasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        _activeTasks[index] = task.copyWith(status: DownloadStatus.downloading);
      }
    });
  }

  void _cancelDownload(DownloadTask task) {
    setState(() {
      _activeTasks.removeWhere((t) => t.id == task.id);
    });
  }

  void _clearCompleted() {
    setState(() {
      _activeTasks.removeWhere((t) => t.status == DownloadStatus.completed);
    });
  }
}
