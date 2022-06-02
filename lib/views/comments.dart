import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../firebase/auth.dart';
import '../firebase/database/comments.dart';
import '../models/post.dart';
import '../models/widget.dart';
import '../widgets/menu.dart';
import '../widgets/widgets.dart';
import 'bottom_navigation.dart';
import 'post.dart';

class CommentsPage extends StatefulWidget {
  const CommentsPage({
    Key? key,
    required this.darkTheme,
    required this.postModel,
  }) : super(key: key);

  final bool darkTheme;
  final PostModel postModel;

  @override
  State<CommentsPage> createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  User user = Auth.of().user;
  bool commentsLoaded = false;
  List<Widget> widgetList = [];

  StreamSubscription<DatabaseEvent>? commentsEvent;

  @override
  void initState() {
    super.initState();
    loadComments();
  }

  @override
  void dispose() {
    super.dispose();
    commentsEvent?.cancel();
  }

  Future<void> loadComments() async {
    commentsEvent = CommentsDB.getCommentsRef(widget.postModel.key)
        .orderByKey()
        .onValue
        .listen((event) {
      setState(() {
        widgetList.clear();
      });
      setState(() {
        widgetList.add(
          PostWidget(
            darkTheme: widget.darkTheme,
            postModel: widget.postModel,
            inProfile: false,
            commentButtonEnabled: false,
          ),
        );
      });
      CommentsDB.getCommentsList(event).then((value) {
        for (final commentModel in value) {
          setState(() {
            widgetList.add(
              Padding(
                padding: const EdgeInsets.all(10),
                child: contentWidget(
                  context: context,
                  darkTheme: widget.darkTheme,
                  inProfile: false,
                  userModel: commentModel.userModel,
                  date: commentModel.date,
                  showContent: true,
                  content: commentModel.comment,
                ),
              ),
            );
          });
        }
        setState(() {
          commentsLoaded = true;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationPage(
      darkTheme: widget.darkTheme,
      showSearchbar: true,
      menu: mainPopupMenu(context, darkTheme: widget.darkTheme),
      widgetModel: WidgetModel(
        context,
        title: AppLocalizations.of(context).post_title.replaceAll(
              "{user}",
              widget.postModel.userModel.name +
                  " " +
                  widget.postModel.userModel.getUserName,
            ),
        showScrollView: false,
        child: commentsLoaded
            ? listView(
                widgetList: widgetList,
              )
            : loadingRow(context, widget.darkTheme),
      ),
    );
  }
}
