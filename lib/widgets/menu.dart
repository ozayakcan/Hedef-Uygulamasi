import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../firebase/auth.dart';
import '../firebase/database/user_database.dart';
import '../models/user.dart';
import '../utils/colors.dart';
import '../utils/variables.dart';
import '../views/login.dart';
import '../views/settings.dart';
import 'widgets.dart';

class DrawerMenu extends StatefulWidget {
  const DrawerMenu(
      {Key? key, required this.darkTheme, this.showSettings = true})
      : super(key: key);

  final bool darkTheme;
  final bool showSettings;
  @override
  State<DrawerMenu> createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {
  FirebaseAuth auth = FirebaseAuth.instance;
  late User? user;
  UserModel userModel = UserModel.empty();
  StreamSubscription<DatabaseEvent>? userEvent;
  @override
  void initState() {
    setState(() {
      user = Auth.user;
    });
    DatabaseReference databaseReference = UserDB.getUserRef(user!.uid);
    userEvent = databaseReference.onValue.listen((event) {
      if (event.snapshot.exists) {
        final json = event.snapshot.value as Map<dynamic, dynamic>;
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
    return Drawer(
      child: Material(
        color: widget.darkTheme
            ? ThemeColorDark.backgroundPrimary
            : ThemeColor.backgroundPrimary,
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Center(
                child: Column(
                  children: [
                    userModel.name == ""
                        ? loadingRow(context, widget.darkTheme)
                        : Text(
                            userModel.name,
                            style: TextStyle(
                              color: widget.darkTheme
                                  ? ThemeColorDark.textPrimary
                                  : ThemeColor.textPrimary,
                              fontSize: Variables.fontSizeMedium,
                            ),
                            textAlign: TextAlign.center,
                          ),
                    const SizedBox(
                      height: 4,
                    ),
                    userModel.username == ""
                        ? loadingRow(context, widget.darkTheme)
                        : Text(
                            userModel.getUserName,
                            style: TextStyle(
                              color: widget.darkTheme
                                  ? ThemeColorDark.textPrimary
                                  : ThemeColor.textPrimary,
                              fontSize: Variables.fontSizeNormal,
                            ),
                            textAlign: TextAlign.center,
                          ),
                    const SizedBox(
                      height: 10,
                    ),
                    darkThemeSwitch(context, widget.darkTheme),
                  ],
                ),
              ),
            ),
            if (widget.showSettings)
              menuItem(
                context,
                widget.darkTheme,
                text: AppLocalizations.of(context).settings,
                icon: Icons.settings,
                action: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Settings(
                        darkTheme: widget.darkTheme,
                      ),
                    ),
                  );
                },
              ),
            menuItem(
              context,
              widget.darkTheme,
              text: AppLocalizations.of(context).logout,
              icon: Icons.logout,
              action: () {
                auth.signOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Login(
                      darkTheme: widget.darkTheme,
                    ),
                  ),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

Widget menuItem(
  BuildContext context,
  bool darkTheme, {
  required String text,
  required IconData icon,
  VoidCallback? action,
  bool closeMenu = true,
}) {
  return ListTile(
    leading: Icon(
      icon,
      color: darkTheme ? ThemeColorDark.textPrimary : ThemeColor.textPrimary,
    ),
    title: Text(
      text,
      style: TextStyle(
        color: darkTheme ? ThemeColorDark.textPrimary : ThemeColor.textPrimary,
      ),
    ),
    hoverColor: darkTheme
        ? ThemeColorDark.backgroundSecondary
        : ThemeColor.backgroundSecondary,
    onTap: () {
      if (closeMenu) {
        Navigator.pop(context);
      }
      if (action != null) {
        action();
      }
    },
  );
}
