import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../firebase/auth.dart';
import '../firebase/database/database.dart';
import '../firebase/database/favorites_database.dart';
import '../firebase/database/posts_database.dart';
import '../models/post.dart';
import '../widgets/buttons.dart';
import '../widgets/widgets.dart';
import 'comments.dart';

class PostWidget extends StatefulWidget {
  const PostWidget({
    Key? key,
    required this.darkTheme,
    required this.postModel,
    this.inProfile = true,
    this.commentButtonEnabled = true,
  }) : super(key: key);

  final bool darkTheme;
  final PostModel postModel;
  final bool inProfile;
  final bool commentButtonEnabled;
  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  User user = Auth.of().user;
  int favoriteCount = 0;
  int commentCount = 0;
  bool isFavorited = false;

  StreamSubscription<DatabaseEvent>? favoritedEvent;
  StreamSubscription<DatabaseEvent>? favoriteEvent;
  StreamSubscription<DatabaseEvent>? commentEvent;

  @override
  void initState() {
    favoritedEvent =
        FavoritesDB.favoritedPostRef(widget.postModel.key, user.uid)
            .onValue
            .listen((event) {
      if (event.snapshot.exists) {
        setState(() {
          isFavorited = true;
        });
      } else {
        setState(() {
          isFavorited = false;
        });
      }
    });
    favoriteEvent = FavoritesDB.getFavoritesOfPostRef(widget.postModel.key)
        .onValue
        .listen((event) {
      if (event.snapshot.exists) {
        setState(() {
          favoriteCount = event.snapshot.children.length;
        });
      } else {
        setState(() {
          favoriteCount = 0;
        });
      }
    });
    commentEvent =
        PostsDB.getCommentsRef(widget.postModel.key).onValue.listen((event) {
      if (event.snapshot.exists) {
        setState(() {
          commentCount = event.snapshot.children.length;
        });
      } else {
        setState(() {
          commentCount = 0;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    favoritedEvent?.cancel();
    favoriteEvent?.cancel();
    commentEvent?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        contentWidget(
          context: context,
          darkTheme: widget.darkTheme,
          inProfile: widget.inProfile,
          userModel: widget.postModel.userModel,
          date: widget.postModel.date,
          showContent: widget.postModel.showContent,
          content: widget.postModel.content,
        ),
        const SizedBox(
          height: 5,
        ),
        if (widget.postModel.image != Database.emptyString)
          CachedNetworkImage(
            imageUrl: widget.postModel.image,
          ),
        if (widget.postModel.image != Database.emptyString)
          const SizedBox(
            height: 5,
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            ToolTipButton(
              darkTheme: widget.darkTheme,
              tooltip: AppLocalizations.of(context).favorite_btn,
              text: favoriteCount.toString(),
              icon: isFavorited ? Icons.favorite : Icons.favorite_border,
              activeColor: isFavorited ? Colors.red : null,
              onPressed: () {
                FavoritesDB.addFavorite(widget.postModel.key, user.uid)
                    .then((value) {
                  if (value != null) {
                    ScaffoldSnackbar.of(context).show(
                        AppLocalizations.of(context).could_not_add_favorite);
                  }
                });
              },
            ),
            ToolTipButton(
              darkTheme: widget.darkTheme,
              tooltip: AppLocalizations.of(context).comment_btn,
              text: commentCount.toString(),
              icon: Icons.comment,
              onPressed: () {
                if (widget.commentButtonEnabled) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CommentsPage(
                        darkTheme: widget.darkTheme,
                        postModel: widget.postModel,
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}
