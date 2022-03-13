import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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
    title: "Hedef",
    home: page,
  );
}

PreferredSizeWidget appBarMain(String title) {
  return AppBar(
    title: appBarTitle(
      title,
    ),
    toolbarHeight: 50,
  );
}

PreferredSizeWidget defaultAppBar(BuildContext context, String title) {
  return AppBar(
    iconTheme: const IconThemeData(
      color: Colors.white,
    ),
    title: appBarTitle(
      title,
    ),
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

Scaffold defaultScaffold(BuildContext context,
    {required String title,
    required Widget body,
    Widget? floatingActionButton,
    Widget? endDrawer}) {
  return Scaffold(
    appBar: defaultAppBar(
      context,
      title,
    ),
    endDrawer: endDrawer,
    floatingActionButton: floatingActionButton,
    body: body,
  );
}
