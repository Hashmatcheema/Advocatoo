import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

/// Full-screen document image gallery with pinch zoom (photo_view).
/// Use when a document thumbnail is tapped (Increment 4).
class DocumentGalleryViewer extends StatelessWidget {
  const DocumentGalleryViewer({
    super.key,
    required this.imageProviders,
    this.initialIndex = 0,
    this.title = 'Documents',
  });

  final List<ImageProvider> imageProviders;
  final int initialIndex;
  final String title;

  @override
  Widget build(BuildContext context) {
    if (imageProviders.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(title)),
        body: const Center(child: Text('No images')),
      );
    }
    final controller = PageController(initialPage: initialIndex);
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: PhotoViewGallery.builder(
        scrollPhysics: const BouncingScrollPhysics(),
        pageController: controller,
        itemCount: imageProviders.length,
        builder: (context, index) {
          return PhotoViewGalleryPageOptions(
            imageProvider: imageProviders[index],
            heroAttributes: PhotoViewHeroAttributes(tag: 'doc_$index'),
          );
        },
      ),
    );
  }
}
