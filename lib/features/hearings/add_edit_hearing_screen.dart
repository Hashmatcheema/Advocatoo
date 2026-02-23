import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../database/app_database.dart';
import '../../utils/constants.dart';

/// Add/Edit Hearing. Validates one hearing per case per day (duplicate date blocked).
class AddEditHearingScreen extends StatefulWidget {
  const AddEditHearingScreen({
    super.key,
    required this.caseId,
    this.hearingId,
    this.onSaved,
  });

  final int caseId;
  final int? hearingId;
  final VoidCallback? onSaved;

  @override
  State<AddEditHearingScreen> createState() => _AddEditHearingScreenState();
}

class _AddEditHearingScreenState extends State<AddEditHearingScreen> {
  static const List<String> _purposes = [
    'Bail',
    'Evidence',
    'Arguments',
    'Summing Up',
    'Judgment',
    'Other',
  ];

  final _formKey = GlobalKey<FormState>();
  final _outcomeController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime? _date;
  TimeOfDay? _time;
  String? _purpose;
  bool _loading = true;
  Hearing? _existing;
  String? _caseTitle;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _outcomeController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final db = AppDatabase.instance;
    final c = await db.getCaseById(widget.caseId);
    if (c != null) _caseTitle = c.title;
    if (widget.hearingId != null) {
      final h = await db.getHearingById(widget.hearingId!);
      if (h != null) {
        _existing = h;
        _date = DateTime.tryParse(h.hearingDate);
        if (h.hearingTime != null && h.hearingTime!.length >= 5) {
          final parts = h.hearingTime!.split(':');
          if (parts.length >= 2) {
            _time = TimeOfDay(
              hour: int.tryParse(parts[0]) ?? 9,
              minute: int.tryParse(parts[1]) ?? 0,
            );
          }
        }
        _purpose = h.purpose;
        _outcomeController.text = h.outcome ?? '';
        _notesController.text = h.notes ?? '';
      }
    }
    if (mounted) setState(() => _loading = false);
  }

  String get _isoDate {
    if (_date == null) return '';
    return '${_date!.year}-${_date!.month.toString().padLeft(2, '0')}-${_date!.day.toString().padLeft(2, '0')}';
  }

  String? get _time24h {
    if (_time == null) return null;
    final h = _time!.hour;
    final m = _time!.minute;
    return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (picked != null && mounted) setState(() => _date = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _time ?? const TimeOfDay(hour: 9, minute: 0),
    );
    if (picked != null && mounted) setState(() => _time = picked);
  }

  Future<void> _save() async {
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    if (_date == null) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Please select a date')),
      );
      return;
    }
    final db = AppDatabase.instance;
    final duplicate = await db.hasHearingOnDate(
      widget.caseId,
      _isoDate,
      excludeHearingId: widget.hearingId,
    );
    if (duplicate) {
      messenger.showSnackBar(
        const SnackBar(
            content: Text('This case already has a hearing on the selected date. Only one hearing per case per day is allowed.')),
      );
      return;
    }
    if (_existing != null) {
      final updated = _existing!.copyWith(
        hearingDate: _isoDate,
        hearingTime: Value(_time24h),
        purpose: Value(_purpose),
        outcome: Value(_outcomeController.text.trim().isEmpty
            ? null
            : _outcomeController.text.trim()),
        notes: Value(_notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim()),
      );
      await db.updateHearing(updated);
    } else {
      final hearingId = await db.insertHearing(HearingsCompanion.insert(
        caseId: widget.caseId,
        hearingDate: _isoDate,
        hearingTime: Value(_time24h),
        purpose: Value(_purpose),
        outcome: Value(_outcomeController.text.trim().isEmpty
            ? null
            : _outcomeController.text.trim()),
        notes: Value(_notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim()),
      ));
      final caseRow = await db.getCaseById(widget.caseId);
      final caseTitle = caseRow?.title ?? 'Case';
      await db.insertActivityLog(ActivityLogCompanion.insert(
        type: 'hearing_added',
        caseId: Value(widget.caseId),
        hearingId: Value(hearingId),
        title: 'Hearing added for $caseTitle — $_isoDate',
        createdAt: DateTime.now().toIso8601String(),
      ));
    }
    if (!mounted) return;
    widget.onSaved?.call();
    navigator.pop(true);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Hearing')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    final isEdit = _existing != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Hearing' : 'Add Hearing'),
        actions: [
          TextButton(
            onPressed: _save,
            child: const Text('Save'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
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
            InkWell(
              onTap: _pickDate,
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Date (DD/MM/YYYY)',
                ),
                child: Text(
                  _date != null
                      ? DateFormat(AppConstants.dateFormatPattern)
                          .format(_date!)
                      : 'Select date',
                ),
              ),
            ),
            const SizedBox(height: 12),
            InkWell(
              onTap: _pickTime,
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Time (12h)',
                ),
                child: Text(
                  _time != null
                      ? _time!.format(context)
                      : 'Select time',
                ),
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _purpose,
              decoration: const InputDecoration(labelText: 'Purpose'),
              items: _purposes
                  .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                  .toList(),
              onChanged: (v) => setState(() => _purpose = v),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _outcomeController,
              decoration: const InputDecoration(
                labelText: 'Outcome (optional)',
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Notes (optional)',
              ),
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }
}
