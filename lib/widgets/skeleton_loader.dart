import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SkeletonLoader extends StatelessWidget {
  final double? width;
  final double height;
  final BorderRadius? borderRadius;

  const SkeletonLoader({
    super.key,
    this.width,
    required this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Shimmer.fromColors(
      baseColor: isDark ? Colors.grey[800]! : Colors.grey[300]!,
      highlightColor: isDark ? Colors.grey[700]! : Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: borderRadius ?? BorderRadius.circular(8),
        ),
      ),
    );
  }
}

class SkeletonVideoCard extends StatelessWidget {
  const SkeletonVideoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SkeletonLoader(
              height: 200,
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            const SizedBox(height: 12),
            const SkeletonLoader(
              height: 20,
              width: double.infinity,
              borderRadius: BorderRadius.all(Radius.circular(4)),
            ),
            const SizedBox(height: 8),
            SkeletonLoader(
              height: 16,
              width: MediaQuery.of(context).size.width * 0.6,
              borderRadius: const BorderRadius.all(Radius.circular(4)),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const SkeletonLoader(
                  height: 40,
                  width: 100,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                const SizedBox(width: 8),
                const SkeletonLoader(
                  height: 40,
                  width: 100,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
