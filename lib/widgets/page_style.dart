import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../utils/theme_colors.dart';
import '../utils/variables.dart';
import 'texts.dart';

MaterialApp homeMaterialApp(Widget page, Locale locale, bool darkTheme) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      scaffoldBackgroundColor: ThemeColor.of(darkTheme).backgroundPrimary,
      primarySwatch: ThemeColor.of(darkTheme).backgroundSecondary,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      inputDecorationTheme: InputDecorationTheme(
        hintStyle:
            simpleTextStyleSecondary(Variables.fontSizeNormal, darkTheme),
      ),
      textTheme: TextTheme(
        headline6: simpleTextStyle(Variables.fontSizeNormal, darkTheme),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: ThemeColor.of(darkTheme).cursor,
        selectionColor: ThemeColor.of(darkTheme).selection,
      ),
    ),
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
    locale: locale,
    onGenerateTitle: (context) => AppLocalizations.of(context).app_name,
    home: page,
  );
}

PreferredSizeWidget defaultAppBar(
  BuildContext context,
  String title,
  bool darkTheme,
  bool showBackButton, {
  List<Widget>? actions,
}) {
  return AppBar(
    iconTheme: IconThemeData(
      color: ThemeColor.of(darkTheme).textPrimary,
    ),
    leading: leadingBuilder(context, showBackButton),
    title: appBarTitle(
      title,
      darkTheme,
    ),
    toolbarHeight: 50,
    actions: actions,
  );
}

Builder leadingBuilder(BuildContext context, bool showBackButton) {
  return Builder(
    builder: (context) {
      final ScaffoldState? scaffold = Scaffold.maybeOf(context);
      final ModalRoute<dynamic>? parentRoute = ModalRoute.of(context);
      final bool hasEndDrawer = scaffold?.hasEndDrawer ?? false;
      final bool canPop = parentRoute?.canPop ?? false;
      if (showBackButton) {
        if ((hasEndDrawer && canPop) || canPop) {
          return const BackButton();
        } else {
          return const SizedBox.shrink();
        }
      } else {
        return const SizedBox.shrink();
      }
    },
  );
}

Text appBarTitle(String title, bool darkTheme) {
  return Text(
    title,
    style: simpleTextStyle(Variables.fontSizeMedium, darkTheme),
  );
}

DefaultTabController defaultTabController(BuildContext context,
    List<Widget> tabList, List<Widget> tabContentList, bool darkTheme,
    {Widget? floatingActionButton, Widget? endDrawer}) {
  return DefaultTabController(
    length: 2,
    child: Scaffold(
      appBar: AppBar(
        title: appBarTitle(AppLocalizations.of(context).app_name, darkTheme),
        bottom: TabBar(
          labelStyle: titilliumWebTextStyle(
            ThemeColor.of(darkTheme).textPrimary,
            Variables.fontSizeNormal,
          ),
          unselectedLabelStyle: titilliumWebTextStyle(
            ThemeColor.of(darkTheme).textSecondary,
            Variables.fontSizeNormal,
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
  BuildContext context,
  bool darkTheme, {
  required String title,
  required Widget body,
  required bool showBackButton,
  Widget? floatingActionButton,
  BottomNavigationBar? bottomNavigationBar,
  List<Widget>? actions,
}) {
  return Scaffold(
    appBar: defaultAppBar(
      context,
      title,
      darkTheme,
      showBackButton,
      actions: actions,
    ),
    floatingActionButton: floatingActionButton,
    bottomNavigationBar: bottomNavigationBar,
    body: body,
  );
}
