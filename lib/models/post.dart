// models/post.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String id;
  final String userId;
  final String username;
  final String userAvatarUrl;
  final String imageUrl;
  final String caption;
  final Timestamp createdAt;

  Post({
    required this.id,
    required this.userId,
    required this.username,
    required this.userAvatarUrl,
    required this.imageUrl,
    required this.caption,
    required this.createdAt,
  });

  factory Post.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Post(
      id: doc.id,
      userId: data['userId'] ?? '',
      username: data['username'] ?? '',
      userAvatarUrl: data['userAvatarUrl'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      caption: data['caption'] ?? '',
      createdAt: data['createdAt'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'username': username,
      'userAvatarUrl': userAvatarUrl,
      'imageUrl': imageUrl,
      'caption': caption,
      'createdAt': createdAt,
    };
  }
}
