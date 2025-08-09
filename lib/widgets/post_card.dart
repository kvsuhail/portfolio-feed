// widgets/post_card.dart
import 'package:flutter/material.dart';

import '../models/post.dart';

class PostCard extends StatelessWidget {
  final Post post;
  const PostCard({required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      color: Colors.grey[900],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(post.userAvatarUrl),
            ),
            title: Text(
              post.username,
              style: TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              timeAgo(post.createdAt.toDate()),
              style: TextStyle(color: Colors.white54),
            ),
          ),
          if (post.imageUrl.isNotEmpty)
            Image.network(post.imageUrl, fit: BoxFit.cover),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              post.caption,
              style: TextStyle(color: Colors.white70),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Row(
              children: [
                Icon(Icons.favorite_border, color: Colors.orangeAccent),
                SizedBox(width: 6),
                Text('300'), // hard-coded likes for now
              ],
            ),
          ),
        ],
      ),
    );
  }

  String timeAgo(DateTime date) {
    Duration diff = DateTime.now().difference(date);
    if (diff.inDays > 1) return '${diff.inDays} days ago';
    if (diff.inHours > 1) return '${diff.inHours} hours ago';
    if (diff.inMinutes > 1) return '${diff.inMinutes} mins ago';
    return 'Just now';
  }
}
