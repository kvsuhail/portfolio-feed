// providers/feed_provider.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/post.dart';

class FeedProvider with ChangeNotifier {
  final List<Post> _posts = [];
  bool _hasMore = true;
  DocumentSnapshot? _lastDoc;
  bool isLoading = false;

  List<Post> get posts => _posts;
  bool get hasMore => _hasMore;

  final int _limit = 10;

  Future<void> fetchPosts() async {
    if (isLoading || !_hasMore) return;
    isLoading = true;

    Query query = FirebaseFirestore.instance
        .collection('posts')
        .orderBy('createdAt', descending: true)
        .limit(_limit);

    if (_lastDoc != null) {
      query = query.startAfterDocument(_lastDoc!);
    }

    final snapshot = await query.get();
    if (snapshot.docs.isNotEmpty) {
      _lastDoc = snapshot.docs.last;
      _posts.addAll(snapshot.docs.map((doc) => Post.fromFirestore(doc)));
      if (snapshot.docs.length < _limit) _hasMore = false;
    } else {
      _hasMore = false;
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> addPost(Post post) async {
    await FirebaseFirestore.instance.collection('posts').add(post.toMap());
    _posts.insert(0, post); // Immediately add to UI
    notifyListeners();
  }
}
