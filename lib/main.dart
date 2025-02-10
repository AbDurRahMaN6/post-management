import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/post_list_screen.dart';
import 'providers/post_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PostProvider()..fetchPosts(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Post App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const PostListScreen(),
      ),
    );
  }
}
