import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// Document image grid with skeleton loading state (Increment 4: wire to folder images).
class DocumentGridSkeleton extends StatelessWidget {
  const DocumentGridSkeleton({
    super.key,
    required this.isLoading,
    required this.itemCount,
    required this.itemBuilder,
  });

  final bool isLoading;
  final int itemCount;
  final Widget Function(BuildContext context, int index) itemBuilder;

  @override
  Widget build(BuildContext context) {
    final count = isLoading ? 12 : itemCount;
    return Skeletonizer(
      enabled: isLoading,
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 1,
        ),
        itemCount: count,
        itemBuilder: (context, index) {
          if (isLoading) {
            return Container(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
            );
          }
          return itemBuilder(context, index);
        },
      ),
    );
  }
}
