import 'package:flutter/material.dart';
import '../../../models/video_info.dart';
import '../../../core/theme/app_colors.dart';

class QualitySelector extends StatelessWidget {
  final List<VideoQuality> qualities;
  final String? selectedQuality;
  final Function(String) onSelected;

  const QualitySelector({
    super.key,
    required this.qualities,
    this.selectedQuality,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quality',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: qualities.map((quality) {
            final isSelected = quality.label == selectedQuality;
            return ChoiceChip(
              label: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(quality.label),
                  if (quality.fileSize != null)
                    Text(
                      quality.fileSize!,
                      style: TextStyle(
                        fontSize: 10,
                        color: isSelected
                            ? Colors.white70
                            : Theme.of(context).textTheme.bodySmall?.color,
                      ),
                    ),
                ],
              ),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  onSelected(quality.label);
                }
              },
              selectedColor: AppColors.accentPurple,
              backgroundColor: Theme.of(context).cardColor,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : null,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
