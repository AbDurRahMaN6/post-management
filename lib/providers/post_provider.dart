import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/post.dart';

class PostProvider with ChangeNotifier {
  List<Post> _posts = [];
  final String apiUrl = 'https://jsonplaceholder.typicode.com/posts';

  List<Post> get posts => _posts;

  Future<void> fetchPosts() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      _posts = data.map((json) => Post.fromJson(json)).toList();
      notifyListeners();
    }
  }

  Future<void> addPost(BuildContext context, String title, String body) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'title': title, 'body': body}),
    );
    if (response.statusCode == 201) {
      final newPost = Post(
        id: _posts.isNotEmpty ? _posts.first.id! + 1 : 1,
        title: title,
        body: body,
      );
      _posts.insert(0, newPost);
      notifyListeners();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Post successfully created!')),
        );
      }
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to create post')),
        );
      }
    }
  }

  Future<void> updatePost(
      BuildContext context, int id, String title, String body) async {
    final index = _posts.indexWhere((post) => post.id == id);
    if (index != -1) {
      final response = await http.put(
        Uri.parse('$apiUrl/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'title': title, 'body': body}),
      );
      if (response.statusCode == 200) {
        _posts[index] = Post(id: id, title: title, body: body);
        notifyListeners();

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Post successfully updated!')),
          );
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to update post')),
          );
        }
      }
    }
  }

  Future<void> deletePost(BuildContext context, int id) async {
    final response = await http.delete(Uri.parse('$apiUrl/$id'));
    if (response.statusCode == 200) {
      _posts.removeWhere((post) => post.id == id);
      notifyListeners();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Post successfully deleted!')),
        );
      }
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to delete post')),
        );
      }
    }
  }
}
