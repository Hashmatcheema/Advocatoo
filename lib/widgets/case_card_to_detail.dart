import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

/// Case card that opens Case Detail with container transform (animations package).
/// Use in Home case list (Increment 2).
class CaseCardToDetail extends StatelessWidget {
  const CaseCardToDetail({
    super.key,
    required this.title,
    this.subtitle = 'Next hearing: DD/MM/YYYY • District Court',
    required this.detailBuilder,
  });

  final String title;
  final String? subtitle;
  final WidgetBuilder detailBuilder;

  @override
  Widget build(BuildContext context) {
    return OpenContainer<void>(
      transitionType: ContainerTransitionType.fadeThrough,
      transitionDuration: const Duration(milliseconds: 350),
      closedColor: Theme.of(context).colorScheme.surface,
      openColor: Theme.of(context).colorScheme.surface,
      closedElevation: 0,
      openElevation: 0,
      closedBuilder: (context, open) {
        return InkWell(
          onTap: open,
          borderRadius: BorderRadius.circular(16),
          child: Card(
            elevation: 0.5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              title: Text(title),
              subtitle: Text(subtitle ?? ''),
              trailing: const Icon(Icons.chevron_right),
            ),
          ),
        );
      },
      openBuilder: (context, _) => detailBuilder(context),
    );
  }
}
