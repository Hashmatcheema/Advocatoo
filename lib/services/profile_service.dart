import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/constants.dart';

/// Profile data for the advocate (Increment 6). Persisted in SharedPreferences.
class ProfileData {
  const ProfileData({
    this.name = '',
    this.barNumber = '',
    this.specialisation = '',
    this.phone = '',
    this.email = '',
    this.photoPath,
  });

  final String name;
  final String barNumber;
  final String specialisation;
  final String phone;
  final String email;
  final String? photoPath;

  ProfileData copyWith({
    String? name,
    String? barNumber,
    String? specialisation,
    String? phone,
    String? email,
    String? photoPath,
  }) {
    return ProfileData(
      name: name ?? this.name,
      barNumber: barNumber ?? this.barNumber,
      specialisation: specialisation ?? this.specialisation,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      photoPath: photoPath ?? this.photoPath,
    );
  }
}

class ProfileService {
  ProfileService._();
  static final ProfileService _instance = ProfileService._();
  static ProfileService get instance => _instance;

  SharedPreferences? _prefs;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<void> _init() async {
    _prefs ??= await SharedPreferences.getInstance();
    
    // Auto-migration for sensitive fields
    final migrated = _prefs!.getBool('secure_migration_done') ?? false;
    if (!migrated) {
      final oldPhone = _prefs!.getString(AppConstants.keyProfilePhone);
      final oldEmail = _prefs!.getString(AppConstants.keyProfileEmail);
      
      if (oldPhone != null) {
        await _secureStorage.write(key: AppConstants.keyProfilePhone, value: oldPhone);
        await _prefs!.remove(AppConstants.keyProfilePhone);
      }
      if (oldEmail != null) {
        await _secureStorage.write(key: AppConstants.keyProfileEmail, value: oldEmail);
        await _prefs!.remove(AppConstants.keyProfileEmail);
      }
      await _prefs!.setBool('secure_migration_done', true);
    }
  }

  Future<ProfileData> getProfile() async {
    await _init();
    return ProfileData(
      name: _prefs!.getString(AppConstants.keyProfileName) ?? '',
      barNumber: _prefs!.getString(AppConstants.keyProfileBarNumber) ?? '',
      specialisation: _prefs!.getString(AppConstants.keyProfileSpecialisation) ?? '',
      phone: await _secureStorage.read(key: AppConstants.keyProfilePhone) ?? '',
      email: await _secureStorage.read(key: AppConstants.keyProfileEmail) ?? '',
      photoPath: _prefs!.getString(AppConstants.keyProfilePhotoPath),
    );
  }

  Future<void> saveProfile(ProfileData profile) async {
    await _init();
    await _prefs!.setString(AppConstants.keyProfileName, profile.name);
    await _prefs!.setString(AppConstants.keyProfileBarNumber, profile.barNumber);
    await _prefs!.setString(AppConstants.keyProfileSpecialisation, profile.specialisation);
    await _secureStorage.write(key: AppConstants.keyProfilePhone, value: profile.phone);
    await _secureStorage.write(key: AppConstants.keyProfileEmail, value: profile.email);
    if (profile.photoPath != null) {
      await _prefs!.setString(AppConstants.keyProfilePhotoPath, profile.photoPath!);
    } else {
      await _prefs!.remove(AppConstants.keyProfilePhotoPath);
    }
  }
}
