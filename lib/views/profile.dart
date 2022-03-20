import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../models/user.dart';
import '../utils/auth.dart';
import '../utils/database/database.dart';
import '../utils/database/user_database.dart';
import '../utils/variables.dart';
import '../widgets/buttons.dart';
import '../widgets/images.dart';
import '../widgets/texts.dart';
import '../widgets/widgets.dart';

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
  UserModel userModel = UserModel.empty();
  @override
  void initState() {
    setState(() {
      user = Auth.user;
    });
    Query userQuery = UserDB.getUserQuery(widget.username);
    userEvent = userQuery.onValue.listen((event) {
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
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    userEvent?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    if (userModel.id != "") {
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
                    Variables.mediumFontSize,
                    widget.darkTheme,
                  ),
                ),
              ),
            ),
            Center(
              child: Text(
                userModel.getUserName,
                style: simpleTextStyle(
                  Variables.mediumFontSize,
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
                        text: AppLocalizations.of(context).edit_profile,
                        buttonStyle: ButtonStyleEnum.defaultButton,
                        width: MediaQuery.of(context).size.width - 20,
                        borderRadius: Variables.roundButtonRadius,
                      )
                    : customButton(
                        context,
                        text: AppLocalizations.of(context).follow,
                        buttonStyle: ButtonStyleEnum.primaryButton,
                        width: MediaQuery.of(context).size.width - 20,
                        borderRadius: Variables.roundButtonRadius,
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
                  Variables.mediumFontSize,
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
