import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class FormatSelector extends StatelessWidget {
  final List<String> formats;
  final String? selectedFormat;
  final Function(String) onSelected;

  const FormatSelector({
    super.key,
    required this.formats,
    this.selectedFormat,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Format',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: formats.map((format) {
            final isSelected = format == selectedFormat;
            return ChoiceChip(
              label: Text(format.toUpperCase()),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  onSelected(format);
                }
              },
              selectedColor: AppColors.accentPurple,
              backgroundColor: Theme.of(context).cardColor,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : null,
              ),
              avatar: Icon(
                _getFormatIcon(format),
                size: 18,
                color: isSelected ? Colors.white : null,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  IconData _getFormatIcon(String format) {
    switch (format.toLowerCase()) {
      case 'mp4':
        return Icons.video_file;
      case 'mkv':
        return Icons.movie;
      case 'webm':
        return Icons.web;
      case 'mp3':
        return Icons.audio_file;
      default:
        return Icons.insert_drive_file;
    }
  }
}
