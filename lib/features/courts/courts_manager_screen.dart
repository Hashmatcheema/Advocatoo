import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../database/app_database.dart';
import '../../widgets/feedback_overlay.dart';

/// Courts Manager: list, add, edit, delete courts. Warns when deleting a court linked to cases.
class CourtsManagerScreen extends StatelessWidget {
  const CourtsManagerScreen({super.key});

  static const List<String> _hierarchies = ['District Court', 'High Court', 'Supreme Court'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Courts Manager'),
      ),
      body: StreamBuilder<List<Court>>(
        stream: AppDatabase.instance.watchCourts(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final courts = snapshot.data ?? [];
          if (courts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.account_balance_outlined, size: 64, color: Theme.of(context).colorScheme.outline),
                  const SizedBox(height: 16),
                  Text('No courts yet', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text('Tap + to add your first court.', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
                ],
              ).animate().fadeIn(duration: 300.ms),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: courts.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final court = courts[index];
              return Card(
                child: ListTile(
                  title: Text(court.name),
                  subtitle: Text(
                    '${court.hierarchy}${court.city != null && court.city!.isNotEmpty ? ' • ${court.city}' : ''}',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit_outlined),
                        tooltip: 'Edit court',
                        onPressed: () => _showAddEditCourtDialog(context, court: court),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline),
                        tooltip: 'Delete court',
                        onPressed: () => _confirmDeleteCourt(context, court),
                      ),
                    ],
                  ),
                ),
              ).animate().fadeIn(duration: 200.ms, delay: (index * 40).ms).slideX(begin: 0.05, end: 0, duration: 200.ms);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEditCourtDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _showAddEditCourtDialog(BuildContext context, {Court? court}) async {
    final result = await showDialog<Court>(
      context: context,
      builder: (ctx) => _AddEditCourtDialog(
        hierarchies: _hierarchies,
        existingCourt: court,
      ),
    );
    if (result != null && context.mounted) {
      showSuccessFeedback(context, court == null ? 'Court added' : 'Court updated');
    }
  }

  Future<void> _confirmDeleteCourt(BuildContext context, Court court) async {
    final count = await AppDatabase.instance.countCasesByCourtId(court.id);
    if (!context.mounted) return;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete court?'),
        content: Text(
          count > 0
              ? 'This court is linked to $count case(s). Deleting it will not remove those cases, but they will no longer show a court. Delete anyway?'
              : 'Delete "${court.name}"? This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirm != true) return;
    await AppDatabase.instance.deleteCourt(court);
    if (context.mounted) {
      showSuccessFeedback(context, 'Court "${court.name}" deleted');
    }
  }
}

class _AddEditCourtDialog extends StatefulWidget {
  const _AddEditCourtDialog({
    required this.hierarchies,
    this.existingCourt,
  });

  final List<String> hierarchies;
  final Court? existingCourt;

  @override
  State<_AddEditCourtDialog> createState() => _AddEditCourtDialogState();
}

class _AddEditCourtDialogState extends State<_AddEditCourtDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _cityController;
  late String? _hierarchy;

  @override
  void initState() {
    super.initState();
    final c = widget.existingCourt;
    _nameController = TextEditingController(text: c?.name ?? '');
    _cityController = TextEditingController(text: c?.city ?? '');
    final saved = c?.hierarchy;
    _hierarchy = saved != null && widget.hierarchies.contains(saved)
        ? saved
        : null;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      showErrorFeedback(context, 'Court name is required');
      return;
    }
    if (_hierarchy == null || _hierarchy!.isEmpty) {
      showErrorFeedback(context, 'Select hierarchy');
      return;
    }
    final db = AppDatabase.instance;
    if (widget.existingCourt != null) {
      final cityVal = _cityController.text.trim();
      final updated = widget.existingCourt!.copyWith(
        name: name,
        hierarchy: _hierarchy!,
        city: Value(cityVal.isEmpty ? null : cityVal),
      );
      await db.updateCourt(updated);
      if (mounted) Navigator.of(context).pop(updated);
    } else {
      final id = await db.insertCourt(CourtsCompanion.insert(
        name: name,
        hierarchy: _hierarchy!,
        city: Value(_cityController.text.trim().isEmpty ? null : _cityController.text.trim()),
      ));
      final court = await db.getCourtById(id);
      if (court != null && mounted) Navigator.of(context).pop(court);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existingCourt != null;
    return AlertDialog(
      title: Text(isEdit ? 'Edit Court' : 'Add New Court'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<String>(
              initialValue: _hierarchy,
              decoration: const InputDecoration(labelText: 'Hierarchy'),
              items: widget.hierarchies
                  .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                  .toList(),
              onChanged: (v) => setState(() => _hierarchy = v),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Court Name'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _cityController,
              decoration: const InputDecoration(labelText: 'City'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _save,
          child: const Text('Save'),
        ),
      ],
    );
  }
}
