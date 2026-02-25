import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../database/app_database.dart';
import '../../utils/constants.dart';
import '../case/case_detail_screen.dart';
import 'add_edit_hearing_screen.dart';

/// Hearing detail: view, edit, delete.
class HearingDetailScreen extends StatefulWidget {
  const HearingDetailScreen({
    super.key,
    required this.hearingId,
    required this.caseId,
    this.onDeleted,
  });

  final int hearingId;
  final int caseId;
  final VoidCallback? onDeleted;

  @override
  State<HearingDetailScreen> createState() => _HearingDetailScreenState();
}

class _HearingDetailScreenState extends State<HearingDetailScreen> {
  Hearing? _hearing;
  String? _caseTitle;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final db = AppDatabase.instance;
    final h = await db.getHearingById(widget.hearingId);
    final c = await db.getCaseById(widget.caseId);
    if (mounted) {
      setState(() {
        _hearing = h;
        _caseTitle = c?.title;
        _loading = false;
      });
    }
  }

  Future<void> _edit() async {
    await Navigator.of(context).push(
      MaterialPageRoute<bool>(
        builder: (_) => AddEditHearingScreen(
          caseId: widget.caseId,
          hearingId: widget.hearingId,
          onSaved: _load,
        ),
      ),
    );
    if (mounted) _load();
  }

  Future<void> _delete() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete hearing?'),
        content: const Text(
          'This will permanently delete this hearing. This cannot be undone.',
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
    if (confirm != true || _hearing == null) return;
    await AppDatabase.instance.deleteHearing(_hearing!);
    if (mounted) {
      widget.onDeleted?.call();
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Hearing')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    if (_hearing == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Hearing')),
        body: const Center(child: Text('Hearing not found')),
      );
    }
    final h = _hearing!;
    final dateStr = h.hearingDate.length >= 10
        ? DateFormat(AppConstants.dateFormatPattern).format(
            DateTime.parse(h.hearingDate),
          )
        : h.hearingDate;
    String timeStr = '—';
    if (h.hearingTime != null && h.hearingTime!.length >= 5) {
      final parts = h.hearingTime!.split(':');
      if (parts.length >= 2) {
        final hour = int.tryParse(parts[0]) ?? 0;
        final minute = int.tryParse(parts[1]) ?? 0;
        timeStr = TimeOfDay(hour: hour, minute: minute).format(context);
      }
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hearing'),
        actions: [
          IconButton(
            onPressed: _edit,
            icon: const Icon(Icons.edit),
            tooltip: 'Edit',
          ),
          IconButton(
            onPressed: _delete,
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Delete',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (_caseTitle != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Text(
                _caseTitle!,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          _row('Date', dateStr),
          _row('Time', timeStr),
          _row('Purpose', h.purpose ?? '—'),
          if (h.outcome != null && h.outcome!.isNotEmpty) _row('Outcome', h.outcome!),
          if (h.notes != null && h.notes!.isNotEmpty) _row('Notes', h.notes!),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => CaseDetailScreen(caseId: widget.caseId),
                ),
              );
            },
            icon: const Icon(Icons.folder_open_rounded),
            label: const Text('View Case Details'),
          ),
        ],
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
