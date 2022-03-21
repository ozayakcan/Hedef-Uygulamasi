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
import '../widgets/buttons.dart';
import '../widgets/images.dart';
import '../widgets/texts.dart';
import '../widgets/widgets.dart';
import 'edit_profile.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key, required this.darkTheme, required this.username})
      : super(key: key);

  final bool darkTheme;
  final String username;
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late User? user;
  StreamSubscription<DatabaseEvent>? userEvent;
  StreamSubscription<DatabaseEvent>? userEventMe;
  StreamSubscription<DatabaseEvent>? followingEvent;
  UserModel userModel = UserModel.empty();
  UserModel userModelMe = UserModel.empty();
  bool isFollowing = false;
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
      }
    });
    followingEvent = FollowersDB.getFollowQuery(user!.uid,
            isFollower: true, singleValue: true, seconUserId: userModel.id)
        .onValue
        .listen((event) {
      setState(() {
        isFollowing = event.snapshot.exists;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    userEvent?.cancel();
    userEventMe?.cancel();
    followingEvent?.cancel();
  }

  @override
  Widget build(BuildContext context) {
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
                            text: AppLocalizations.of(context).follow,
                            buttonStyle: ButtonStyleEnum.primaryButton,
                            width: MediaQuery.of(context).size.width - 20,
                            borderRadius: Variables.buttonRadiusRound,
                          )
                        : customButton(
                            context,
                            darkTheme: widget.darkTheme,
                            text: AppLocalizations.of(context).following,
                            buttonStyle: ButtonStyleEnum.secondaryButton,
                            width: MediaQuery.of(context).size.width - 20,
                            borderRadius: Variables.buttonRadiusRound,
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
}
