import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';
import '../utils/auth.dart';
import '../utils/colors.dart';
import '../utils/database/user_database.dart';
import '../utils/shared_pref.dart';
import '../utils/variables.dart';
import '../utils/widget_drawer_model.dart';
import '../widgets/menu.dart';
import '../widgets/page_style.dart';
import '../widgets/texts.dart';
import 'profile.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
    required this.darkTheme,
  }) : super(key: key);
  final bool darkTheme;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  late User? user;
  late String username;
  StreamSubscription<DatabaseEvent>? userEvent;
  UserModel userModel = UserModel.empty();
  late SharedPreferences sp;

  late int selectedIndex = 0;

  @override
  void initState() {
    Auth.getUser(auth).then((value) {
      setState(() {
        user = value;
      });
      userEvent = UserDB.getUserRef(user!.uid).onValue.listen((event) {
        if (event.snapshot.exists) {
          final json = event.snapshot.value as Map<dynamic, dynamic>;
          setState(() {
            userModel = UserModel.fromJson(json);
          });
        }
      });
      SharedPreferences.getInstance().then((value) {
        setState(() {
          sp = value;
        });
      });
      Future(() async {
        await SharedPref.registerUser();
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    userEvent?.cancel();
  }

  List<WidgetModel> homeNavigations(
      BuildContext context, String username, bool darkTheme) {
    return [
      WidgetModel(
        context,
        Text(
          'Index 0: Anasayfa',
          style: simpleTextStyle(Variables.fontSizeNormal, widget.darkTheme),
        ),
      ),
      WidgetModel(
        context,
        Text(
          'Index 1: Paylaş',
          style: simpleTextStyle(Variables.fontSizeNormal, widget.darkTheme),
        ),
      ),
      WidgetModel(
        context,
        Profile(darkTheme: darkTheme, username: username),
      ),
    ];
  }

  void onItemTap(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return defaultScaffold(
      context,
      widget.darkTheme,
      title: AppLocalizations.of(context).app_name,
      body: homeNavigations(
        context,
        userModel.username,
        widget.darkTheme,
      ).elementAt(selectedIndex).widget,
      endDrawer: DrawerMenu(
        darkTheme: widget.darkTheme,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home_rounded),
            label: AppLocalizations.of(context).home,
            backgroundColor: widget.darkTheme
                ? ThemeColorDark.backgroundSecondary
                : ThemeColor.backgroundSecondary,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.add_circle_rounded),
            label: AppLocalizations.of(context).share,
            backgroundColor: widget.darkTheme
                ? ThemeColorDark.backgroundSecondary
                : ThemeColor.backgroundSecondary,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.account_circle_rounded),
            label: AppLocalizations.of(context).profile,
            backgroundColor: widget.darkTheme
                ? ThemeColorDark.backgroundSecondary
                : ThemeColor.backgroundSecondary,
          ),
        ],
        type: BottomNavigationBarType.shifting,
        showUnselectedLabels: false,
        currentIndex: selectedIndex,
        selectedItemColor: widget.darkTheme
            ? ThemeColorDark.textSecondary
            : ThemeColor.textSecondary,
        unselectedItemColor: widget.darkTheme
            ? ThemeColorDark.textPrimary
            : ThemeColor.textPrimary,
        onTap: (index) {
          onItemTap(index);
        },
      ),
    );
  }
}
