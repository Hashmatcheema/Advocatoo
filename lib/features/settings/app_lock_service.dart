import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';

import '../../app/settings/app_settings.dart';

class AppLockService {
  AppLockService(this._ref);
  final Ref _ref;
  final LocalAuthentication _auth = LocalAuthentication();

  /// Attempts to authenticate the user if App Lock is enabled.
  /// Returns `true` if authentication is successful or not required.
  Future<bool> authenticate() async {
    // Disabled on web
    if (kIsWeb) return true;

    final settings = _ref.read(appSettingsProvider);
    if (!settings.appLockEnabled) return true;

    try {
      final canAuthenticate = await _auth.canCheckBiometrics || await _auth.isDeviceSupported();
      if (!canAuthenticate) return true; // If device doesn't support it, allow access

      return await _auth.authenticate(
        localizedReason: 'Please authenticate to access Advocatoo',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false,
        ),
      );
    } catch (e) {
      debugPrint('AppLock error: $e');
      return false; // Fail secure if authentication fails or throws
    }
  }
}

final appLockServiceProvider = Provider((ref) => AppLockService(ref));
