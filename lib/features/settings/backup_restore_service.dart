import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../database/app_database.dart';

class BackupRestoreService {
  BackupRestoreService(this._db);
  final AppDatabase _db;

  Future<String> _buildBackupJson() async {
    final courts = await _db.select(_db.courts).get();
    final cases = await _db.select(_db.cases).get();
    final hearings = await _db.select(_db.hearings).get();
    final folders = await _db.select(_db.documentFolders).get();
    final images = await _db.select(_db.documentImages).get();

    final data = {
      'version': 1,
      'courts': courts.map((e) => e.toJson()).toList(),
      'cases': cases.map((e) => e.toJson()).toList(),
      'hearings': hearings.map((e) => e.toJson()).toList(),
      'documentFolders': folders.map((e) => e.toJson()).toList(),
      'documentImages': images.map((e) => e.toJson()).toList(),
    };

    return jsonEncode(data);
  }

  Future<String?> exportBackup() async {
    try {
      final jsonStr = await _buildBackupJson();

      if (kIsWeb) {
        return null; // file_picker's saveFile isn't supported on web in the same way, rely on shareBackup
      }

      final path = await FilePicker.platform.saveFile(
        dialogTitle: 'Save Backup',
        fileName: 'advocatoo_backup_${DateTime.now().millisecondsSinceEpoch}.json',
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (path != null) {
        await File(path).writeAsString(jsonStr);
        return path;
      }
    } catch (e) {
      debugPrint('Export error: $e');
    }
    return null;
  }

  Future<bool> shareBackup() async {
    try {
      final jsonStr = await _buildBackupJson();
      if (kIsWeb) {
        // On web, share_plus uses Web Share API, or text sharing if files not supported
        await Share.share(jsonStr, subject: 'Advocatoo Backup.json');
      } else {
        // Save to temp dir, then share file
        final tempDir = Directory.systemTemp;
        final tempFile = File('${tempDir.path}/advocatoo_backup.json');
        await tempFile.writeAsString(jsonStr);
        await Share.shareXFiles([XFile(tempFile.path)], subject: 'Advocatoo Backup');
      }
      return true;
    } catch (e) {
      debugPrint('Share error: $e');
      return false;
    }
  }

  Future<bool> importBackup() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
        withData: kIsWeb, // Important for web
      );

      if (result == null) return false;

      String jsonStr;
      if (kIsWeb) {
        jsonStr = utf8.decode(result.files.single.bytes!);
      } else {
        final path = result.files.single.path!;
        jsonStr = await File(path).readAsString();
      }

      final data = jsonDecode(jsonStr) as Map<String, dynamic>;
      
      await _db.transaction(() async {
        // Note: this approach replaces data if IDs match or inserts new.
        if (data['courts'] != null) {
          for (var c in data['courts']) {
            await _db.into(_db.courts).insert(Court.fromJson(c).toCompanion(true), mode: InsertMode.replace);
          }
        }
        if (data['cases'] != null) {
          for (var c in data['cases']) {
            await _db.into(_db.cases).insert(Case.fromJson(c).toCompanion(true), mode: InsertMode.replace);
          }
        }
        if (data['hearings'] != null) {
          for (var h in data['hearings']) {
            await _db.into(_db.hearings).insert(Hearing.fromJson(h).toCompanion(true), mode: InsertMode.replace);
          }
        }
        if (data['documentFolders'] != null) {
          for (var f in data['documentFolders']) {
            await _db.into(_db.documentFolders).insert(DocumentFolder.fromJson(f).toCompanion(true), mode: InsertMode.replace);
          }
        }
        if (data['documentImages'] != null) {
          for (var i in data['documentImages']) {
            await _db.into(_db.documentImages).insert(DocumentImage.fromJson(i).toCompanion(true), mode: InsertMode.replace);
          }
        }
      });
      return true;
    } catch (e) {
      debugPrint('Import error: $e');
    }
    return false;
  }
}

final backupRestoreServiceProvider = Provider((ref) => BackupRestoreService(AppDatabase.instance));
