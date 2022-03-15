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
      {Key? key, required this.redirectEnabled, this.showSettings = true})
      : super(key: key);

  final bool redirectEnabled;
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
    Future(() async {
      DatabaseReference? nameReference = await Database.getReference(
          Database.usersString + "/" + user!.uid + "/" + Database.nameString);
      nameEvent = nameReference!.onValue.listen((event) {
        if (event.snapshot.exists) {
          setState(() {
            name = event.snapshot.value != null
                ? event.snapshot.value.toString()
                : "";
          });
        }
      });
      DatabaseReference? usernameReference = await Database.getReference(
          Database.usersString +
              "/" +
              user!.uid +
              "/" +
              Database.usernameString);
      usernameEvent = usernameReference!.onValue.listen((event) {
        if (event.snapshot.exists) {
          setState(() {
            username = event.snapshot.value != null
                ? event.snapshot.value.toString()
                : "";
          });
        }
      });
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
        color: ThemeColor.backgroundPrimary,
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Center(
                child: Column(
                  children: [
                    name == ""
                        ? loadingRow(context)
                        : Text(
                            name,
                            style: TextStyle(
                              color: ThemeColor.textPrimary,
                              fontSize: Variables.mediumFontSize,
                            ),
                            textAlign: TextAlign.center,
                          ),
                    const SizedBox(
                      height: 4,
                    ),
                    username == ""
                        ? loadingRow(context)
                        : Text(
                            "(@" + username + ")",
                            style: TextStyle(
                              color: ThemeColor.textPrimary,
                              fontSize: Variables.normalFontSize,
                            ),
                            textAlign: TextAlign.center,
                          ),
                  ],
                ),
              ),
            ),
            if (widget.showSettings)
              menuItem(
                context,
                text: AppLocalizations.of(context).settings,
                icon: Icons.settings,
                action: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Settings(),
                    ),
                  );
                },
              ),
            menuItem(
              context,
              text: AppLocalizations.of(context).logout,
              icon: Icons.logout,
              action: () {
                auth.signOut();
                if (!widget.redirectEnabled) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Login(
                        redirectEnabled: false,
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
  BuildContext context, {
  required String text,
  required IconData icon,
  VoidCallback? action,
  bool closeMenu = true,
}) {
  const color = ThemeColor.textPrimary;
  const hoverColor = ThemeColor.backgroundSecondary;
  return ListTile(
    leading: Icon(
      icon,
      color: color,
    ),
    title: Text(
      text,
      style: const TextStyle(color: color),
    ),
    hoverColor: hoverColor,
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
