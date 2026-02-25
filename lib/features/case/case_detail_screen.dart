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

class _CaseDetailScreenState extends State<CaseDetailScreen> with SingleTickerProviderStateMixin {
  Case? _case;
  Court? _court;
  bool _loading = true;
  late TabController _tabController;

  final Set<int> _selectedHearingIds = {};
  final Set<int> _selectedFolderIds = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          _selectedHearingIds.clear();
          _selectedFolderIds.clear();
        });
      }
    });
    _load();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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

  void _deleteSelectedHearings() async {
    if (_selectedHearingIds.isEmpty) return;
    for (final id in _selectedHearingIds) {
      final h = await AppDatabase.instance.getHearingById(id);
      if (h != null) await AppDatabase.instance.deleteHearing(h);
    }
    setState(() => _selectedHearingIds.clear());
  }

  void _deleteSelectedFolders() async {
    if (_selectedFolderIds.isEmpty) return;
    for (final id in _selectedFolderIds) {
      final f = await AppDatabase.instance.getDocumentFolderById(id);
      if (f != null) await AppDatabase.instance.deleteDocumentFolder(f);
    }
    setState(() => _selectedFolderIds.clear());
  }

  PreferredSizeWidget _buildAppBar(Case c) {
    if (_tabController.index == 1 && _selectedHearingIds.isNotEmpty) {
      return AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => setState(() => _selectedHearingIds.clear()),
        ),
        title: Text('${_selectedHearingIds.length} Selected'),
        actions: [
          IconButton(icon: const Icon(Icons.star_outline), onPressed: () {}),
          IconButton(icon: const Icon(Icons.delete), onPressed: _deleteSelectedHearings),
        ],
        bottom: _buildTabBar(),
      );
    }

    if (_tabController.index == 2 && _selectedFolderIds.isNotEmpty) {
      return AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => setState(() => _selectedFolderIds.clear()),
        ),
        title: Text('${_selectedFolderIds.length} Selected'),
        actions: [
          IconButton(icon: const Icon(Icons.star_outline), onPressed: () {}),
          IconButton(icon: const Icon(Icons.delete), onPressed: _deleteSelectedFolders),
        ],
        bottom: _buildTabBar(),
      );
    }

    return AppBar(
      title: Text(c.title),
      bottom: _buildTabBar(),
      actions: _tabController.index == 0
          ? [
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
            ]
          : null,
    );
  }

  TabBar _buildTabBar() {
    return TabBar(
      controller: _tabController,
      tabs: const [
        Tab(text: 'Overview'),
        Tab(text: 'Hearings'),
        Tab(text: 'Documents'),
      ],
    );
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
        ? DateFormat(AppConstants.dateFormatPattern).format(DateTime.parse(c.dateFiled!))
        : '—';

    return Scaffold(
      appBar: _buildAppBar(c),
      body: TabBarView(
        controller: _tabController,
        children: [
          _overviewTab(c, dateFiledStr),
          _hearingsTab(),
          _documentsTab(),
        ],
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
        ]),
        _section('Court', [
          _row('Court', _court?.name ?? '—'),
          _row('Level', _court?.hierarchy ?? '—'),
          _row('City', _court?.city ?? '—'),
          _row('Bench', c.bench ?? '—'),
          _row('Courtroom', c.courtroomNumber ?? '—'),
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
        // Sort descending: newest dates at the top
        list.sort((a, b) => b.hearingDate.compareTo(a.hearingDate));

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Align(
                alignment: Alignment.center,
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
            if (list.isNotEmpty && _selectedHearingIds.isEmpty)
               TextButton(
                 onPressed: () {
                   setState(() {
                     _selectedHearingIds.addAll(list.map((e) => e.id));
                   });
                 },
                 child: const Text('Select All'),
               ),
            Expanded(
              child: list.isEmpty
                  ? const Center(
                      child: Text('No hearings yet. Tap Add Hearing to add one.'),
                    )
                  : ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      children: list.map((h) => _hearingTile(h)).toList(),
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
                alignment: Alignment.center,
                child: FilledButton.icon(
                  onPressed: () => _showNewFolderDialog(),
                  icon: const Icon(Icons.create_new_folder),
                  label: const Text('New folder'),
                ),
              ),
            ),
            if (folders.isNotEmpty && _selectedFolderIds.isEmpty)
               TextButton(
                 onPressed: () {
                   setState(() {
                     _selectedFolderIds.addAll(folders.map((e) => e.id));
                   });
                 },
                 child: const Text('Select All'),
               ),
            Expanded(
              child: folders.isEmpty
                  ? const Center(
                      child: Text('No document folders yet. Tap New folder to add one.'),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      itemCount: folders.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final folder = folders[index];
                        final isSelected = _selectedFolderIds.contains(folder.id);
                        return FutureBuilder<int>(
                          future: AppDatabase.instance.countImagesInFolder(folder.id),
                          builder: (context, countSnap) {
                            final count = countSnap.data ?? 0;
                            return Card(
                              color: isSelected ? Theme.of(context).colorScheme.primaryContainer : null,
                              child: ListTile(
                                leading: const Icon(Icons.folder_outlined),
                                title: Text(folder.name),
                                subtitle: Text(count == 1 ? '1 image' : '$count images'),
                                trailing: isSelected ? const Icon(Icons.check_circle) : const Icon(Icons.chevron_right),
                                onLongPress: () {
                                  setState(() {
                                    if (isSelected) {
                                      _selectedFolderIds.remove(folder.id);
                                    } else {
                                      _selectedFolderIds.add(folder.id);
                                    }
                                  });
                                },
                                onTap: () {
                                  if (_selectedFolderIds.isNotEmpty) {
                                    setState(() {
                                      if (isSelected) {
                                        _selectedFolderIds.remove(folder.id);
                                      } else {
                                        _selectedFolderIds.add(folder.id);
                                      }
                                    });
                                    return;
                                  }
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
        ? DateFormat(AppConstants.dateFormatPattern).format(DateTime.parse(h.hearingDate))
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
    
    final isSelected = _selectedHearingIds.contains(h.id);
    
    return Card(
      color: isSelected ? Theme.of(context).colorScheme.primaryContainer : null,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(h.purpose ?? 'Hearing'),
        subtitle: Text('$dateStr • $timeStr'),
        trailing: isSelected ? const Icon(Icons.check_circle) : const Icon(Icons.chevron_right),
        onLongPress: () {
          setState(() {
            if (isSelected) {
              _selectedHearingIds.remove(h.id);
            } else {
              _selectedHearingIds.add(h.id);
            }
          });
        },
        onTap: () async {
          if (_selectedHearingIds.isNotEmpty) {
            setState(() {
              if (isSelected) {
                _selectedHearingIds.remove(h.id);
              } else {
                _selectedHearingIds.add(h.id);
              }
            });
            return;
          }
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
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 8),
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Theme.of(context).colorScheme.outlineVariant.withAlpha(80)),
              color: Theme.of(context).colorScheme.surfaceContainerLowest,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: rows,
            ),
          ),
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
