import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../database/app_database.dart';
import '../../widgets/case_card_to_detail.dart';
import '../../widgets/skeleton_case_list.dart';
import '../../widgets/slidable_case_card.dart';
import '../case/add_edit_case_screen.dart';
import '../case/case_detail_screen.dart';

/// Home tab: case list with search, filter, FAB. Uses DB stream for reactive list.
class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.onProfileTap,
    required this.onDashboardTap,
    required this.onAddCase,
    this.largeText = false,
  });

  final VoidCallback onProfileTap;
  final VoidCallback onDashboardTap;
  final VoidCallback onAddCase;
  final bool largeText;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();
  String? _filterCaseType;
  String? _filterCourtLevel;
  String? _filterStatus;

  static const _caseTypes = ['Civil', 'Criminal', 'Family', 'Corporate'];
  static const _courtLevels = ['District Court', 'High Court', 'Supreme Court'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openAddCase() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const AddEditCaseScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Center(
          child: IconButton(
            onPressed: widget.onProfileTap,
            icon: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              child: Icon(
                Icons.person,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
            tooltip: 'Profile',
          ),
        ),
        title: Text(
          'Advocato',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: widget.onDashboardTap,
            icon: const Icon(Icons.dashboard_outlined),
            tooltip: 'Dashboard',
          ),
        ],
      ),
      body: Column(
        children: [
          _searchAndFilterBar(),
          Expanded(
            child: StreamBuilder<List<Case>>(
              stream: AppDatabase.instance.watchAllCases(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return SkeletonCaseList(
                    isLoading: true,
                    cases: const [],
                  );
                }
                var list = snapshot.data!;
                final query = _searchController.text.trim().toLowerCase();
                if (query.isNotEmpty) {
                  list = list
                      .where((c) => c.title.toLowerCase().contains(query))
                      .toList();
                }
                if (_filterCaseType != null) {
                  list = list.where((c) => c.caseType == _filterCaseType).toList();
                }
                if (_filterStatus != null) {
                  list = list.where((c) => c.status == _filterStatus).toList();
                }
                if (_filterCourtLevel != null) {
                  return FutureBuilder<List<Case>>(
                    future: _filterByCourtLevel(list),
                    builder: (ctx, asyncSnap) {
                      final filtered = asyncSnap.data ?? list;
                      return _caseList(filtered);
                    },
                  );
                }
                return _caseList(list);
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<List<Case>> _filterByCourtLevel(List<Case> list) async {
    if (_filterCourtLevel == null) return list;
    final courtIds =
        await AppDatabase.instance.getCourtIdsByHierarchy(_filterCourtLevel!);
    return list
        .where((c) => c.courtId != null && courtIds.contains(c.courtId))
        .toList();
  }

  Widget _searchAndFilterBar() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          SearchBar(
            controller: _searchController,
            hintText: 'Search by title',
            leading: const Icon(Icons.search),
            onChanged: (_) => setState(() {}),
            padding: const WidgetStatePropertyAll<EdgeInsets>(
              EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              PopupMenuButton<String>(
                child: FilterChip(
                  label: Text(_filterCaseType ?? 'Type'),
                  selected: _filterCaseType != null,
                  onSelected: (selected) {
                    if (!selected) setState(() => _filterCaseType = null);
                  },
                  selectedColor: colorScheme.secondaryContainer,
                  checkmarkColor: colorScheme.onSecondaryContainer,
                  deleteIcon: _filterCaseType != null
                      ? Icon(Icons.close, size: 18, color: colorScheme.onSecondaryContainer)
                      : null,
                  onDeleted: _filterCaseType != null
                      ? () => setState(() => _filterCaseType = null)
                      : null,
                ),
                itemBuilder: (_) => _caseTypes
                    .map((t) => PopupMenuItem(value: t, child: Text(t)))
                    .toList(),
                onSelected: (v) => setState(() => _filterCaseType = v),
              ),
              PopupMenuButton<String>(
                child: FilterChip(
                  label: Text(_filterStatus ?? 'Status'),
                  selected: _filterStatus != null,
                  onSelected: (selected) {
                    if (!selected) setState(() => _filterStatus = null);
                  },
                  selectedColor: colorScheme.secondaryContainer,
                  checkmarkColor: colorScheme.onSecondaryContainer,
                  deleteIcon: _filterStatus != null
                      ? Icon(Icons.close, size: 18, color: colorScheme.onSecondaryContainer)
                      : null,
                  onDeleted: _filterStatus != null
                      ? () => setState(() => _filterStatus = null)
                      : null,
                ),
                itemBuilder: (_) => [
                  const PopupMenuItem(value: 'Active', child: Text('Active')),
                  const PopupMenuItem(value: 'Closed', child: Text('Closed')),
                ],
                onSelected: (v) => setState(() => _filterStatus = v),
              ),
              PopupMenuButton<String>(
                child: FilterChip(
                  label: Text(_filterCourtLevel ?? 'Court'),
                  selected: _filterCourtLevel != null,
                  onSelected: (selected) {
                    if (!selected) setState(() => _filterCourtLevel = null);
                  },
                  selectedColor: colorScheme.secondaryContainer,
                  checkmarkColor: colorScheme.onSecondaryContainer,
                  deleteIcon: _filterCourtLevel != null
                      ? Icon(Icons.close, size: 18, color: colorScheme.onSecondaryContainer)
                      : null,
                  onDeleted: _filterCourtLevel != null
                      ? () => setState(() => _filterCourtLevel = null)
                      : null,
                ),
                itemBuilder: (_) => _courtLevels
                    .map((t) => PopupMenuItem(value: t, child: Text(t)))
                    .toList(),
                onSelected: (v) => setState(() => _filterCourtLevel = v),
              ),
            ],
          ).animate().fadeIn(duration: 180.ms),
        ],
      ),
    );
  }

  Widget _caseList(List<Case> list) {
    if (list.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.folder_open,
                size: 64,
                color: Theme.of(context).colorScheme.outline,
              ),
              const SizedBox(height: 16),
              Text(
                'No cases yet.',
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                'Add your first case to get started.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                textAlign: TextAlign.center,
              ),
              
            ],
          ),
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final c = list[index];
        const subtitle = 'Next hearing: — • —';
        return SizedBox(
          key: ValueKey(c.id),
          child: SlidableCaseCard(
            title: c.title,
            subtitle: subtitle,
            onEdit: () async {
              await Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => AddEditCaseScreen(
                    caseId: c.id,
                    onSaved: () => setState(() {}),
                  ),
                ),
              );
            },
            onDelete: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Delete case?'),
                  content: const Text(
                    'This will permanently delete the case. This cannot be undone.',
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
              if (confirm == true) {
                await AppDatabase.instance.deleteCase(c);
                if (mounted) setState(() {});
              }
            },
            child: CaseCardToDetail(
              title: c.title,
              subtitle: subtitle,
              detailBuilder: (_) => CaseDetailScreen(caseId: c.id),
            ),
          ),
        )
            .animate()
            .fadeIn(duration: 200.ms, delay: (index * 45).ms)
            .slideY(begin: 0.08, end: 0, duration: 220.ms, curve: Curves.easeOut);
      },
    );
  }
}
