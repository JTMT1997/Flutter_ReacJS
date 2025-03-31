import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pemula/cubit/PostCubit.dart';
import 'package:flutter_pemula/model/post.dart';
import 'package:flutter_pemula/cubit/PostCubit.dart';
import 'package:flutter_pemula/cubit/post_state.dart';
import 'package:flutter_pemula/model/post.dart';
import 'package:flutter_pemula/screen/add_edit_post_screeen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Post> posts = [];

  @override
  void initState() {
    loadPost();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Express'),
      ),
      body: BlocConsumer<PostCubit, PostState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          if (state is PostLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is PostLoaded || state is PostDeleted) {
            posts = state is PostLoaded ? state.posts : posts;
            if (posts.isEmpty) {
              return const Center(child: Text('Post Empty'));
            }
            return _postList();
          }

          if (state is PostError) {
            return Center(child: Text(state.message.toString()));
          }

          return const Center(child: Text('Something went wrong'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
    );
  }

  void loadPost() {
    context.read<PostCubit>().fetchPost();
  }

  Widget _postList() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 8.0,
      ),
      child: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];
          return Card(
            clipBehavior: Clip.hardEdge,
            child: InkWell(
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.network(
                            'http://192.168.1.2:3000/uploads/${post.image}',
                            height: 90,
                            width: 90,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  post.title.toString(),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  post.content.toString(),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                      IconButton(
                        onPressed: () async {
                          var result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                              AddEditPostScreen(post: post),
                            ),
                          );
                          if(result == true) {
                        loadPost();
                      }
                        },
                      icon: Icon(Icons.edit),
                      ),
                        IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        context.read<PostCubit>().deletePost(post.id ?? 0);
                        setState(() {
                          posts.removeWhere(
                              (post) => post.id == posts[index].id);
                        });
                      },
                    ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
