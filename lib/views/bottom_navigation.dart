import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../firebase/auth.dart';
import '../firebase/database/user_database.dart';
import '../models/user.dart';
import '../utils/colors.dart';
import '../utils/search.dart';
import '../utils/shared_pref.dart';
import '../utils/variables.dart';
import '../models/widget.dart';
import '../widgets/images.dart';
import '../widgets/page_style.dart';
import '../widgets/texts.dart';
import 'profile.dart';

class BottomNavigationPage extends StatefulWidget {
  const BottomNavigationPage({
    Key? key,
    required this.darkTheme,
    required this.showSearchbar,
    required this.widgetModel,
    this.menu,
  }) : super(key: key);

  final bool darkTheme;
  final bool showSearchbar;
  final Widget? menu;
  final WidgetModel widgetModel;

  @override
  State<BottomNavigationPage> createState() => _BottomNavigationPageState();
}

class _BottomNavigationPageState extends State<BottomNavigationPage> {
  late User? user;
  StreamSubscription<DatabaseEvent>? userEvent;
  UserModel userModel = UserModel.empty();
  late SharedPreferences sp;

  double size = 24;

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
      widget.widgetModel,
      WidgetModel(
        context,
        title: AppLocalizations.of(context).share,
        child: Text(
          'Favoriler',
          style: simpleTextStyle(Variables.fontSizeNormal, widget.darkTheme),
        ),
        showBackButton: false,
      ),
      WidgetModel(
        context,
        title: AppLocalizations.of(context).profile,
        child: Profile(
          darkTheme: darkTheme,
          username: username,
          showAppBar: false,
        ),
        showBackButton: false,
      ),
    ];
  }

  void onItemTap(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  String getTitle(BuildContext context, String username, bool darkTheme) {
    return homeNavigations(context, username, darkTheme)
        .elementAt(selectedIndex)
        .title;
  }

  @override
  Widget build(BuildContext context) {
    title = getTitle(context, userModel.username, widget.darkTheme);
    return defaultScaffold(
      context,
      widget.darkTheme,
      title: title,
      showBackButton: homeNavigations(
        context,
        userModel.username,
        widget.darkTheme,
      ).elementAt(selectedIndex).showBackButton,
      body: homeNavigations(
        context,
        userModel.username,
        widget.darkTheme,
      ).elementAt(selectedIndex).widget,
      actions: [
        if (widget.showSearchbar)
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: MySearchDelegate(widget.darkTheme, userModel.id),
              );
            },
            icon: Icon(
              Icons.search,
              color: widget.darkTheme
                  ? ThemeColorDark.textPrimary
                  : ThemeColor.textPrimary,
            ),
          ),
        if (widget.menu != null) widget.menu!,
      ],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: SizedBox(
              width: size,
              height: size,
              child: const Icon(Icons.home_rounded),
            ),
            label: AppLocalizations.of(context).home,
            backgroundColor: widget.darkTheme
                ? ThemeColorDark.backgroundSecondary
                : ThemeColor.backgroundSecondary,
          ),
          BottomNavigationBarItem(
            icon: SizedBox(
              width: size,
              height: size,
              child: const Icon(Icons.favorite_rounded),
            ),
            label: AppLocalizations.of(context).favorites,
            backgroundColor: widget.darkTheme
                ? ThemeColorDark.backgroundSecondary
                : ThemeColor.backgroundSecondary,
          ),
          BottomNavigationBarItem(
            icon: SizedBox(
              width: size,
              height: size,
              child: profileImage(
                userModel.profileImage,
                rounded: true,
                width: size,
                height: size,
              ),
            ),
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
          setState(() {
            title = getTitle(context, userModel.username, widget.darkTheme);
          });
        },
      ),
    );
  }
}
