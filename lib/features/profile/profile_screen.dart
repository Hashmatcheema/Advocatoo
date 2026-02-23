import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../services/profile_service.dart';
import '../../utils/constants.dart';
import 'profile_photo_io.dart' if (dart.library.html) 'profile_photo_stub.dart' as photo;

/// Profile screen: photo, name, bar number, specialisation, contact (Increment 6).
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameController = TextEditingController();
  final _barNumberController = TextEditingController();
  final _specialisationController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  bool _loading = true;
  String? _photoPath;
  final _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _barNumberController.dispose();
    _specialisationController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final profile = await ProfileService.instance.getProfile();
    if (mounted) {
      setState(() {
        _nameController.text = profile.name;
        _barNumberController.text = profile.barNumber;
        _specialisationController.text = profile.specialisation;
        _phoneController.text = profile.phone;
        _emailController.text = profile.email;
        _photoPath = profile.photoPath;
        _loading = false;
      });
    }
  }

  Future<void> _pickPhoto() async {
    if (kIsWeb) return;
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () => Navigator.pop(ctx, ImageSource.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () => Navigator.pop(ctx, ImageSource.camera),
            ),
          ],
        ),
      ),
    );
    if (source == null || !mounted) return;
    final XFile? file = await _imagePicker.pickImage(source: source, imageQuality: 85);
    if (file == null || !mounted) return;
    final path = await photo.profileSavePickedFile(file.path);
    if (mounted && path != null) setState(() => _photoPath = path);
  }

  Future<void> _save() async {
    final profile = ProfileData(
      name: _nameController.text.trim(),
      barNumber: _barNumberController.text.trim(),
      specialisation: _specialisationController.text.trim(),
      phone: _phoneController.text.trim(),
      email: _emailController.text.trim(),
      photoPath: _photoPath,
    );
    await ProfileService.instance.saveProfile(profile);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile saved')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Profile')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          TextButton(
            onPressed: _save,
            child: const Text('Save'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppConstants.screenPadding),
        children: [
          const SizedBox(height: 16),
          Center(
            child: GestureDetector(
              onTap: _pickPhoto,
              child: CircleAvatar(
                radius: 48,
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                backgroundImage: photo.profileImageProvider(_photoPath),
                child: !photo.profileHasPhoto(_photoPath)
                    ? Icon(
                        Icons.person,
                        size: 48,
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                      )
                    : null,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              'Tap to change photo',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Full name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _barNumberController,
            decoration: const InputDecoration(
              labelText: 'Bar Council enrollment number',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _specialisationController,
            decoration: const InputDecoration(
              labelText: 'Specialisation (e.g. Criminal, Civil)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _phoneController,
            decoration: const InputDecoration(
              labelText: 'Phone',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _save,
            child: const Text('Save profile'),
          ),
        ],
      ),
    );
  }
}
