import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sosyal/widgets/buttons.dart';

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
  StreamSubscription<DatabaseEvent>? userEvent;
  UserModel userModel = UserModel.empty();
  late SharedPreferences sp;

  int selectedIndex = 0;
  String title = "";

  @override
  void initState() {
    setState(() {
      user = Auth.user;
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
        AppLocalizations.of(context).app_name,
        customButton(context,
            text: "Örnek Profil",
            buttonStyle: ButtonStyleEnum.primaryButton,
            darkTheme: darkTheme, action: () {
          if (kDebugMode) {
            print("Kullanıcı ADI: " + userModel.username);
          }
          if (userModel.username == "ozayakcan") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Profile(
                  darkTheme: darkTheme,
                  username: "Hel7cFNt6FYN4f1CQExEu187GT92",
                  showAppBar: true,
                ),
              ),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Profile(
                  darkTheme: darkTheme,
                  username: "ozayakcan",
                  showAppBar: true,
                ),
              ),
            );
          }
        }),
      ),
      WidgetModel(
        context,
        AppLocalizations.of(context).share,
        Text(
          'Index 1: Paylaş',
          style: simpleTextStyle(Variables.fontSizeNormal, widget.darkTheme),
        ),
      ),
      WidgetModel(
        context,
        AppLocalizations.of(context).profile,
        Profile(
          darkTheme: darkTheme,
          username: username,
          showAppBar: false,
        ),
      ),
    ];
  }

  void onItemTap(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  updateTitle(BuildContext context, String username, bool darkTheme) {
    setState(() {
      title = homeNavigations(context, username, darkTheme)
          .elementAt(selectedIndex)
          .name;
    });
  }

  @override
  Widget build(BuildContext context) {
    updateTitle(context, userModel.username, widget.darkTheme);
    return defaultScaffold(
      context,
      widget.darkTheme,
      title: title,
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
          updateTitle(context, userModel.username, widget.darkTheme);
        },
      ),
    );
  }
}
