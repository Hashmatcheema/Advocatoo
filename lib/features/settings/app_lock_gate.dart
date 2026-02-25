import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/settings/app_settings.dart';
import 'app_lock_service.dart';

class AppLockGate extends ConsumerStatefulWidget {
  const AppLockGate({super.key, required this.child});
  final Widget child;

  @override
  ConsumerState<AppLockGate> createState() => _AppLockGateState();
}

class _AppLockGateState extends ConsumerState<AppLockGate> with WidgetsBindingObserver {
  bool _isLocked = true;
  bool _isAuthenticating = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkLock();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // Always lock when backgrounding if setting is enabled
      final settings = ref.read(appSettingsProvider);
      if (settings.appLockEnabled) {
        setState(() => _isLocked = true);
      }
    } else if (state == AppLifecycleState.resumed) {
      if (_isLocked && !_isAuthenticating) {
        _checkLock();
      }
    }
  }

  Future<void> _checkLock() async {
    if (_isAuthenticating) return;
    
    // Fast path: if completely disabled, unlock immediately
    final settings = ref.read(appSettingsProvider);
    if (!settings.appLockEnabled) {
      if (mounted) {
        setState(() {
          _isLocked = false;
        });
      }
      return;
    }

    setState(() => _isAuthenticating = true);

    final service = ref.read(appLockServiceProvider);
    final success = await service.authenticate();

    if (mounted) {
      setState(() {
        _isAuthenticating = false;
        _isLocked = !success;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // If setting is disabled, always allow through
    final settings = ref.watch(appSettingsProvider);
    if (!settings.appLockEnabled) {
      return widget.child;
    }

    if (_isLocked) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock_outline, size: 64, color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 24),
              Text('App Locked', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 24),
              if (!_isAuthenticating)
                FilledButton.icon(
                  onPressed: _checkLock,
                  icon: const Icon(Icons.fingerprint),
                  label: const Text('Unlock'),
                )
              else
                const CircularProgressIndicator(),
            ],
          ),
        ),
      );
    }
    return widget.child;
  }
}
