import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sosyal/widgets/page_style.dart';

import '../models/user.dart';
import '../utils/assets.dart';
import '../utils/auth.dart';
import '../utils/database/database.dart';
import '../utils/database/followers_database.dart';
import '../utils/database/user_database.dart';
import '../utils/variables.dart';
import '../widgets/buttons.dart';
import '../widgets/images.dart';
import '../widgets/menu.dart';
import '../widgets/texts.dart';
import '../widgets/widgets.dart';
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
  bool isButtonsEnabled = true;
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
        FollowersDB.checkFollowing(follower: user!.uid, followed: userModel.id)
            .then((value) {
          setState(() {
            isFollowing = value;
          });
        });
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
                            text: AppLocalizations.of(context).following,
                            buttonStyle: ButtonStyleEnum.primaryButton,
                            width: MediaQuery.of(context).size.width - 20,
                            borderRadius: Variables.buttonRadiusRound,
                            action: () {
                              if (isButtonsEnabled) {
                                setState(() {
                                  isButtonsEnabled = false;
                                });
                                FollowersDB.unfollow(
                                        follower: user!.uid,
                                        followed: userModel.id)
                                    .then((value) {
                                  if (value == null) {
                                    setState(() {
                                      isFollowing = false;
                                      isButtonsEnabled = true;
                                    });
                                  }
                                });
                              } else {
                                ScaffoldSnackbar.of(context).show(
                                    AppLocalizations.of(context).wait_a_moment);
                              }
                            },
                          )
                        : customButton(
                            context,
                            darkTheme: widget.darkTheme,
                            text: AppLocalizations.of(context).follow,
                            buttonStyle: ButtonStyleEnum.secondaryButton,
                            width: MediaQuery.of(context).size.width - 20,
                            borderRadius: Variables.buttonRadiusRound,
                            action: () {
                              if (isButtonsEnabled) {
                                setState(() {
                                  isButtonsEnabled = false;
                                });
                                FollowersDB.follow(
                                        follower: user!.uid,
                                        followed: userModel.id)
                                    .then((value) {
                                  if (value == null) {
                                    setState(() {
                                      isFollowing = true;
                                      isButtonsEnabled = true;
                                    });
                                  }
                                });
                              } else {
                                ScaffoldSnackbar.of(context).show(
                                    AppLocalizations.of(context).wait_a_moment);
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
      return defaultScaffold(
        context,
        widget.darkTheme,
        title: userModel.getUserName,
        body: profileContent(context),
        endDrawer: DrawerMenu(
          darkTheme: widget.darkTheme,
          showSettings: false,
        ),
      );
    } else {
      return profileContent(context);
    }
  }
}
