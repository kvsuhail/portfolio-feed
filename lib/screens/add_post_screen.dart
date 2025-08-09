// screens/add_post_screen.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/post.dart';
import '../providers/auth_provider.dart';
import '../providers/feed_provider.dart';

class AddPostScreen extends StatefulWidget {
  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final TextEditingController _captionController = TextEditingController();
  File? _pickedImage;
  bool _isUploading = false;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.camera);
    if (picked != null) {
      setState(() {
        _pickedImage = File(picked.path);
      });
    }
  }

  Future<String> _uploadImage(File file) async {
    final fileName = DateTime.now().toIso8601String() + '.jpg';
    final ref = FirebaseStorage.instance.ref().child('post_images').child(fileName);
    await ref.putFile(file);
    return await ref.getDownloadURL();
  }

  Future<void> _submitPost() async {
    if (_pickedImage == null || _captionController.text.trim().isEmpty) return;
    setState(() {
      _isUploading = true;
    });

    final url = await _uploadImage(_pickedImage!);

    final auth = Provider.of<AuthProvider>(context, listen: false);
    final newPost = Post(
      id: '',
      userId: auth.user!.uid,
      username: 'Anonymous', // replace with user data if available
      userAvatarUrl: 'https://i.pravatar.cc/150?img=3', // placeholder avatar
      imageUrl: url,
      caption: _captionController.text,
      createdAt: Timestamp.now(),
    );

    final feedProvider = Provider.of<FeedProvider>(context, listen: false);
    await feedProvider.addPost(newPost);

    setState(() {
      _isUploading = false;
    });

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Post')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _pickedImage != null
                ? Image.file(_pickedImage!, height: 250)
                : Container(
                    height: 250,
                    color: Colors.grey[800],
                    child: Center(
                      child: Text('No image picked', style: TextStyle(color: Colors.white54)),
                    ),
                  ),
            SizedBox(height: 12),
            ElevatedButton.icon(
              icon: Icon(Icons.camera_alt),
              label: Text('Take Picture'),
              onPressed: _pickImage,
            ),
            SizedBox(height: 12),
            TextField(
              controller: _captionController,
              decoration: InputDecoration(hintText: 'Write a caption...'),
              maxLines: 3,
            ),
            SizedBox(height: 20),
            _isUploading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _submitPost,
                    child: Text('Post'),
                  ),
          ],
        ),
      ),
    );
  }
}
