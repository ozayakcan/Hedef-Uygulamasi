import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../firebase/auth.dart';
import '../firebase/database/posts_database.dart';
import '../models/post.dart';
import '../models/widget.dart';
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
  User user = Auth.user;
  List<Post> posts = [];
  List<Widget> postsWidget = [];
  bool postsLoaded = false;

  @override
  void initState() {
    loadPosts();
    super.initState();
  }

  void loadPosts() async {
    posts = await PostsDB.getFollowingPost(user.uid);
    posts.addAll(await PostsDB.getPosts(user.uid));
    posts = Post.sort(posts);
    List<Widget> tempPostsWidget = [];
    for (final postData in posts) {
      tempPostsWidget.add(post(
        context,
        userModel: postData.userModel,
        postKey: postData.key,
        content: postData.content,
        dateTime: postData.date,
        darkTheme: widget.darkTheme,
        favoriteCount: 0,
        commentCount: 0,
      ));
    }
    setState(() {
      postsWidget = tempPostsWidget;
      postsLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    //UserModel testUser1 = UserModel(
    //  "id",
    //  "email",
    //  "ozayakcan",
    //  "Özay Akcan",
    //  DateTime.now(),
    //  "https://firebasestorage.googleapis.com/v0/b/sosyal-medya-uygulamasi-1.appspot.com/o/Users%2FbicWYJLkUbau5NvJTzbG2HCqHAi2%2FprofileImage%2F1649754187737.jpg?alt=media&token=6a80e2dd-f860-4bc9-9466-643d79139c5a",
    //);
    //UserModel testUser2 = UserModel(
    //  "id",
    //  "email",
    //  "ozay_akcan",
    //  "Özay Akcan",
    //  DateTime.now(),
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
        child: postsLoaded
            ? postsWidget.isNotEmpty
                ? Column(
                    children: postsWidget,
                  )
                : Container()
            : loadingRow(context, widget.darkTheme),
      ),
    );
  }
}
