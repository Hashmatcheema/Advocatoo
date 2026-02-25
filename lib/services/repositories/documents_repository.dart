import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../database/app_database.dart';

abstract class DocumentsRepository {
  Future<int> insertDocumentFolder(DocumentFoldersCompanion folder);
  Future<bool> updateDocumentFolder(DocumentFolder folder);
  Future<int> deleteDocumentFolder(DocumentFolder folder);
  Future<DocumentFolder?> getDocumentFolderById(int id);
  Stream<List<DocumentFolder>> watchDocumentFoldersForCase(int caseId);
  Future<List<DocumentFolder>> getDocumentFoldersForCase(int caseId);

  Future<int> insertDocumentImage(DocumentImagesCompanion image);
  Future<bool> updateDocumentImage(DocumentImage image);
  Future<int> deleteDocumentImage(DocumentImage image);
  Future<DocumentImage?> getDocumentImageById(int id);
  Stream<List<DocumentImage>> watchDocumentImagesForFolder(int folderId);
  Future<List<DocumentImage>> getDocumentImagesForFolder(int folderId);
  Future<int> countImagesInFolder(int folderId);
}

class DriftDocumentsRepository implements DocumentsRepository {
  final AppDatabase _db;
  DriftDocumentsRepository(this._db);

  @override
  Future<int> insertDocumentFolder(DocumentFoldersCompanion folder) => _db.insertDocumentFolder(folder);

  @override
  Future<bool> updateDocumentFolder(DocumentFolder folder) => _db.updateDocumentFolder(folder);

  @override
  Future<int> deleteDocumentFolder(DocumentFolder folder) => _db.deleteDocumentFolder(folder);

  @override
  Future<DocumentFolder?> getDocumentFolderById(int id) => _db.getDocumentFolderById(id);

  @override
  Stream<List<DocumentFolder>> watchDocumentFoldersForCase(int caseId) => _db.watchDocumentFoldersForCase(caseId);

  @override
  Future<List<DocumentFolder>> getDocumentFoldersForCase(int caseId) => _db.getDocumentFoldersForCase(caseId);

  @override
  Future<int> insertDocumentImage(DocumentImagesCompanion image) => _db.insertDocumentImage(image);

  @override
  Future<bool> updateDocumentImage(DocumentImage image) => _db.updateDocumentImage(image);

  @override
  Future<int> deleteDocumentImage(DocumentImage image) => _db.deleteDocumentImage(image);

  @override
  Future<DocumentImage?> getDocumentImageById(int id) => _db.getDocumentImageById(id);

  @override
  Stream<List<DocumentImage>> watchDocumentImagesForFolder(int folderId) => _db.watchDocumentImagesForFolder(folderId);

  @override
  Future<List<DocumentImage>> getDocumentImagesForFolder(int folderId) => _db.getDocumentImagesForFolder(folderId);

  @override
  Future<int> countImagesInFolder(int folderId) => _db.countImagesInFolder(folderId);
}

final documentsRepositoryProvider = Provider<DocumentsRepository>((ref) {
  return DriftDocumentsRepository(AppDatabase.instance);
});
