import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subspaceassignment/services/apiServices.dart';
import 'Home.dart';
import 'bloc/blog_bloc.dart';


void main() {
  runApp(BlogExplorerApp());
}

class BlogExplorerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blog Explorer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
        create: (context) => BlogBloc(BlogService()),
        child: Home(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}