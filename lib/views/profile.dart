import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../firebase/auth.dart';
import '../firebase/database/followers_database.dart';
import '../firebase/database/posts_database.dart';
import '../firebase/database/user_database.dart';
import '../firebase/storage/upload_profile_image.dart';
import '../models/post.dart';
import '../models/user.dart';
import '../models/widget.dart';
import '../utils/assets.dart';
import '../utils/transitions.dart';
import '../utils/variables.dart';
import '../widgets/buttons.dart';
import '../widgets/images.dart';
import '../widgets/texts.dart';
import '../widgets/widgets.dart';
import 'bottom_navigation.dart';
import 'edit_profile.dart';
import 'profile_image.dart';

class Profile extends StatefulWidget {
  const Profile(
      {Key? key,
      required this.darkTheme,
      required this.showAppBar,
      required this.username})
      : super(key: key);

  final bool darkTheme;
  final bool showAppBar;
  final String username;
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  User user = Auth.user;
  StreamSubscription<DatabaseEvent>? userEvent;
  StreamSubscription<DatabaseEvent>? userEventMe;
  UserModel userModel = UserModel.empty();
  UserModel userModelMe = UserModel.empty();
  bool isFollowing = false;

  int followerCount = 0;
  int followCount = 0;

  bool alertDialogVisible = false;

  List<Widget> postsWidget = [];
  bool postsLoaded = false;

  @override
  void initState() {
    userEventMe = UserDB.getUserRef(user.uid).onValue.listen((event) {
      if (event.snapshot.exists) {
        final json = event.snapshot.value as Map<dynamic, dynamic>;
        setState(() {
          userModelMe = UserModel.fromJson(json);
        });
      }
    });
    userEvent =
        UserDB.getUserQueryByUsername(widget.username).onValue.listen((event) {
      if (event.snapshot.exists) {
        if (kDebugMode) {
          print(event.snapshot.children.first.value.toString());
        }
        final json =
            event.snapshot.children.first.value as Map<dynamic, dynamic>;
        setState(() {
          userModel = UserModel.fromJson(json);
        });
        FollowersDB.checkFollowing(follower: user.uid, following: userModel.id)
            .then((value) {
          setState(() {
            isFollowing = value;
          });
        });
        setFollowerCount();
        setFollowCount();

        loadPosts();
      }
    });
    super.initState();
  }

  void loadPosts() async {
    List<PostModel> posts = [];
    posts.addAll(await PostsDB.getPosts(userModel.id));
    List<Widget> tempPostsWidget = await PostsDB.getPostsAsWidgets(
      context,
      posts: posts,
      darkTheme: widget.darkTheme,
      includeFollowing: false,
      inProfile: true,
    );
    setState(() {
      postsWidget = tempPostsWidget;
      postsLoaded = true;
    });
  }

  @override
  void dispose() {
    super.dispose();
    userEvent?.cancel();
    userEventMe?.cancel();
  }

  void setFollowerCount() {
    FollowersDB.getFollowerCount(userModel.id).then((value) {
      if (value != null) {
        setState(() {
          followerCount = value;
        });
      }
    });
  }

  void setFollowCount() {
    FollowersDB.getFollowCount(userModel.id).then((value) {
      if (value != null) {
        setState(() {
          followCount = value;
        });
      }
    });
  }

  void displayProfileImage(String username, String imageUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => ProfileImage(
          darkTheme: widget.darkTheme,
          username: username,
          imageUrl: imageUrl,
        ),
      ),
    );
  }

  void showLoadingAlert() {
    if (!alertDialogVisible) {
      loadingAlert(context, widget.darkTheme);
      setState(() {
        alertDialogVisible = true;
      });
    }
  }

  void closeLoadingAlert(BuildContext context) {
    if (alertDialogVisible) {
      Navigator.pop(context);
      setState(() {
        alertDialogVisible = false;
      });
    }
  }

  Widget profileContent(BuildContext context) {
    if (userModel.id != "" && userModelMe.id != "") {
      return Container(
        padding: const EdgeInsets.only(top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Hero(
                    tag: Transitions.profileImage,
                    child: profileImageButton(
                      userModel.profileImage,
                      darkTheme: widget.darkTheme,
                      rounded: true,
                      onPressed: () {
                        displayProfileImage(
                            userModel.username, userModel.profileImage);
                      },
                    ),
                  ),
                  if (userModel.id == userModelMe.id)
                    cameraIcon(
                      darkTheme: widget.darkTheme,
                      rounded: true,
                      onPressed: () {
                        UploadProfileImage.fromGallery(
                          context,
                          userID: userModelMe.id,
                          beforeUpload: () {
                            showLoadingAlert();
                          },
                          onError: () {
                            closeLoadingAlert(context);
                            ScaffoldSnackbar.of(context).show(
                                AppLocalizations.of(context).an_error_occurred);
                          },
                          whenComplete: (downloadUrl) {
                            UserDB.updateProfileImage(userModel.id, downloadUrl)
                                .then((value) {
                              closeLoadingAlert(context);
                              if (value != null) {
                                ScaffoldSnackbar.of(context).show(
                                    AppLocalizations.of(context)
                                        .an_error_occurred);
                              }
                            });
                          },
                        );
                      },
                    ),
                ],
              ),
            ),
            Center(
              child: Container(
                padding: const EdgeInsets.only(top: 10),
                child: SelectableText(
                  userModel.name + "\n" + userModel.getUserName,
                  style: simpleTextStyle(
                    Variables.fontSizeMedium,
                    widget.darkTheme,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    AppLocalizations.of(context).followers_profile +
                        "\n" +
                        FollowersDB.convertFollowNumbers(
                          context,
                          followerCount,
                        ),
                    style: simpleTextStyle(
                        Variables.fontSizeMedium, widget.darkTheme),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(
                  width: 40,
                ),
                Center(
                  child: Text(
                    AppLocalizations.of(context).following_profile +
                        "\n" +
                        FollowersDB.convertFollowNumbers(
                          context,
                          followCount,
                        ),
                    style: simpleTextStyle(
                        Variables.fontSizeMedium, widget.darkTheme),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            Center(
              child: Container(
                padding: const EdgeInsets.only(
                  top: 10,
                ),
                child: user.uid == userModel.id
                    ? customButtonWithIcon(
                        context,
                        darkTheme: widget.darkTheme,
                        text: AppLocalizations.of(context).edit_profile,
                        buttonStyle: ButtonStyleEnum.primaryButton,
                        width: MediaQuery.of(context).size.width - 20,
                        borderRadius: Variables.buttonRadiusRound,
                        action: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditProfile(
                                darkTheme: widget.darkTheme,
                              ),
                            ),
                          );
                        },
                      )
                    : isFollowing
                        ? customButtonWithIcon(
                            context,
                            darkTheme: widget.darkTheme,
                            iconUrl: AImages.check,
                            text: AppLocalizations.of(context).following_btn,
                            buttonStyle: ButtonStyleEnum.primaryButton,
                            width: MediaQuery.of(context).size.width - 20,
                            borderRadius: Variables.buttonRadiusRound,
                            action: () {
                              defaultAlertbox(
                                context,
                                title: AppLocalizations.of(context).unfollow,
                                dismissible: false,
                                descriptions: [
                                  Text(
                                    AppLocalizations.of(context)
                                        .unfollow_warn
                                        .replaceAll(
                                            "%s",
                                            userModel.name +
                                                " " +
                                                userModel.getUserName),
                                    style: simpleTextStyle(
                                        Variables.fontSizeNormal,
                                        widget.darkTheme),
                                  ),
                                ],
                                darkTheme: widget.darkTheme,
                                actionYes: () async {
                                  final unfollowResult =
                                      await FollowersDB.unfollow(
                                          follower: user.uid,
                                          following: userModel.id);
                                  if (unfollowResult == null) {
                                    setState(() {
                                      isFollowing = false;
                                    });
                                    setFollowerCount();
                                  }
                                },
                                actionNo: () {},
                              );
                            },
                          )
                        : customButtonWithIcon(
                            context,
                            darkTheme: widget.darkTheme,
                            text: AppLocalizations.of(context).follow_btn,
                            buttonStyle: ButtonStyleEnum.secondaryButton,
                            width: MediaQuery.of(context).size.width - 20,
                            borderRadius: Variables.buttonRadiusRound,
                            action: () async {
                              final followResult = await FollowersDB.follow(
                                  follower: user.uid, following: userModel.id);
                              if (followResult == null) {
                                setState(() {
                                  isFollowing = true;
                                });
                                setFollowerCount();
                              }
                            },
                          ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(
                top: 10,
              ),
              child: postsLoaded
                  ? postsWidget.isNotEmpty
                      ? Column(
                          children: postsWidget,
                        )
                      : Container()
                  : loadingRow(context, widget.darkTheme),
            ),
          ],
        ),
      );
    } else {
      return Center(
        child: loadingRow(context, widget.darkTheme),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.showAppBar) {
      return BottomNavigationPage(
        darkTheme: widget.darkTheme,
        showSearchbar: true,
        widgetModel: WidgetModel(
          context,
          title: widget.username,
          child: profileContent(context),
        ),
      );
    } else {
      return profileContent(context);
    }
  }
}
