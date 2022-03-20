import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/auth.dart';
import '../utils/colors.dart';
import '../utils/shared_pref.dart';
import '../utils/variables.dart';
import '../utils/widget_drawer_model.dart';
import '../widgets/menu.dart';
import '../widgets/page_style.dart';
import '../widgets/texts.dart';

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

  late SharedPreferences sp;

  late int selectedIndex = 0;

  @override
  void initState() {
    Auth.getUser(auth).then((value) {
      setState(() {
        user = value;
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

  List<WidgetModel> homeNavigations(BuildContext context) {
    return [
      WidgetModel(
        context,
        Text(
          'Index 0: Anasayfa',
          style: simpleTextStyle(Variables.normalFontSize, widget.darkTheme),
        ),
      ),
      WidgetModel(
        context,
        Text(
          'Index 1: Paylaş',
          style: simpleTextStyle(Variables.normalFontSize, widget.darkTheme),
        ),
      ),
      WidgetModel(
        context,
        Text(
          'Index 1: Profil',
          style: simpleTextStyle(Variables.normalFontSize, widget.darkTheme),
        ),
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
