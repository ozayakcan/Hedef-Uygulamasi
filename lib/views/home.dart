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
    //UserModel testUser1 = UserModel(
    //  "id",
    //  "email",
    //  "ozayakcan",
    //  "Özay Akcan",
    //  Time.getTimeUtc(),
    //  "https://firebasestorage.googleapis.com/v0/b/sosyal-medya-uygulamasi-1.appspot.com/o/Users%2FbicWYJLkUbau5NvJTzbG2HCqHAi2%2FprofileImage%2F1649754187737.jpg?alt=media&token=6a80e2dd-f860-4bc9-9466-643d79139c5a",
    //);
    //UserModel testUser2 = UserModel(
    //  "id",
    //  "email",
    //  "ozay_akcan",
    //  "Özay Akcan",
    //  Time.getTimeUtc(),
    //  "https://firebasestorage.googleapis.com/v0/b/sosyal-medya-uygulamasi-1.appspot.com/o/Users%2Fhz1G0hdalkWfbqyzHsOgP9KWuCq2%2FprofileImage%2F1649754098492.jpg?alt=media&token=0a0c42cd-188b-48ab-adb8-7727db1523a4",
    //);
    //profileColumn(context,
    //    darkTheme: widget.darkTheme, user: testUser1),
    //const SizedBox(
    //  height: 10,
    //),
    //profileColumn(context,
    //    darkTheme: widget.darkTheme, user: testUser2),

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
