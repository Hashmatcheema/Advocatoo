import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

bool profileHasPhoto(String? path) =>
    path != null && path.isNotEmpty && File(path).existsSync();

ImageProvider? profileImageProvider(String? path) {
  if (path == null || path.isEmpty || !File(path).existsSync()) return null;
  return FileImage(File(path));
}

Future<String?> profileSavePickedFile(String sourcePath) async {
  if (sourcePath.isEmpty) return null;
  final dir = await getApplicationDocumentsDirectory();
  final profileDir = Directory(p.join(dir.path, 'advocatoo', 'profile'));
  if (!await profileDir.exists()) await profileDir.create(recursive: true);
  final destPath = p.join(
      profileDir.path, 'avatar_${DateTime.now().millisecondsSinceEpoch}.jpg');
  await File(sourcePath).copy(destPath);
  return destPath;
}
