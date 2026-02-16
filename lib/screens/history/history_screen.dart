import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/download_history.dart';
import '../../services/storage_service.dart';
import 'widgets/history_item.dart';

final storageServiceProvider = Provider((ref) => StorageService());

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  List<DownloadHistory> _history = [];
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    setState(() => _isLoading = true);
    final service = ref.read(storageServiceProvider);
    await service.init();
    final history = await service.getHistory();
    setState(() {
      _history = history;
      _isLoading = false;
    });
  }

  List<DownloadHistory> get _filteredHistory {
    if (_searchQuery.isEmpty) return _history;
    return _history.where((item) {
      return item.title.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredItems = _filteredHistory;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Download History'),
        actions: [
          if (_history.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              onPressed: _showClearHistoryDialog,
              tooltip: 'Clear all history',
            ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          if (_history.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Search downloads...',
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (value) {
                  setState(() => _searchQuery = value);
                },
              ),
            ),
          
          // Content
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredItems.isEmpty
                    ? _buildEmptyState()
                    : RefreshIndicator(
                        onRefresh: _loadHistory,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: filteredItems.length,
                          itemBuilder: (context, index) {
                            final item = filteredItems[index];
                            return HistoryItem(
                              item: item,
                              onOpen: () => _openFile(item),
                              onOpenFolder: () => _openFolder(item),
                              onDelete: () => _deleteItem(item),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    if (_searchQuery.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 80,
              color: Theme.of(context).textTheme.bodySmall?.color,
            ),
            const SizedBox(height: 16),
            Text(
              'No results found',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
            ),
          ],
        ),
      );
    }
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 80,
            color: Theme.of(context).textTheme.bodySmall?.color,
          ),
          const SizedBox(height: 16),
          Text(
            'No download history',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Completed downloads will appear here',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _openFile(DownloadHistory item) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening ${item.title}'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _openFolder(DownloadHistory item) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening folder for ${item.title}'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _deleteItem(DownloadHistory item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Download'),
        content: const Text('Are you sure you want to remove this item from history?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final service = ref.read(storageServiceProvider);
      await service.deleteFromHistory(item.id);
      await _loadHistory();
    }
  }

  Future<void> _showClearHistoryDialog() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear History'),
        content: const Text('Are you sure you want to clear all download history?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final service = ref.read(storageServiceProvider);
      await service.clearHistory();
      await _loadHistory();
    }
  }
}
