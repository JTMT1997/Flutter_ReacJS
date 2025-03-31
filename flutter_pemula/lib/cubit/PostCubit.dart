import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pemula/cubit/post_state.dart';
import 'package:flutter_pemula/model/post.dart';
import 'package:flutter_pemula/resource/remote_resource.dart';



class PostCubit extends Cubit<PostState> {
  PostCubit() : super(PostInitial());

  void fetchPost() async {
    emit(PostLoading());
    try {
      final result = await RemoteResource().fetchPost();
      result.fold(
        (error) => emit(PostError(message: error)),
        (posts) => emit(PostLoaded(posts: posts)),
      );
    } catch (e) {
      emit(PostError(message: e.toString()));
    }
  }

  void createPost({
    required String title,
    required String content,
    required File image,
  }) async {
    emit(PostLoading());
    try {
      final result = await RemoteResource().createPost(image, title, content);
      result.fold(
        (error) => emit(PostError(message: error)),
        (response) => emit(PostCreated(message: response)),
      );
    } catch (e) {
      emit(PostError(message: e.toString()));
    }
  }

  void deletePost(int id) async {
    emit(PostLoading());
    try {
      final result = await RemoteResource().deletePost(id);
      result.fold(
        (error) => emit(PostError(message: error)),
        (response) => emit(PostDeleted(message: response)),
      );
    } catch (e) {
      emit(PostError(message: e.toString()));
    }
  }

  void updatePost({
    required int id,
    required String title,
    required String content,
    required File? image,
  }) async {
    emit(PostLoading());
    try {
      final result = await RemoteResource().updatePost(
        id,
        title,
        content,
        image,
      );
      result.fold(
        (error) => emit(PostError(message: error)),
        (response) => emit(PostUpdated(message: response)),
      );
    } catch (e) {
      emit(PostError(message: e.toString()));
    }
  }
}
