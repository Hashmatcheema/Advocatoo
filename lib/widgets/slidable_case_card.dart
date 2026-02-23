import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

/// Case card with swipe Edit (start) and Delete (end) actions.
/// Use in Home case list (Increment 2).
class SlidableCaseCard extends StatelessWidget {
  const SlidableCaseCard({
    super.key,
    required this.title,
    this.subtitle,
    required this.onEdit,
    required this.onDelete,
    required this.child,
  });

  final String title;
  final String? subtitle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: ValueKey(title),
      startActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (_) => onEdit(),
            icon: Icons.edit,
            label: 'Edit',
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ],
      ),
      endActionPane: ActionPane(
        motion: const BehindMotion(),
        children: [
          SlidableAction(
            onPressed: (_) => onDelete(),
            icon: Icons.delete,
            label: 'Delete',
            backgroundColor: Theme.of(context).colorScheme.error,
            foregroundColor: Theme.of(context).colorScheme.onError,
          ),
        ],
      ),
      child: child,
    );
  }
}
