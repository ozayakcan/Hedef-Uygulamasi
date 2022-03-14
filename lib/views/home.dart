import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sosyal/utils/widget_drawer_model.dart';

import '../utils/auth.dart';
import '../utils/colors.dart';
import '../utils/variables.dart';
import '../widgets/menu.dart';
import '../widgets/page_style.dart';
import '../widgets/texts.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.redirectEnabled}) : super(key: key);
  final bool redirectEnabled;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  late User? user;

  int _selectedIndex = 0;
  @override
  void initState() {
    super.initState();
    Auth.getUser(auth).then((value) {
      setState(() {
        user = value;
      });
    });
  }

  List<WidgetModel> homeNavigations({bool redirectEnabled = true}) {
    return [
      WidgetModel(
        Text(
          'Index 0: Anasayfa',
          style: simpleTextStyle(Variables.normalFontSize),
        ),
        const SizedBox.shrink(),
        false,
      ),
      WidgetModel(
        Text(
          'Index 1: Paylaş',
          style: simpleTextStyle(Variables.normalFontSize),
        ),
        DrawerMenu(redirectEnabled: redirectEnabled),
        true,
      ),
      WidgetModel(
        Text(
          'Index 1: Profil',
          style: simpleTextStyle(Variables.normalFontSize),
        ),
        DrawerMenu(redirectEnabled: redirectEnabled),
        true,
      ),
    ];
  }

  void onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: user!.emailVerified
              ? MediaQuery.of(context).size.height
              : MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: defaultScaffold(
            context,
            title: AppLocalizations.of(context).app_name,
            body: homeNavigations(redirectEnabled: widget.redirectEnabled)
                .elementAt(_selectedIndex)
                .widget,
            endDrawer: homeNavigations(redirectEnabled: widget.redirectEnabled)
                    .elementAt(_selectedIndex)
                    .showDrawer
                ? homeNavigations(redirectEnabled: widget.redirectEnabled)
                    .elementAt(_selectedIndex)
                    .drawer
                : null,
            bottomNavigationBar: BottomNavigationBar(
              items: [
                BottomNavigationBarItem(
                  icon: const Icon(Icons.home_rounded),
                  label: AppLocalizations.of(context).home,
                  backgroundColor: MyColors.colorPrimary,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.add_circle_rounded),
                  label: AppLocalizations.of(context).share,
                  backgroundColor: MyColors.colorPrimary,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.account_circle_rounded),
                  label: AppLocalizations.of(context).profile,
                  backgroundColor: MyColors.colorPrimary,
                ),
              ],
              type: BottomNavigationBarType.shifting,
              showUnselectedLabels: false,
              currentIndex: _selectedIndex,
              selectedItemColor: Colors.white70,
              unselectedItemColor: Colors.white,
              onTap: (index) {
                onItemTap(index);
              },
            ),
          ),
        ),
      ],
    );
  }
}
