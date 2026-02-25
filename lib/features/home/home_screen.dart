import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';

import '../../database/app_database.dart';
import '../../utils/constants.dart';
import '../../widgets/feedback_overlay.dart';
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
  Timer? _debounce;

  static const _caseTypes = ['Civil', 'Criminal', 'Family', 'Corporate'];
  static const _courtLevels = ['District Court', 'High Court', 'Supreme Court'];

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String _) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        leading: Center(
          child: Tooltip(
            message: 'Profile',
            child: IconButton(
              onPressed: widget.onProfileTap,
              icon: CircleAvatar(
                radius: 16,
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: Icon(
                  Icons.person,
                  size: 18,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
          ),
        ),
        title: Text(
          'Advocato',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
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
                      return _buildRefreshableList(filtered);
                    },
                  );
                }
                return _buildRefreshableList(list);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRefreshableList(List<Case> list) {
    if (list.isEmpty) return _emptyState();
    return RefreshIndicator(
      onRefresh: () async {
        // Force stream to re-evaluate by briefly waiting.
        await Future.delayed(const Duration(milliseconds: 300));
        if (mounted) setState(() {});
      },
      child: _caseList(list),
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
            onChanged: _onSearchChanged,
            trailing: [
              if (_searchController.text.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.clear, size: 20),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {});
                  },
                ),
            ],
            padding: const WidgetStatePropertyAll<EdgeInsets>(
              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _dropdownChip(
                label: _filterCaseType ?? 'Type',
                selected: _filterCaseType != null,
                colorScheme: colorScheme,
                onClear: () => setState(() => _filterCaseType = null),
                items: _caseTypes
                    .map((t) => PopupMenuItem(value: t, child: Text(t)))
                    .toList(),
                onSelected: (v) => setState(() => _filterCaseType = v),
              ),
              _dropdownChip(
                label: _filterStatus ?? 'Status',
                selected: _filterStatus != null,
                colorScheme: colorScheme,
                onClear: () => setState(() => _filterStatus = null),
                items: const [
                  PopupMenuItem(value: 'Active', child: Text('Active')),
                  PopupMenuItem(value: 'Closed', child: Text('Closed')),
                ],
                onSelected: (v) => setState(() => _filterStatus = v),
              ),
              _dropdownChip(
                label: _filterCourtLevel ?? 'Court',
                selected: _filterCourtLevel != null,
                colorScheme: colorScheme,
                onClear: () => setState(() => _filterCourtLevel = null),
                items: _courtLevels
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

  /// Builds a filter chip that acts as a dropdown trigger with a visible arrow.
  Widget _dropdownChip({
    required String label,
    required bool selected,
    required ColorScheme colorScheme,
    required VoidCallback onClear,
    required List<PopupMenuEntry<String>> items,
    required ValueChanged<String> onSelected,
  }) {
    return PopupMenuButton<String>(
      onSelected: onSelected,
      itemBuilder: (_) => items,
      child: Chip(
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label),
            const SizedBox(width: 2),
            Icon(Icons.arrow_drop_down, size: 18, color: selected ? colorScheme.onSecondaryContainer : colorScheme.onSurfaceVariant),
          ],
        ),
        backgroundColor: selected ? colorScheme.secondaryContainer : null,
        side: selected ? BorderSide.none : BorderSide(color: colorScheme.outline.withAlpha(120)),
        deleteIcon: selected
            ? Icon(Icons.close, size: 16, color: colorScheme.onSecondaryContainer)
            : null,
        onDeleted: selected ? onClear : null,
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.work_outline_rounded,
              size: 80,
              color: Theme.of(context).colorScheme.primary.withAlpha(100),
            )
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .scaleXY(begin: 1.0, end: 1.06, duration: 1800.ms, curve: Curves.easeInOut),
            const SizedBox(height: 20),
            Text(
              'No cases yet',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap the + button below to add your first case\nand start managing your legal practice.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.05, end: 0, duration: 400.ms),
      ),
    );
  }

  Widget _caseList(List<Case> list) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: list.length,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final c = list[index];
        return _CaseCardItem(
          caseRow: c,
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
          onDelete: () => _deleteCase(c),
        )
            .animate()
            .fadeIn(duration: 200.ms, delay: (index * 40).ms)
            .slideY(begin: 0.06, end: 0, duration: 220.ms, curve: Curves.easeOut);
      },
    );
  }

  Future<void> _deleteCase(Case c) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete case?'),
        content: const Text(
          'This will permanently delete the case and all its hearings and documents.',
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
      if (mounted) {
        showSuccessFeedback(context, 'Case "${c.title}" deleted');
        setState(() {});
      }
    }
  }
}

/// Individual case card with real-time next hearing + document count.
class _CaseCardItem extends StatelessWidget {
  const _CaseCardItem({
    required this.caseRow,
    required this.onEdit,
    required this.onDelete,
  });

  final Case caseRow;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final db = AppDatabase.instance;
    final c = caseRow;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return StreamBuilder<List<Hearing>>(
      stream: db.watchHearingsForCase(c.id),
      builder: (context, hearingSnap) {
        return StreamBuilder<List<DocumentFolder>>(
          stream: db.watchDocumentFoldersForCase(c.id),
          builder: (context, docSnap) {
            final hearings = hearingSnap.data ?? [];
            final docCount = docSnap.data?.length ?? 0;

            // Compute next hearing.
            final today = DateTime.now();
            final todayStr =
                '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
            final upcoming = hearings
                .where((h) => h.hearingDate.compareTo(todayStr) >= 0)
                .toList()
              ..sort((a, b) => a.hearingDate.compareTo(b.hearingDate));
            final nextHearing = upcoming.isNotEmpty ? upcoming.first : null;

            String subtitle;
            if (nextHearing != null) {
              try {
                final date = DateTime.parse(nextHearing.hearingDate);
                subtitle = 'Next: ${DateFormat(AppConstants.dateFormatPattern).format(date)}';
                if (nextHearing.purpose != null && nextHearing.purpose!.isNotEmpty) {
                  subtitle += ' • ${nextHearing.purpose}';
                }
              } catch (_) {
                subtitle = 'Next: ${nextHearing.hearingDate}';
              }
            } else {
              subtitle = 'No upcoming hearings';
            }

            return SlidableCaseCard(
              title: c.title,
              subtitle: subtitle,
              onEdit: onEdit,
              onDelete: onDelete,
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => CaseDetailScreen(caseId: c.id),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(16),
                child: Card(
                  elevation: 0.5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                c.title,
                                style: textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (c.caseType != null && c.caseType!.isNotEmpty)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: _typeColor(c.caseType!, colorScheme),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  c.caseType!,
                                  style: textTheme.labelSmall?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(Icons.event_rounded, size: 14, color: colorScheme.onSurfaceVariant),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                subtitle,
                                style: textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (docCount > 0) ...[
                              const SizedBox(width: 8),
                              Icon(Icons.folder_outlined, size: 14, color: colorScheme.onSurfaceVariant),
                              const SizedBox(width: 3),
                              Text(
                                '$docCount',
                                style: textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ],
                        ),
                        if (c.clientName != null && c.clientName!.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.person_outline_rounded, size: 14, color: colorScheme.onSurfaceVariant),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  c.clientName!,
                                  style: textTheme.bodySmall?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Color _typeColor(String type, ColorScheme cs) {
    switch (type) {
      case 'Civil':
        return cs.primary;
      case 'Criminal':
        return const Color(0xFFC62828);
      case 'Family':
        return const Color(0xFF6A1B9A);
      case 'Corporate':
        return const Color(0xFF00695C);
      default:
        return cs.tertiary;
    }
  }
}
