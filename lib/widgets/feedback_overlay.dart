import 'package:flutter/material.dart';

/// App-wide operation feedback helpers.
/// Provides styled SnackBars for success, error, info, and undo actions.

/// Show a success feedback SnackBar with a green accent and checkmark icon.
void showSuccessFeedback(BuildContext context, String message) {
  if (!context.mounted) return;
  ScaffoldMessenger.of(context)
    ..clearSnackBars()
    ..showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white, size: 22),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF2E7D32),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        duration: const Duration(seconds: 2),
      ),
    );
}

/// Show an error feedback SnackBar with a red accent and error icon.
void showErrorFeedback(BuildContext context, String message) {
  if (!context.mounted) return;
  ScaffoldMessenger.of(context)
    ..clearSnackBars()
    ..showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_rounded, color: Colors.white, size: 22),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFFC62828),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        duration: const Duration(seconds: 3),
      ),
    );
}

/// Show an info feedback SnackBar with a blue accent and info icon.
void showInfoFeedback(BuildContext context, String message) {
  if (!context.mounted) return;
  ScaffoldMessenger.of(context)
    ..clearSnackBars()
    ..showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.info_rounded, color: Colors.white, size: 22),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF1565C0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        duration: const Duration(seconds: 2),
      ),
    );
}

/// Show an undo SnackBar with an action button. Returns true if undo was tapped.
Future<bool> showUndoFeedback(BuildContext context, String message) async {
  if (!context.mounted) return false;
  bool undone = false;
  ScaffoldMessenger.of(context)
    ..clearSnackBars()
    ..showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.delete_outline, color: Colors.white, size: 22),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        action: SnackBarAction(
          label: 'UNDO',
          textColor: Colors.yellowAccent,
          onPressed: () => undone = true,
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: const Color(0xFF424242),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        duration: const Duration(seconds: 4),
      ),
    );
  // Wait for the snackbar to complete before returning undo status.
  await Future.delayed(const Duration(seconds: 4, milliseconds: 200));
  return undone;
}
