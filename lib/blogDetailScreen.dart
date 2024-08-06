import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/blogModel.dart';

class BlogDetailScreen extends StatelessWidget {
  final Blog blog;

  const BlogDetailScreen({Key? key, required this.blog}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get the screen width
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(blog.title),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Full-width image
          CachedNetworkImage(
            imageUrl: blog.imageUrl,
            placeholder: (context, url) => SizedBox(
              width: screenWidth,
              child: Center(child: CircularProgressIndicator()),
            ),
            errorWidget: (context, url, error) => SizedBox(
              width: screenWidth,
              child: Center(child: Icon(Icons.error)),
            ),
            width: screenWidth,
            fit: BoxFit.cover,
          ),
          // Title below the image
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              blog.title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}