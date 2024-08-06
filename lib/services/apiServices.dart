import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/blogModel.dart';

class BlogService {
  static const String url = 'https://intent-kit-16.hasura.app/api/rest/blogs';
  static const String adminSecret = '32qR4KmXOIpsGPQKMqEJHGJS27G5s7HdSKO3gdtQd2kv5e852SiYwWNfxkZOBuQ6';

  Future<List<Blog>> fetchBlogs() async {
    final response = await http.get(Uri.parse(url), headers: {
      'x-hasura-admin-secret': adminSecret,
    });

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final List<dynamic> blogList = responseData['blogs'];
      return blogList.map((json) => Blog.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load blogs');
    }
  }
}