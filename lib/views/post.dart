import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_linkify/flutter_linkify.dart';

import '../firebase/auth.dart';
import '../firebase/database/favorites_database.dart';
import '../firebase/database/posts_database.dart';
import '../models/post.dart';
import '../utils/time.dart';
import '../utils/variables.dart';
import '../widgets/buttons.dart';
import '../widgets/images.dart';
import '../widgets/texts.dart';
import '../widgets/widgets.dart';
import 'profile.dart';

class PostWidget extends StatefulWidget {
  const PostWidget({
    Key? key,
    required this.darkTheme,
    required this.postModel,
    this.inProfile = true,
  }) : super(key: key);

  final bool darkTheme;
  final PostModel postModel;
  final bool inProfile;
  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  User user = Auth.user;
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
        Row(
          children: [
            const SizedBox(width: 1),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      if (!widget.inProfile) const SizedBox(width: 5),
                      if (!widget.inProfile)
                        profileImage(
                          widget.postModel.userModel.profileImage,
                          rounded: true,
                          width: 20,
                          height: 20,
                        ),
                      const SizedBox(
                        width: 5,
                      ),
                      InkWell(
                        onTap: () {
                          if (!widget.inProfile) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Profile(
                                  username: widget.postModel.userModel.username,
                                  darkTheme: widget.darkTheme,
                                  showAppBar: true,
                                ),
                              ),
                            );
                          }
                        },
                        child: Text(
                          widget.postModel.userModel.username,
                          style: linktTextStyle(
                              Variables.fontSizeNormal, widget.darkTheme),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        Time.of(context).elapsed(widget.postModel.date),
                        style: simpleTextStyleSecondary(
                            Variables.fontSizeNormal, widget.darkTheme),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  SelectableLinkify(
                    onOpen: (link) {
                      onLinkOpen(context, link);
                    },
                    text: widget.postModel.content,
                    style: simpleTextStyle(
                        Variables.fontSizeNormal, widget.darkTheme),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 1),
          ],
        ),
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
                ScaffoldSnackbar.of(context).show("Yorum Yap");
              },
            ),
            ToolTipButton(
              darkTheme: widget.darkTheme,
              tooltip: AppLocalizations.of(context).share_btn,
              icon: Icons.share,
              onPressed: () {
                ScaffoldSnackbar.of(context).show("Paylaş");
              },
            ),
          ],
        ),
      ],
    );
  }
}
