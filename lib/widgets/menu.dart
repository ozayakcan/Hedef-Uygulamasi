import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../utils/auth.dart';
import '../utils/colors.dart';
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
  @override
  void initState() {
    super.initState();
    Auth.getUser(auth).then((value) {
      setState(() {
        user = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Material(
        color: MyColors.colorPrimary,
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Center(
                child: Column(
                  children: [
                    Text(
                      user!.displayName.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: Variables.mediumFontSize,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      user!.email.toString(),
                      style: TextStyle(
                        color: Colors.white,
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
    {required String text, required IconData icon, VoidCallback? action}) {
  const color = Colors.white;
  const hoverColor = Colors.white38;
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
      if (action != null) {
        action();
      }
    },
  );
}
