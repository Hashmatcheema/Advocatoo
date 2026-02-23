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

  Future<void> _init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  Future<ProfileData> getProfile() async {
    await _init();
    return ProfileData(
      name: _prefs!.getString(AppConstants.keyProfileName) ?? '',
      barNumber: _prefs!.getString(AppConstants.keyProfileBarNumber) ?? '',
      specialisation: _prefs!.getString(AppConstants.keyProfileSpecialisation) ?? '',
      phone: _prefs!.getString(AppConstants.keyProfilePhone) ?? '',
      email: _prefs!.getString(AppConstants.keyProfileEmail) ?? '',
      photoPath: _prefs!.getString(AppConstants.keyProfilePhotoPath),
    );
  }

  Future<void> saveProfile(ProfileData profile) async {
    await _init();
    await _prefs!.setString(AppConstants.keyProfileName, profile.name);
    await _prefs!.setString(AppConstants.keyProfileBarNumber, profile.barNumber);
    await _prefs!.setString(AppConstants.keyProfileSpecialisation, profile.specialisation);
    await _prefs!.setString(AppConstants.keyProfilePhone, profile.phone);
    await _prefs!.setString(AppConstants.keyProfileEmail, profile.email);
    if (profile.photoPath != null) {
      await _prefs!.setString(AppConstants.keyProfilePhotoPath, profile.photoPath!);
    } else {
      await _prefs!.remove(AppConstants.keyProfilePhotoPath);
    }
  }
}
