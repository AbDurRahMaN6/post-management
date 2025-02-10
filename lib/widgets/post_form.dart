import 'package:flutter/material.dart';
import '../providers/post_provider.dart';
import '../models/post.dart';

class PostForm extends StatefulWidget {
  final PostProvider postProvider;
  final Post? post;

  const PostForm({required this.postProvider, this.post, super.key});

  @override
  State<PostForm> createState() => _PostFormState();
}

class _PostFormState extends State<PostForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController titleController;
  late TextEditingController bodyController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.post?.title ?? '');
    bodyController = TextEditingController(text: widget.post?.body ?? '');
  }

  @override
  void dispose() {
    titleController.dispose();
    bodyController.dispose();
    super.dispose();
  }

  void _savePost() {
    if (_formKey.currentState!.validate()) {
      if (widget.post == null) {
        widget.postProvider
            .addPost(context, titleController.text, bodyController.text);
      } else {
        widget.postProvider.updatePost(context, widget.post!.id!,
            titleController.text, bodyController.text);
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.post == null ? 'Add Post' : 'Edit Post'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
              validator: (value) =>
                  value!.isEmpty ? 'Title cannot be empty' : null,
            ),
            TextFormField(
              controller: bodyController,
              decoration: const InputDecoration(labelText: 'Descriptions'),
              validator: (value) =>
                  value!.isEmpty ? 'Descriptions cannot be empty' : null,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _savePost,
          child: const Text('Save'),
        ),
      ],
    );
  }
}
