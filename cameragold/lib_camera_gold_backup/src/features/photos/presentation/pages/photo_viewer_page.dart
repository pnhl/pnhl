import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:photo_view/photo_view.dart';

class PhotoViewerPage extends ConsumerWidget {
  final String photoId;
  final String? groupId;
  
  const PhotoViewerPage({
    super.key,
    required this.photoId,
    this.groupId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // TODO: Share photo
            },
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              // TODO: Download photo
            },
          ),
        ],
      ),
      body: PhotoView(
        imageProvider: NetworkImage(
          'https://picsum.photos/seed/$photoId/800/800',
        ),
        backgroundDecoration: const BoxDecoration(
          color: Colors.black,
        ),
        minScale: PhotoViewComputedScale.contained,
        maxScale: PhotoViewComputedScale.covered * 2.0,
      ),
      bottomNavigationBar: Container(
        color: Colors.black.withOpacity(0.8),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Reactions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildReactionButton('❤️', 5),
                _buildReactionButton('😂', 2),
                _buildReactionButton('👍', 8),
                _buildReactionButton('😮', 1),
                _buildReactionButton('😢', 0),
              ],
            ),
            const SizedBox(height: 16),
            
            // Comment Input
            Row(
              children: [
                const CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(
                    'https://picsum.photos/seed/user/100/100',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Thêm bình luận...',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[800],
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                    maxLength: 60,
                    buildCounter: (context, {currentLength, maxLength, isFocused}) {
                      return Text(
                        '$currentLength/$maxLength',
                        style: TextStyle(color: Colors.grey[400], fontSize: 12),
                      );
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.white),
                  onPressed: () {
                    // TODO: Send comment
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReactionButton(String emoji, int count) {
    return GestureDetector(
      onTap: () {
        // TODO: Add/remove reaction
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: count > 0 ? Colors.blue.withOpacity(0.3) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: count > 0 ? Colors.blue : Colors.grey,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 20)),
            if (count > 0) ...[
              const SizedBox(width: 4),
              Text(
                count.toString(),
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
