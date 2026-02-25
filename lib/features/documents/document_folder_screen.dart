import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:photo_view/photo_view_gallery.dart';

import '../../database/app_database.dart';

/// Single folder view: grid of images, add (gallery/camera), delete, reorder, export PDF.
class DocumentFolderScreen extends StatefulWidget {
  const DocumentFolderScreen({
    super.key,
    required this.folderId,
    required this.folderName,
    required this.caseId,
  });

  final int folderId;
  final String folderName;
  final int caseId;

  @override
  State<DocumentFolderScreen> createState() => _DocumentFolderScreenState();
}

class _DocumentFolderScreenState extends State<DocumentFolderScreen> {
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.folderName),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (v) {
              if (v == 'rename') {
                _renameFolder();
              } else if (v == 'export') {
                _exportPdf();
              } else if (v == 'delete') {
                _deleteFolder();
              }
            },
            itemBuilder: (_) => [
              const PopupMenuItem(value: 'rename', child: Text('Rename folder')),
              const PopupMenuItem(value: 'export', child: Text('Export as PDF')),
              const PopupMenuItem(
                value: 'delete',
                child: Text('Delete folder', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        ],
      ),
      body: StreamBuilder<List<DocumentImage>>(
        stream: AppDatabase.instance.watchDocumentImagesForFolder(widget.folderId),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final images = snapshot.data ?? [];
          if (images.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.photo_library_outlined, size: 64, color: Theme.of(context).colorScheme.outline),
                  const SizedBox(height: 16),
                  const Text('No images. Add from gallery or camera.'),
                ],
              ),
            );
          }
          return ReorderableListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: images.length,
            onReorder: (oldIndex, newIndex) => _reorder(images, oldIndex, newIndex),
            buildDefaultDragHandles: false,
            itemBuilder: (context, index) {
              final img = images[index];
              return _ImageGridTile(
                key: ValueKey(img.id),
                index: index,
                image: img,
                onDelete: () => _deleteImage(img),
                onTap: () => _openViewer(images, index),
              );
            },
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            onPressed: () => _pickImage(ImageSource.gallery),
            icon: const Icon(Icons.photo_library),
            label: const Text('Gallery'),
          ),
          const SizedBox(height: 8),
          FloatingActionButton.extended(
            onPressed: () => _pickImage(ImageSource.camera),
            icon: const Icon(Icons.camera_alt),
            label: const Text('Camera'),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? file = await _picker.pickImage(source: source, imageQuality: 85);
      if (file == null || !mounted) return;
      final path = file.path;
      if (path.isEmpty) return;
      final dir = await getApplicationDocumentsDirectory();
      final caseDir = Directory(p.join(dir.path, 'advocatoo', 'case_${widget.caseId}', 'folder_${widget.folderId}'));
      if (!await caseDir.exists()) await caseDir.create(recursive: true);
      final name = p.basename(path);
      final dest = File(p.join(caseDir.path, '${DateTime.now().millisecondsSinceEpoch}_$name'));
      await File(path).copy(dest.path);
      final images = await AppDatabase.instance.getDocumentImagesForFolder(widget.folderId);
      final sortOrder = images.isEmpty ? 0 : (images.map((i) => i.sortOrder).reduce((a, b) => a > b ? a : b) + 1);
      await AppDatabase.instance.insertDocumentImage(DocumentImagesCompanion.insert(
        folderId: widget.folderId,
        filePath: dest.path,
        sortOrder: Value(sortOrder),
        addedAt: DateTime.now().toIso8601String(),
      ));
      await AppDatabase.instance.insertActivityLog(ActivityLogCompanion.insert(
        type: 'document_uploaded',
        caseId: Value(widget.caseId),
        title: 'Document added to "${widget.folderName}"',
        createdAt: DateTime.now().toIso8601String(),
      ));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to add image: $e')));
      }
    }
  }

  Future<void> _reorder(List<DocumentImage> images, int oldIndex, int newIndex) async {
    if (newIndex > oldIndex) newIndex--;
    final item = images.removeAt(oldIndex);
    images.insert(newIndex, item);
    final db = AppDatabase.instance;
    for (var i = 0; i < images.length; i++) {
      await db.updateDocumentImage(images[i].copyWith(sortOrder: i));
    }
  }

  Future<void> _deleteImage(DocumentImage image) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete image?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Theme.of(ctx).colorScheme.error),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirm != true) return;
    await AppDatabase.instance.deleteDocumentImage(image);
    try {
      final f = File(image.filePath);
      if (await f.exists()) await f.delete();
    } catch (_) {}
  }

  void _openViewer(List<DocumentImage> images, int index) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => _ImageViewerPage(images: images, initialIndex: index),
      ),
    );
  }

  Future<void> _renameFolder() async {
    final folder = await AppDatabase.instance.getDocumentFolderById(widget.folderId);
    if (folder == null || !mounted) return;
    final controller = TextEditingController(text: folder.name);
    final name = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Rename folder'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Folder name'),
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, controller.text.trim()),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (name != null && name.isNotEmpty && mounted) {
      await AppDatabase.instance.updateDocumentFolder(folder.copyWith(name: name));
      setState(() {});
    }
  }

  Future<void> _deleteFolder() async {
    final navigator = Navigator.of(context);
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete folder?'),
        content: const Text('All images in this folder will be deleted. This cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Theme.of(ctx).colorScheme.error),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirm != true) return;
    final folder = await AppDatabase.instance.getDocumentFolderById(widget.folderId);
    if (folder != null) {
      await AppDatabase.instance.deleteDocumentFolder(folder);
      if (mounted) navigator.pop();
    }
  }

  Future<void> _exportPdf() async {
    final messenger = ScaffoldMessenger.of(context);
    final images = await AppDatabase.instance.getDocumentImagesForFolder(widget.folderId);
    if (images.isEmpty) {
      messenger.showSnackBar(const SnackBar(content: Text('No images to export')));
      return;
    }
    final pdf = pw.Document();
    for (final img in images) {
      final file = File(img.filePath);
      if (!await file.exists()) continue;
          final bytes = await file.readAsBytes();
          final pdfImage = pw.MemoryImage(bytes);
          pdf.addPage(
            pw.Page(
              pageFormat: PdfPageFormat.a4,
              build: (pw.Context ctx) => pw.Center(child: pw.Image(pdfImage, fit: pw.BoxFit.contain)),
            ),
          );
    }
    final dir = await getApplicationDocumentsDirectory();
    final out = File(p.join(dir.path, '${widget.folderName}_${DateTime.now().millisecondsSinceEpoch}.pdf'));
    await out.writeAsBytes(await pdf.save());
    if (mounted) {
      messenger.showSnackBar(
        SnackBar(content: Text('PDF saved: ${out.path}')),
      );
    }
  }
}

class _ImageGridTile extends StatelessWidget {
  const _ImageGridTile({
    super.key,
    required this.index,
    required this.image,
    required this.onDelete,
    required this.onTap,
  });

  final int index;
  final DocumentImage image;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Card(
        key: key,
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            InkWell(
              onTap: onTap,
              child: _buildThumbnail(),
            ),
            Positioned(
              top: 4,
              right: 4,
              child: Material(
                color: Colors.black54,
                shape: const CircleBorder(),
                child: IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.white, size: 20),
                  onPressed: onDelete,
                ),
              ),
            ),
            Positioned(
              bottom: 4,
              left: 4,
              child: ReorderableDragStartListener(
                index: index,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.drag_handle, color: Colors.white, size: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThumbnail() {
    final file = File(image.filePath);
    if (!file.existsSync()) {
      return const ColoredBox(color: Colors.grey, child: Center(child: Icon(Icons.broken_image, size: 48)));
    }
    return Image.file(file, fit: BoxFit.cover);
  }
}

class _ImageViewerPage extends StatelessWidget {
  const _ImageViewerPage({required this.images, required this.initialIndex});

  final List<DocumentImage> images;
  final int initialIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Image')),
      body: PhotoViewGallery.builder(
        itemCount: images.length,
        builder: (context, index) {
          final f = File(images[index].filePath);
          return PhotoViewGalleryPageOptions(
            imageProvider: f.existsSync() ? FileImage(f) : null,
          );
        },
        scrollPhysics: const BouncingScrollPhysics(),
        backgroundDecoration: const BoxDecoration(color: Colors.black),
        pageController: PageController(initialPage: initialIndex),
      ),
    );
  }
}
