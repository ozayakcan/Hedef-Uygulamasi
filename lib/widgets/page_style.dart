import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sosyal/widgets/menu.dart';

import '../utils/colors.dart';
import '../utils/variables.dart';
import 'texts.dart';

MaterialApp homeMaterialApp(Widget page) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      scaffoldBackgroundColor: Colors.white,
      primarySwatch: MyColors.colorPrimary,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
    onGenerateTitle: (context) => AppLocalizations.of(context).app_name,
    home: page,
  );
}

PreferredSizeWidget defaultAppBar(BuildContext context, String title) {
  return AppBar(
    iconTheme: const IconThemeData(
      color: Colors.white,
    ),
    leading: leadingBuilder(context),
    title: appBarTitle(
      title,
    ),
    toolbarHeight: 50,
  );
}

Builder leadingBuilder(BuildContext context) {
  return Builder(
    builder: (context) {
      final ScaffoldState? scaffold = Scaffold.maybeOf(context);
      final ModalRoute<dynamic>? parentRoute = ModalRoute.of(context);
      final bool hasEndDrawer = scaffold?.hasEndDrawer ?? false;
      final bool canPop = parentRoute?.canPop ?? false;
      if (hasEndDrawer && canPop) {
        return const BackButton();
      } else {
        return const SizedBox.shrink();
      }
    },
  );
}

Text appBarTitle(String title) {
  return Text(
    title,
    style: simpleTextStyleWhite(Variables.mediumFontSize),
  );
}

DefaultTabController defaultTabController(
    BuildContext context, List<Widget> tabList, List<Widget> tabContentList,
    {Widget? floatingActionButton, Widget? endDrawer}) {
  return DefaultTabController(
    length: 2,
    child: Scaffold(
      appBar: AppBar(
        title: appBarTitle(AppLocalizations.of(context).app_name),
        bottom: TabBar(
          labelStyle: titilliumWebTextStyle(
            Colors.white,
            Variables.normalFontSize,
          ),
          unselectedLabelStyle: titilliumWebTextStyle(
            Colors.white70,
            Variables.normalFontSize,
          ),
          tabs: tabList,
        ),
      ),
      endDrawer: endDrawer,
      floatingActionButton: floatingActionButton,
      body: TabBarView(
        children: tabContentList,
      ),
    ),
  );
}

Scaffold defaultScaffold(
  BuildContext context, {
  required String title,
  required Widget body,
  Widget? floatingActionButton,
  Widget? endDrawer,
  BottomNavigationBar? bottomNavigationBar,
}) {
  return Scaffold(
    appBar: defaultAppBar(
      context,
      title,
    ),
    endDrawer: endDrawer,
    floatingActionButton: floatingActionButton,
    bottomNavigationBar: bottomNavigationBar,
    body: body,
  );
}
