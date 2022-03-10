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

Container appBarTitle(String title) {
  return Container(
    margin: const EdgeInsets.only(left: 10),
    child: Text(
      title,
      style: simpleTextStyleWhite(Variables.mediumFontSize),
    ),
  );
}

DefaultTabController defaultTabController(BuildContext context,
    List<Widget> tabList, List<Widget> tabContentList, List<Widget> menu) {
  return DefaultTabController(
    length: 2,
    child: Scaffold(
      appBar: AppBar(
        title: appBarTitle(AppLocalizations.of(context).app_name),
        actions: menu,
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
      body: TabBarView(
        children: tabContentList,
      ),
    ),
  );
}
