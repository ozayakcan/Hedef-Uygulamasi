import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:sosyal/firebase/database/favorites_database.dart';

import '../firebase/auth.dart';
import '../firebase/database/database.dart';
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

  StreamSubscription<DatabaseEvent>? usersEvent;

  @override
  void initState() {
    super.initState();
    usersEvent =
        Database.getReference(Database.usersString).onValue.listen((event) {
      loadPosts();
    });
  }

  @override
  void dispose() {
    super.dispose();
    usersEvent?.cancel();
  }

  Future<void> loadPosts() async {
    FavoritesDB.userFavoritesRef(user.uid).onValue.listen((event) async {
      setState(() {
        postsWidget.clear();
      });
      List<PostModel> posts = [];
      posts.addAll(await PostsDB.getFavoritedPosts(event));
      List<Widget> tempPostsWidget = await PostsDB.getPostsAsWidgets(
        context,
        posts: posts,
        darkTheme: widget.darkTheme,
      );
      setState(() {
        postsWidget.addAll(tempPostsWidget);
        postsLoaded = true;
      });
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
