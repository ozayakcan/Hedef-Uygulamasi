import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../firebase/auth.dart';
import '../firebase/database/posts_database.dart';
import '../models/post.dart';
import '../models/widget.dart';
import '../widgets/buttons.dart';
import '../widgets/menu.dart';
import '../widgets/widgets.dart';
import 'bottom_navigation.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
    required this.darkTheme,
  }) : super(key: key);
  final bool darkTheme;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User user = Auth.of().user;
  List<Widget> postsWidget = [];
  bool postsLoaded = false;

  @override
  void initState() {
    super.initState();
    loadPosts();
  }

  Future<void> loadPosts() async {
    setState(() {
      postsWidget.clear();
    });
    List<PostModel> posts = [];
    posts.addAll(await PostsDB.getPosts(user.uid));
    posts.addAll(await PostsDB.getFollowingPost(user.uid));
    List<Widget> tempPostsWidget = await PostsDB.getPostsAsWidgets(
      context,
      posts: posts,
      darkTheme: widget.darkTheme,
    );
    setState(() {
      postsWidget.add(
        shareButton(
          context,
          darkTheme: widget.darkTheme,
          onShared: () async {
            await loadPosts();
          },
        ),
      );
      postsWidget.addAll(tempPostsWidget);
      postsLoaded = true;
    });
  }

  final ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return BottomNavigationPage(
      darkTheme: widget.darkTheme,
      showSearchbar: true,
      menu: mainPopupMenu(context, darkTheme: widget.darkTheme),
      widgetModel: WidgetModel(
        context,
        title: AppLocalizations.of(context).app_name,
        showScrollView: false,
        child: postsLoaded
            ? refreshableListView(
                widgetList: postsWidget,
                onRefresh: loadPosts,
              )
            : loadingRow(context, widget.darkTheme),
      ),
    );
  }
}
