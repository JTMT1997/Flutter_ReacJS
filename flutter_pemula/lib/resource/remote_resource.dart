import 'dart:convert';
import 'dart:io';

import 'package:either_dart/either.dart';
import 'package:flutter_pemula/model/post.dart';
import 'package:flutter_pemula/model/post_action_response.dart';
import 'package:http/http.dart' as http;

class RemoteResource {
  final baseUrl = 'http://192.168.1.6:3000/api';
  Future<Either<String, List<Post>>> fetchPost() async {
    try {
      final reponse = await http.get(Uri.parse('$baseUrl/posts'));
      if (reponse.statusCode != 200) {
        return Left('Failed to fetch post');
      }
      final post = PostActionResponse.fromJson(reponse.body);
      return Right(post.data ?? []);
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, String>> createPost(
    File? image,
    String title,
    String content,
  ) async {
    try {
      final request =
          http.MultipartRequest('POST', Uri.parse('$baseUrl/posts'));
      request.fields['title'] = title;
      request.fields['content'] = content;
      if (image != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'image',
            image.path,
          ),
        );
      }
      final req = await request.send();
      final response = await http.Response.fromStream(req);
      if (response.statusCode == 201) {
        final message = json.decode(response.body)['message'];
        return Right(message);
      } else {
        throw Left('Failed to create post');
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, String>> updatePost(
    int id,
    String title,
    String content,
    File? image,
  ) async {
    try {
      final request =
          http.MultipartRequest('PUT', Uri.parse('$baseUrl/posts/$id'));
      request.fields['title'] = title;
      request.fields['content'] = content;
      if (image != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'image',
            image.path,
          ),
        );
      }
      final req = await request.send();
      final response = await http.Response.fromStream(req);
      final message = json.decode(response.body)['message'];
      if (response.statusCode == 200) {
        return Right(message);
      } else if (response.statusCode == 422) {
        return Right(message);
      } else {
        throw Left('Failed to update post');
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  Future<Either<String, String>> deletePost(int id) async {
    try {
      final reponse = await http.delete(Uri.parse('$baseUrl/posts/$id'));
      if (reponse.statusCode != 200) {
        return Left('Failed to delete post');
      }
      final result = PostActionResponse.fromJson(reponse.body);
      return Right(result.message ?? '');
    } catch (e) {
      return Left(e.toString());
    }
  }
}
