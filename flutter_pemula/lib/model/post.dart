import 'dart:convert';

class Post {
  final int? id;
  final String? image;
  final String? title;
  final String? content;

  Post({
    this.id,
    this.image,
    this.title,
    this.content,
  });

  factory Post.fromJson(String str) => Post.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Post.fromMap(Map<String, dynamic> json) => Post(
        id: json["id"],
        image: json["image"],
        title: json["title"],
        content: json["content"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "image": image,
        "title": title,
        "content": content,
      };
}