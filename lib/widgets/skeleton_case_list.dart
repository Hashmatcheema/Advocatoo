import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// Case list wrapped in Skeletonizer; shows 6 placeholder cards when loading.
/// Use in Home when DB is initializing (Increment 2).
class SkeletonCaseList extends StatelessWidget {
  const SkeletonCaseList({
    super.key,
    required this.isLoading,
    required this.cases,
    this.onTapCase,
  });

  final bool isLoading;
  final List<String> cases;
  final void Function(int index)? onTapCase;

  @override
  Widget build(BuildContext context) {
    final data = isLoading
        ? List.generate(6, (_) => 'Case Title')
        : cases;

    return Skeletonizer(
      enabled: isLoading,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: data.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(data[index]),
              subtitle: const Text('Next hearing: DD/MM/YYYY'),
              trailing: const Icon(Icons.chevron_right),
              onTap: isLoading ? null : () => onTapCase?.call(index),
            ),
          );
        },
      ),
    );
  }
}
