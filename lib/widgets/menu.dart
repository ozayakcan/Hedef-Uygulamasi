import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sosyal/widgets/widgets.dart';

import '../utils/auth.dart';
import '../utils/colors.dart';
import '../utils/database.dart';
import '../utils/variables.dart';
import '../views/login.dart';
import '../views/settings.dart';

class DrawerMenu extends StatefulWidget {
  const DrawerMenu(
      {Key? key,
      required this.redirectEnabled,
      required this.darkTheme,
      this.showSettings = true})
      : super(key: key);

  final bool redirectEnabled;
  final bool darkTheme;
  final bool showSettings;
  @override
  State<DrawerMenu> createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {
  FirebaseAuth auth = FirebaseAuth.instance;
  late User? user;
  String username = "";
  String name = "";
  StreamSubscription<DatabaseEvent>? nameEvent;
  StreamSubscription<DatabaseEvent>? usernameEvent;
  @override
  void initState() {
    setState(() {
      user = Auth.user;
    });
    Database.getReference(
            Database.usersString + "/" + user!.uid + "/" + Database.nameString)
        .then((value) {
      if (value != null) {
        nameEvent = value.onValue.listen((event) {
          if (event.snapshot.exists) {
            setState(() {
              name = event.snapshot.value != null
                  ? event.snapshot.value.toString()
                  : "";
            });
          }
        });
      }
    });
    Database.getReference(Database.usersString +
            "/" +
            user!.uid +
            "/" +
            Database.usernameString)
        .then((value) {
      if (value != null) {
        usernameEvent = value.onValue.listen((event) {
          if (event.snapshot.exists) {
            setState(() {
              username = event.snapshot.value != null
                  ? event.snapshot.value.toString()
                  : "";
            });
          }
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    nameEvent?.cancel();
    usernameEvent?.cancel();
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
                    name == ""
                        ? loadingRow(context, widget.darkTheme)
                        : Text(
                            name,
                            style: TextStyle(
                              color: widget.darkTheme
                                  ? ThemeColorDark.textPrimary
                                  : ThemeColor.textPrimary,
                              fontSize: Variables.mediumFontSize,
                            ),
                            textAlign: TextAlign.center,
                          ),
                    const SizedBox(
                      height: 4,
                    ),
                    username == ""
                        ? loadingRow(context, widget.darkTheme)
                        : Text(
                            "(@" + username + ")",
                            style: TextStyle(
                              color: widget.darkTheme
                                  ? ThemeColorDark.textPrimary
                                  : ThemeColor.textPrimary,
                              fontSize: Variables.normalFontSize,
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
                if (!widget.redirectEnabled) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Login(
                        redirectEnabled: false,
                        darkTheme: widget.darkTheme,
                      ),
                    ),
                    (route) => false,
                  );
                }
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
