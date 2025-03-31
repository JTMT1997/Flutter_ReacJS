import 'dart:convert';

class PostActionResponse {
    final bool? success;
    final String? message;
    final List<Datum>? data;

    PostActionResponse({
        this.success,
        this.message,
        this.data,
    });

    factory PostActionResponse.fromJson(String str) => PostActionResponse.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory PostActionResponse.fromMap(Map<String, dynamic> json) => PostActionResponse(
        success: json["success"],
        message: json["message"],
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromMap(x))),
    );

    Map<String, dynamic> toMap() => {
        "success": success,
        "message": message,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toMap())),
    };
}

class Datum {
    final int? id;
    final String? image;
    final String? title;
    final String? content;

    Datum({
        this.id,
        this.image,
        this.title,
        this.content,
    });

    factory Datum.fromJson(String str) => Datum.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Datum.fromMap(Map<String, dynamic> json) => Datum(
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