import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:advocatoo/database/app_database.dart';

void main() {
  setUp(() {
    AppDatabase.initForTest(NativeDatabase.memory());
  });

  test('insert case then insert document folder', () async {
    final db = AppDatabase.instance;
    final caseId = await db.insertCase(CasesCompanion.insert(
      title: 'Test Case',
      createdAt: DateTime.now().toIso8601String(),
      updatedAt: DateTime.now().toIso8601String(),
    ));
    final folderId = await db.insertDocumentFolder(DocumentFoldersCompanion.insert(
      caseId: caseId,
      name: 'Evidence',
      createdAt: DateTime.now().toIso8601String(),
    ));
    expect(folderId, greaterThan(0));
    final list = await db.getDocumentFoldersForCase(caseId);
    expect(list.length, 1);
    expect(list.first.name, 'Evidence');
  });

  test('getDocumentFoldersForCase returns folders for case', () async {
    final db = AppDatabase.instance;
    final caseId = await db.insertCase(CasesCompanion.insert(
      title: 'Test',
      createdAt: DateTime.now().toIso8601String(),
      updatedAt: DateTime.now().toIso8601String(),
    ));
    expect(await db.getDocumentFoldersForCase(caseId), isEmpty);
    await db.insertDocumentFolder(DocumentFoldersCompanion.insert(
      caseId: caseId,
      name: 'Folder A',
      createdAt: DateTime.now().toIso8601String(),
    ));
    final list2 = await db.getDocumentFoldersForCase(caseId);
    expect(list2.length, 1);
    expect(list2.first.name, 'Folder A');
  });

  test('insert document images and get by folder with sortOrder', () async {
    final db = AppDatabase.instance;
    final caseId = await db.insertCase(CasesCompanion.insert(
      title: 'Test',
      createdAt: DateTime.now().toIso8601String(),
      updatedAt: DateTime.now().toIso8601String(),
    ));
    final folderId = await db.insertDocumentFolder(DocumentFoldersCompanion.insert(
      caseId: caseId,
      name: 'Photos',
      createdAt: DateTime.now().toIso8601String(),
    ));
    final now = DateTime.now().toIso8601String();
    await db.insertDocumentImage(DocumentImagesCompanion.insert(
      folderId: folderId,
      filePath: '/path/a.jpg',
      sortOrder: const Value(1),
      addedAt: now,
    ));
    await db.insertDocumentImage(DocumentImagesCompanion.insert(
      folderId: folderId,
      filePath: '/path/b.jpg',
      sortOrder: const Value(0),
      addedAt: now,
    ));
    final images = await db.getDocumentImagesForFolder(folderId);
    expect(images.length, 2);
    expect(images[0].sortOrder, 0);
    expect(images[0].filePath, '/path/b.jpg');
    expect(images[1].filePath, '/path/a.jpg');
    final count = await db.countImagesInFolder(folderId);
    expect(count, 2);
  });

  test('updateDocumentFolder rename', () async {
    final db = AppDatabase.instance;
    final caseId = await db.insertCase(CasesCompanion.insert(
      title: 'Test',
      createdAt: DateTime.now().toIso8601String(),
      updatedAt: DateTime.now().toIso8601String(),
    ));
    final folderId = await db.insertDocumentFolder(DocumentFoldersCompanion.insert(
      caseId: caseId,
      name: 'Old Name',
      createdAt: DateTime.now().toIso8601String(),
    ));
    final folder = await db.getDocumentFolderById(folderId);
    expect(folder, isNot(null));
    await db.updateDocumentFolder(folder!.copyWith(name: 'New Name'));
    final updated = await db.getDocumentFolderById(folderId);
    expect(updated!.name, 'New Name');
  });

  test('delete document folder removes folder', () async {
    final db = AppDatabase.instance;
    final caseId = await db.insertCase(CasesCompanion.insert(
      title: 'Test',
      createdAt: DateTime.now().toIso8601String(),
      updatedAt: DateTime.now().toIso8601String(),
    ));
    final folderId = await db.insertDocumentFolder(DocumentFoldersCompanion.insert(
      caseId: caseId,
      name: 'To Delete',
      createdAt: DateTime.now().toIso8601String(),
    ));
    await db.insertDocumentImage(DocumentImagesCompanion.insert(
      folderId: folderId,
      filePath: '/x/y.jpg',
      addedAt: DateTime.now().toIso8601String(),
    ));
    expect(await db.countImagesInFolder(folderId), 1);
    final folder = await db.getDocumentFolderById(folderId);
    expect(folder, isNot(null));
    await db.deleteDocumentFolder(folder!);
    expect(await db.getDocumentFolderById(folderId), equals(null));
  });
}
