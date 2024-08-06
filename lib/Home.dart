import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../bloc/blog_bloc.dart';
import 'blogDetailScreen.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'SubSpace',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 40,
          ),
        ),
        actions: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white, // Background color of PopupMenuButton
              shape: BoxShape.circle,
            ),
            child: PopupMenuButton<String>(
              onSelected: (value) {
                // Handle menu item selection
                switch (value) {
                  case 'SubSpace API':
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("SubSpace API selected")),
                    );
                    break;
                  case 'SubSpace VPN':
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("SubSpace VPN selected")),
                    );
                    break;
                  case 'Blogs':
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Blogs selected")),
                    );
                    break;
                }
              },
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem<String>(
                    value: 'SubSpace API',
                    child: Row(
                      children: [
                        Icon(Icons.api, color: Colors.black), // Icon color
                        SizedBox(width: 8),
                        Text(
                          'SubSpace API',
                          style: TextStyle(color: Colors.black), // Text color
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: 'SubSpace VPN',
                    child: Row(
                      children: [
                        Icon(Icons.vpn_key, color: Colors.black), // Icon color
                        SizedBox(width: 8),
                        Text(
                          'SubSpace VPN',
                          style: TextStyle(color: Colors.black), // Text color
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: 'Blogs',
                    child: Row(
                      children: [
                        Icon(Icons.article, color: Colors.black), // Icon color
                        SizedBox(width: 8),
                        Text(
                          'Blogs',
                          style: TextStyle(color: Colors.black), // Text color
                        ),
                      ],
                    ),
                  ),
                ];
              },
              icon: Icon(
                Icons.dehaze,
                color: Colors.black, // Icon color for PopupMenuButton
              ),
            ),
          ),
        ],
      ),
      body: BlocBuilder<BlogBloc, BlogState>(
        builder: (context, state) {
          if (state is BlogInitial) {
            BlocProvider.of<BlogBloc>(context).add(FetchBlogs());
            return Center(child: CircularProgressIndicator());
          } else if (state is BlogLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is BlogLoaded) {
            return ListView.builder(
              itemCount: state.blogs.length,
              itemBuilder: (context, index) {
                final blog = state.blogs[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlogDetailScreen(blog: blog),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      // Full-width image
                      CachedNetworkImage(
                        imageUrl: blog.imageUrl,
                        placeholder: (context, url) => SizedBox(
                          width: double.infinity,
                          child: Center(child: CircularProgressIndicator()),
                        ),
                        errorWidget: (context, url, error) => SizedBox(
                          width: double.infinity,
                          child: Center(child: Icon(Icons.error)),
                        ),
                        width: double.infinity,
                        height: 200, // Adjust height as needed
                        fit: BoxFit.cover,
                      ),
                      // Title below the image
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          blog.title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      // Divider for spacing between items
                      Divider(height: 1),
                    ],
                  ),
                );
              },
            );
          } else if (state is BlogError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Failed to load blogs: ${state.message}'),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      BlocProvider.of<BlogBloc>(context).add(FetchBlogs());
                    },
                    child: Text('Retry'),
                  ),
                ],
              ),
            );
          }
          return Container();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Help'),
                content: Text('How may I help you?'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Close'),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.messenger_outlined, color: Colors.white),
        backgroundColor: Colors.deepPurple,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat, // Ensure it's positioned at the bottom right
    );
  }
}
