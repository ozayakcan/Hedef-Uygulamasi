import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hedef/utils/colors.dart';
import 'package:hedef/utils/variables.dart';

import '../utils/auth.dart';
import '../views/login.dart';

class DrawerMenu extends StatefulWidget {
  const DrawerMenu({Key? key, required this.redirectEnabled}) : super(key: key);

  final bool redirectEnabled;
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
            SizedBox(
              height: 48,
              child: Center(
                child: Column(children: [
                  Text(
                    user!.displayName.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: Variables.mediumFontSize,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    user!.email.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: Variables.normalFontSize,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ]),
              ),
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
  const hoverColor = Colors.white70;
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
