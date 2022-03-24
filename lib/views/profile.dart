import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../models/user.dart';
import '../utils/assets.dart';
import '../utils/auth.dart';
import '../utils/database/database.dart';
import '../utils/database/followers_database.dart';
import '../utils/database/user_database.dart';
import '../utils/variables.dart';
import '../utils/widget_drawer_model.dart';
import '../widgets/buttons.dart';
import '../widgets/images.dart';
import '../widgets/texts.dart';
import '../widgets/widgets.dart';
import 'bottom_navigation.dart';
import 'edit_profile.dart';

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
  late User? user;
  StreamSubscription<DatabaseEvent>? userEvent;
  StreamSubscription<DatabaseEvent>? userEventMe;
  UserModel userModel = UserModel.empty();
  UserModel userModelMe = UserModel.empty();
  bool isFollowing = false;

  int followerCount = 0;
  int followCount = 0;

  @override
  void initState() {
    setState(() {
      user = Auth.user;
    });
    userEventMe = UserDB.getUserRef(user!.uid).onValue.listen((event) {
      if (event.snapshot.exists) {
        final json = event.snapshot.value as Map<dynamic, dynamic>;
        setState(() {
          userModelMe = UserModel.fromJson(json);
        });
      }
    });
    userEvent = UserDB.getUserQuery(widget.username).onValue.listen((event) {
      if (event.snapshot.exists) {
        if (kDebugMode) {
          print(event.snapshot.children.first.value.toString());
        }
        final json =
            event.snapshot.children.first.value as Map<dynamic, dynamic>;
        setState(() {
          userModel = UserModel.fromJson(json);
        });
        FollowersDB.checkFollowing(follower: user!.uid, following: userModel.id)
            .then((value) {
          setState(() {
            isFollowing = value;
          });
        });
        setFollowerCount();
        setFollowCount();
      }
    });
    super.initState();
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

  Widget profileContent(BuildContext context) {
    if (userModel.id != "" && userModelMe.id != "") {
      return Container(
        padding: const EdgeInsets.only(top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: userModel.profileImage == Database.defaultValue
                  ? defaultProfileImage()
                  : profileImage(userModel.profileImage),
            ),
            Center(
              child: Container(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  userModel.name,
                  style: simpleTextStyle(
                    Variables.fontSizeMedium,
                    widget.darkTheme,
                  ),
                ),
              ),
            ),
            Center(
              child: Text(
                userModel.getUserName,
                style: simpleTextStyle(
                  Variables.fontSizeMedium,
                  widget.darkTheme,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        AppLocalizations.of(context).followers_profile,
                        style: simpleTextStyle(
                            Variables.fontSizeMedium, widget.darkTheme),
                      ),
                      Text(
                        FollowersDB.convertFollowNumbers(
                          context,
                          followerCount,
                        ),
                        style: simpleTextStyle(
                            Variables.fontSizeNormal, widget.darkTheme),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 40,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        AppLocalizations.of(context).following_profile,
                        style: simpleTextStyle(
                            Variables.fontSizeMedium, widget.darkTheme),
                      ),
                      Text(
                        FollowersDB.convertFollowNumbers(
                          context,
                          followCount,
                        ),
                        style: simpleTextStyle(
                            Variables.fontSizeNormal, widget.darkTheme),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Center(
              child: Container(
                padding: const EdgeInsets.only(
                  top: 10,
                ),
                child: user!.uid == userModel.id
                    ? customButton(
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
                        ? customButton(
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
                                          follower: user!.uid,
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
                        : customButton(
                            context,
                            darkTheme: widget.darkTheme,
                            text: AppLocalizations.of(context).follow_btn,
                            buttonStyle: ButtonStyleEnum.secondaryButton,
                            width: MediaQuery.of(context).size.width - 20,
                            borderRadius: Variables.buttonRadiusRound,
                            action: () async {
                              final followResult = await FollowersDB.follow(
                                  follower: user!.uid, following: userModel.id);
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
              child: Text(
                "Paylaşımlar",
                style: simpleTextStyle(
                  Variables.fontSizeMedium,
                  widget.darkTheme,
                ),
              ),
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
