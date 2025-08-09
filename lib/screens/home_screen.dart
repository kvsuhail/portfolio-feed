// screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/feed_provider.dart';
import '../widgets/post_card.dart';
import 'add_post_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final ScrollController _scrollController = ScrollController();

  late FeedProvider feedProvider;

  @override
  void initState() {
    super.initState();
    feedProvider = Provider.of<FeedProvider>(context, listen: false);
    feedProvider.fetchPosts();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 300) {
        feedProvider.fetchPosts();
      }
    });
  }

  void _onItemTapped(int index) {
    if (index == 2) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => AddPostScreen()),
      );
      return;
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    FeedPage(),
    Center(child: Text('Search Placeholder')),
    SizedBox(),
    Center(child: Text('Chats Placeholder')),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey[900],
        selectedItemColor: Colors.orangeAccent,
        unselectedItemColor: Colors.white70,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: ''),
          BottomNavigationBarItem(
              icon: CircleAvatar(
                backgroundColor: Colors.orangeAccent,
                child: Icon(Icons.add, color: Colors.black),
                radius: 20,
              ),
              label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
        ],
      ),
    );
  }
}

class FeedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<FeedProvider>(
      builder: (ctx, feed, _) {
        if (feed.posts.isEmpty && feed.hasMore) {
          return Center(child: CircularProgressIndicator());
        }
        if (feed.posts.isEmpty) {
          return Center(child: Text('No posts yet.'));
        }
        return RefreshIndicator(
          onRefresh: () async {
            // you can add a refresh method if needed
          },
          child: ListView.builder(
            controller: ScrollController(),
            itemCount: feed.posts.length,
            itemBuilder: (context, index) {
              return PostCard(post: feed.posts[index]);
            },
          ),
        );
      },
    );
  }
}
