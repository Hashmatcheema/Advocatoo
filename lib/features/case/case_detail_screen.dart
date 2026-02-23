import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../database/app_database.dart';
import '../../utils/constants.dart';
import '../documents/document_folder_screen.dart';
import '../hearings/add_edit_hearing_screen.dart';
import '../hearings/hearing_detail_screen.dart';
import 'add_edit_case_screen.dart';

/// Case Detail with Overview tab. Edit opens AddEditCaseScreen; Delete with confirmation.
class CaseDetailScreen extends StatefulWidget {
  const CaseDetailScreen({super.key, required this.caseId});

  final int caseId;

  @override
  State<CaseDetailScreen> createState() => _CaseDetailScreenState();
}

class _CaseDetailScreenState extends State<CaseDetailScreen> {
  Case? _case;
  Court? _court;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final c = await AppDatabase.instance.getCaseById(widget.caseId);
    Court? court;
    if (c?.courtId != null) {
      court = await AppDatabase.instance.getCourtById(c!.courtId!);
    }
    if (mounted) {
      setState(() {
        _case = c;
        _court = court;
        _loading = false;
      });
    }
  }

  Future<void> _edit() async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => AddEditCaseScreen(
          caseId: widget.caseId,
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
        title: const Text('Delete case?'),
        content: const Text(
          'This will permanently delete the case and any related hearings and documents. This cannot be undone.',
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
    if (confirm != true || _case == null) return;
    await AppDatabase.instance.deleteCase(_case!);
    if (mounted) Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Case')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    if (_case == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Case')),
        body: const Center(child: Text('Case not found')),
      );
    }
    final c = _case!;
    final dateFiledStr = c.dateFiled != null && c.dateFiled!.isNotEmpty
        ? DateFormat(AppConstants.dateFormatPattern)
            .format(DateTime.parse(c.dateFiled!))
        : '—';

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(c.title),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Overview'),
              Tab(text: 'Hearings'),
              Tab(text: 'Documents'),
            ],
          ),
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
        body: TabBarView(
          children: [
            _overviewTab(c, dateFiledStr),
            _hearingsTab(),
            _documentsTab(),
          ],
        ),
      ),
    );
  }

  Widget _overviewTab(Case c, String dateFiledStr) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _section('Case', [
          _row('Title', c.title),
          _row('Type', c.caseType ?? '—'),
          _row('Status', c.status),
          _row('Registration number', c.registrationNumber ?? '—'),
          _row('Date filed', dateFiledStr),
          if (c.notes != null && c.notes!.isNotEmpty) _row('Notes', c.notes!),
        ]),
        _section('Client', [
          _row('Name', c.clientName ?? '—'),
          _row('Contact', c.clientPhone ?? '—'),
          _row('CNIC', c.clientCnic ?? '—'),
          _row('Address', c.clientAddress ?? '—'),
        ]),
        _section('Court', [
          _row('Court', _court?.name ?? '—'),
          _row('Level', _court?.hierarchy ?? '—'),
          _row('City', _court?.city ?? '—'),
          _row('Bench', c.bench ?? '—'),
          _row('Courtroom', c.courtroomNumber ?? '—'),
        ]),
        _section('Opposite party', [
          _row('Party', c.oppositeParty ?? '—'),
          _row('Counsel', c.oppositeCounsel ?? '—'),
        ]),
      ],
    );
  }

  Widget _hearingsTab() {
    return StreamBuilder<List<Hearing>>(
      stream: AppDatabase.instance.watchHearingsForCase(widget.caseId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final list = snapshot.data ?? [];
        final now = DateTime.now();
        final todayStr =
            '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
        final past = list.where((h) => h.hearingDate.compareTo(todayStr) < 0).toList()
          ..sort((a, b) => b.hearingDate.compareTo(a.hearingDate));
        final upcoming = list.where((h) => h.hearingDate.compareTo(todayStr) >= 0).toList()
          ..sort((a, b) => a.hearingDate.compareTo(b.hearingDate));
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: FilledButton.icon(
                  onPressed: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute<bool>(
                        builder: (_) => AddEditHearingScreen(
                          caseId: widget.caseId,
                          onSaved: () => setState(() {}),
                        ),
                      ),
                    );
                    if (mounted) setState(() {});
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add Hearing'),
                ),
              ),
            ),
            Expanded(
              child: list.isEmpty
                  ? const Center(
                      child: Text('No hearings yet. Tap Add Hearing to add one.'),
                    )
                  : ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      children: [
                        if (upcoming.isNotEmpty) ...[
                          Text(
                            'Upcoming',
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          const SizedBox(height: 8),
                          ...upcoming.map((h) => _hearingTile(h)),
                          const SizedBox(height: 16),
                        ],
                        if (past.isNotEmpty) ...[
                          Text(
                            'Past',
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          const SizedBox(height: 8),
                          ...past.map((h) => _hearingTile(h)),
                        ],
                      ],
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _documentsTab() {
    return StreamBuilder<List<DocumentFolder>>(
      stream: AppDatabase.instance.watchDocumentFoldersForCase(widget.caseId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final folders = snapshot.data ?? [];
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: FilledButton.icon(
                  onPressed: () => _showNewFolderDialog(),
                  icon: const Icon(Icons.create_new_folder),
                  label: const Text('New folder'),
                ),
              ),
            ),
            Expanded(
              child: folders.isEmpty
                  ? const Center(
                      child: Text(
                        'No document folders yet. Tap New folder to add one.',
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: folders.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final folder = folders[index];
                        return FutureBuilder<int>(
                          future: AppDatabase.instance
                              .countImagesInFolder(folder.id),
                          builder: (context, countSnap) {
                            final count = countSnap.data ?? 0;
                            return Card(
                              child: ListTile(
                                leading: const Icon(Icons.folder_outlined),
                                title: Text(folder.name),
                                subtitle: Text(
                                  count == 1
                                      ? '1 image'
                                      : '$count images',
                                ),
                                trailing: const Icon(Icons.chevron_right),
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute<void>(
                                      builder: (_) => DocumentFolderScreen(
                                        folderId: folder.id,
                                        folderName: folder.name,
                                        caseId: widget.caseId,
                                      ),
                                    ),
                                  ).then((_) {
                                    if (mounted) setState(() {});
                                  });
                                },
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showNewFolderDialog() async {
    final controller = TextEditingController();
    final name = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('New folder'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Folder name',
            hintText: 'e.g. Evidence, Contracts',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, controller.text.trim()),
            child: const Text('Create'),
          ),
        ],
      ),
    );
    if (name != null && name.isNotEmpty && mounted) {
      await AppDatabase.instance.insertDocumentFolder(
        DocumentFoldersCompanion.insert(
          caseId: widget.caseId,
          name: name,
          createdAt: DateTime.now().toIso8601String(),
        ),
      );
      setState(() {});
    }
  }

  Widget _hearingTile(Hearing h) {
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
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(h.purpose ?? 'Hearing'),
        subtitle: Text('$dateStr • $timeStr'),
        trailing: const Icon(Icons.chevron_right),
        onTap: () async {
          await Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => HearingDetailScreen(
                hearingId: h.id,
                caseId: widget.caseId,
                onDeleted: () => setState(() {}),
              ),
            ),
          );
          if (mounted) setState(() {});
        },
      ),
    );
  }

  Widget _section(String title, List<Widget> rows) {
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
          const SizedBox(height: 8),
          ...rows,
        ],
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
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
