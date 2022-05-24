import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../firebase/auth.dart';
import '../firebase/database/posts_database.dart';
import '../models/post.dart';
import '../widgets/widgets.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({Key? key, required this.darkTheme}) : super(key: key);

  final bool darkTheme;

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  User user = Auth.of().user;
  List<Widget> postsWidget = [];
  bool postsLoaded = false;

  @override
  void initState() {
    loadPosts();
    super.initState();
  }

  Future<void> loadPosts() async {
    setState(() {
      postsWidget.clear();
    });
    List<PostModel> posts = [];
    posts.addAll(await PostsDB.getFavoritedPosts(user.uid));
    List<Widget> tempPostsWidget = await PostsDB.getPostsAsWidgets(
      context,
      posts: posts,
      darkTheme: widget.darkTheme,
    );
    setState(() {
      postsWidget.addAll(tempPostsWidget);
      postsLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return postsLoaded
        ? refreshableListView(
            widgetList: postsWidget,
            onRefresh: loadPosts,
          )
        : loadingRow(context, widget.darkTheme);
  }
}
