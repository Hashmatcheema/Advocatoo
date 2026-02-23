import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../database/app_database.dart';
import '../../utils/constants.dart';

/// Full-screen Add/Edit Case modal. Title required; Cancel confirms if dirty.
class AddEditCaseScreen extends StatefulWidget {
  const AddEditCaseScreen({
    super.key,
    this.caseId,
    this.onSaved,
  });

  final int? caseId;
  final VoidCallback? onSaved;

  @override
  State<AddEditCaseScreen> createState() => _AddEditCaseScreenState();
}

class _AddEditCaseScreenState extends State<AddEditCaseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _regNumberController = TextEditingController();
  final _benchController = TextEditingController();
  final _courtroomController = TextEditingController();
  final _clientNameController = TextEditingController();
  final _clientPhoneController = TextEditingController();
  final _clientCnicController = TextEditingController();
  final _clientAddressController = TextEditingController();
  final _oppositePartyController = TextEditingController();
  final _oppositeCounselController = TextEditingController();
  final _notesController = TextEditingController();

  String? _caseType;
  String _status = 'Active';
  DateTime? _dateFiled;
  String? _courtHierarchy;
  int? _courtId;
  List<Court> _courts = [];
  bool _isLoading = true;
  bool _dirty = false;

  static const _caseTypes = ['Civil', 'Criminal', 'Family', 'Corporate'];
  static const _hierarchies = ['District Court', 'High Court', 'Supreme Court'];

  @override
  void initState() {
    super.initState();
    _loadCourts();
    if (widget.caseId != null) _loadCase();
  }

  Future<void> _loadCourts() async {
    final list = await AppDatabase.instance.getAllCourts();
    if (mounted) {
      setState(() {
        _courts = list;
        _isLoading = false;
      });
    }
  }

  Future<void> _loadCase() async {
    final c = await AppDatabase.instance.getCaseById(widget.caseId!);
    if (c == null || !mounted) return;
    _titleController.text = c.title;
    _regNumberController.text = c.registrationNumber ?? '';
    _benchController.text = c.bench ?? '';
    _courtroomController.text = c.courtroomNumber ?? '';
    _clientNameController.text = c.clientName ?? '';
    _clientPhoneController.text = c.clientPhone ?? '';
    _clientCnicController.text = c.clientCnic ?? '';
    _clientAddressController.text = c.clientAddress ?? '';
    _oppositePartyController.text = c.oppositeParty ?? '';
    _oppositeCounselController.text = c.oppositeCounsel ?? '';
    _notesController.text = c.notes ?? '';
    _caseType = c.caseType;
    _status = c.status;
    _courtId = c.courtId;
    if (c.dateFiled != null && c.dateFiled!.isNotEmpty) {
      _dateFiled = DateTime.tryParse(c.dateFiled!);
    }
    final court = _courtId != null
        ? await AppDatabase.instance.getCourtById(_courtId!)
        : null;
    _courtHierarchy = court?.hierarchy;
    setState(() {});
  }

  @override
  void dispose() {
    _titleController.dispose();
    _regNumberController.dispose();
    _benchController.dispose();
    _courtroomController.dispose();
    _clientNameController.dispose();
    _clientPhoneController.dispose();
    _clientCnicController.dispose();
    _clientAddressController.dispose();
    _oppositePartyController.dispose();
    _oppositeCounselController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _markDirty() {
    if (!_dirty) setState(() => _dirty = true);
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dateFiled ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dateFiled = picked;
        _markDirty();
      });
    }
  }

  Future<void> _showAddCourt() async {
    final result = await showDialog<Court>(
      context: context,
      builder: (ctx) => _AddCourtDialog(
        hierarchies: _hierarchies,
        existingCourts: _courts,
      ),
    );
    if (result != null && mounted) {
      setState(() {
        _courts = [..._courts, result];
        _courtId = result.id;
        _courtHierarchy = result.hierarchy;
        _dirty = true;
      });
    }
  }

  Future<void> _save() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Case title is required')),
      );
      return;
    }
    final now = DateTime.now().toIso8601String();
    if (widget.caseId != null) {
      final c = await AppDatabase.instance.getCaseById(widget.caseId!);
      if (c != null) {
        final reg = _regNumberController.text.trim();
        final dateStr = _dateFiled != null ? DateFormat('yyyy-MM-dd').format(_dateFiled!) : null;
        final bench = _benchController.text.trim();
        final room = _courtroomController.text.trim();
        final clientName = _clientNameController.text.trim();
        final clientPhone = _clientPhoneController.text.trim();
        final clientCnic = _clientCnicController.text.trim();
        final clientAddr = _clientAddressController.text.trim();
        final oppParty = _oppositePartyController.text.trim();
        final oppCounsel = _oppositeCounselController.text.trim();
        final notes = _notesController.text.trim();
        await AppDatabase.instance.updateCase(c.copyWith(
          title: title,
          caseType: Value(_caseType),
          status: _status,
          registrationNumber: Value(reg.isEmpty ? null : reg),
          dateFiled: Value(dateStr),
          courtId: Value(_courtId),
          bench: Value(bench.isEmpty ? null : bench),
          courtroomNumber: Value(room.isEmpty ? null : room),
          clientName: Value(clientName.isEmpty ? null : clientName),
          clientPhone: Value(clientPhone.isEmpty ? null : clientPhone),
          clientCnic: Value(clientCnic.isEmpty ? null : clientCnic),
          clientAddress: Value(clientAddr.isEmpty ? null : clientAddr),
          oppositeParty: Value(oppParty.isEmpty ? null : oppParty),
          oppositeCounsel: Value(oppCounsel.isEmpty ? null : oppCounsel),
          notes: Value(notes.isEmpty ? null : notes),
          updatedAt: now,
        ));
      }
    } else {
      final caseId = await AppDatabase.instance.insertCase(CasesCompanion.insert(
        title: title,
        caseType: Value(_caseType),
        status: Value(_status),
        registrationNumber: Value(_regNumberController.text.trim().isEmpty ? null : _regNumberController.text.trim()),
        dateFiled: Value(_dateFiled != null ? DateFormat('yyyy-MM-dd').format(_dateFiled!) : null),
        courtId: Value(_courtId),
        bench: Value(_benchController.text.trim().isEmpty ? null : _benchController.text.trim()),
        courtroomNumber: Value(_courtroomController.text.trim().isEmpty ? null : _courtroomController.text.trim()),
        clientName: Value(_clientNameController.text.trim().isEmpty ? null : _clientNameController.text.trim()),
        clientPhone: Value(_clientPhoneController.text.trim().isEmpty ? null : _clientPhoneController.text.trim()),
        clientCnic: Value(_clientCnicController.text.trim().isEmpty ? null : _clientCnicController.text.trim()),
        clientAddress: Value(_clientAddressController.text.trim().isEmpty ? null : _clientAddressController.text.trim()),
        oppositeParty: Value(_oppositePartyController.text.trim().isEmpty ? null : _oppositePartyController.text.trim()),
        oppositeCounsel: Value(_oppositeCounselController.text.trim().isEmpty ? null : _oppositeCounselController.text.trim()),
        notes: Value(_notesController.text.trim().isEmpty ? null : _notesController.text.trim()),
        createdAt: now,
        updatedAt: now,
      ));
      await AppDatabase.instance.insertActivityLog(ActivityLogCompanion.insert(
        type: 'case_added',
        caseId: Value(caseId),
        title: 'Case "$title" added',
        createdAt: now,
      ));
    }
    if (mounted) {
      widget.onSaved?.call();
      Navigator.of(context).pop();
    }
  }

  Future<void> _cancel() async {
    if (!_dirty) {
      Navigator.of(context).pop();
      return;
    }
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Discard changes?'),
        content: const Text('You have unsaved changes. Discard?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Keep'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Discard'),
          ),
        ],
      ),
    );
    if (ok == true && mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading && widget.caseId != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Edit Case')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.caseId != null ? 'Edit Case' : 'Add Case'),
        actions: [
          TextButton(
            onPressed: _cancel,
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: _save,
            child: const Text('Save'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Form(
        key: _formKey,
        onChanged: _markDirty,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _section('Basic Information', [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Case Title *',
                  hintText: 'Required',
                ),
                onChanged: (_) => _markDirty(),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Title is required' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _caseType,
                decoration: const InputDecoration(labelText: 'Case Type'),
                items: _caseTypes
                    .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                    .toList(),
                onChanged: (v) {
                  setState(() {
                    _caseType = v;
                    _markDirty();
                  });
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _regNumberController,
                decoration: const InputDecoration(
                  labelText: 'Case Registration Number',
                ),
                onChanged: (_) => _markDirty(),
              ),
              const SizedBox(height: 12),
              InkWell(
                onTap: _pickDate,
                child: InputDecorator(
                  decoration: const InputDecoration(labelText: 'Date Filed'),
                  child: Text(
                    _dateFiled != null
                        ? DateFormat(AppConstants.dateFormatPattern)
                            .format(_dateFiled!)
                        : 'Select date',
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'Active', label: Text('Active')),
                  ButtonSegment(value: 'Closed', label: Text('Closed')),
                ],
                selected: {_status},
                onSelectionChanged: (s) {
                  setState(() {
                    _status = s.first;
                    _markDirty();
                  });
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Notes / Description',
                ),
                maxLines: 3,
                onChanged: (_) => _markDirty(),
              ),
            ]),
            _section('Court Details', [
              DropdownButtonFormField<String>(
                initialValue: _courtHierarchy,
                decoration: const InputDecoration(
                  labelText: 'Court Hierarchy Level',
                ),
                items: _hierarchies
                    .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                    .toList(),
                onChanged: (v) {
                  setState(() {
                    _courtHierarchy = v;
                    _courtId = null;
                    _markDirty();
                  });
                },
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      initialValue: _courtId,
                      decoration: const InputDecoration(
                        labelText: 'Court Name',
                      ),
                      items: [
                        const DropdownMenuItem<int>(
                          value: null,
                          child: Text('-- Select --'),
                        ),
                        ..._courts
                            .where((c) =>
                                _courtHierarchy == null ||
                                c.hierarchy == _courtHierarchy)
                            .map((c) => DropdownMenuItem<int>(
                                  value: c.id,
                                  child: Text(c.name),
                                )),
                      ],
                      onChanged: (v) {
                        setState(() {
                          _courtId = v;
                          _markDirty();
                        });
                      },
                    ),
                  ),
                  IconButton(
                    onPressed: _showAddCourt,
                    icon: const Icon(Icons.add),
                    tooltip: 'Add New Court',
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _benchController,
                decoration: const InputDecoration(
                  labelText: 'Bench',
                  hintText: 'Judge/bench name',
                ),
                onChanged: (_) => _markDirty(),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _courtroomController,
                decoration: const InputDecoration(
                  labelText: 'Courtroom Number',
                ),
                onChanged: (_) => _markDirty(),
              ),
            ]),
            _section('Client Details', [
              TextFormField(
                controller: _clientNameController,
                decoration: const InputDecoration(labelText: 'Client Name'),
                onChanged: (_) => _markDirty(),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _clientPhoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Client Contact Number',
                ),
                onChanged: (_) => _markDirty(),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _clientCnicController,
                decoration: const InputDecoration(
                  labelText: 'Client CNIC',
                  hintText: 'XXXXX-XXXXXXX-X',
                ),
                onChanged: (_) => _markDirty(),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _clientAddressController,
                decoration: const InputDecoration(
                  labelText: 'Client Address',
                ),
                maxLines: 2,
                onChanged: (_) => _markDirty(),
              ),
            ]),
            _section('Opposite Party', [
              TextFormField(
                controller: _oppositePartyController,
                decoration: const InputDecoration(
                  labelText: 'Opposite Party Name',
                ),
                onChanged: (_) => _markDirty(),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _oppositeCounselController,
                decoration: const InputDecoration(
                  labelText: 'Opposite Counsel Name',
                ),
                onChanged: (_) => _markDirty(),
              ),
            ]),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _section(String title, List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}

class _AddCourtDialog extends StatefulWidget {
  const _AddCourtDialog({
    required this.hierarchies,
    required this.existingCourts,
  });

  final List<String> hierarchies;
  final List<Court> existingCourts;

  @override
  State<_AddCourtDialog> createState() => _AddCourtDialogState();
}

class _AddCourtDialogState extends State<_AddCourtDialog> {
  final _nameController = TextEditingController();
  final _cityController = TextEditingController();
  String? _hierarchy;

  @override
  void dispose() {
    _nameController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Court name is required')),
      );
      return;
    }
    if (_hierarchy == null || _hierarchy!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select hierarchy')),
      );
      return;
    }
    final id = await AppDatabase.instance.insertCourt(CourtsCompanion.insert(
      name: name,
      hierarchy: _hierarchy!,
      city: Value(_cityController.text.trim().isEmpty ? null : _cityController.text.trim()),
    ));
    final court = await AppDatabase.instance.getCourtById(id);
    if (court != null && mounted) Navigator.of(context).pop(court);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add New Court'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
