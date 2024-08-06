// lib/models/blog.dart
import 'package:json_annotation/json_annotation.dart';

part 'blogModel.g.dart';

@JsonSerializable()
class Blog {
  final String title;
  @JsonKey(name: 'image_url')
  final String imageUrl;

  Blog({required this.title, required this.imageUrl});

  factory Blog.fromJson(Map<String, dynamic> json) => _$BlogFromJson(json);

  Map<String, dynamic> toJson() => _$BlogToJson(this);
}
