import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../models/user.dart';
import '../utils/shared_pref.dart';
import '../utils/theme_colors.dart';
import '../utils/time.dart';
import '../utils/variables.dart';
import '../views/profile.dart';
import 'images.dart';
import 'texts.dart';

class ScaffoldSnackbar {
  ScaffoldSnackbar(this.context);
  final BuildContext context;

  factory ScaffoldSnackbar.of(BuildContext context) {
    return ScaffoldSnackbar(context);
  }
  void show(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message)),
      );
  }
}

Scaffold formPage(
  BuildContext context,
  List<Widget> list,
) {
  return Scaffold(
    body: SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        alignment: Alignment.bottomCenter,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: formList(list),
          ),
        ),
      ),
    ),
  );
}

List<Widget> formList(List<Widget> oldList) {
  List<Widget> newList = [];
  for (int i = 0; i < oldList.length; i++) {
    newList.add(oldList[i]);
    newList.add(
      SizedBox(
        height: (i >= oldList.length - 1) ? 40 : 10,
      ),
    );
  }
  return newList;
}

Widget loadingRow(BuildContext context, bool darkTheme,
    {double width = 15, double height = 15, String? text}) {
  text ??= AppLocalizations.of(context).loading;
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      SizedBox(
        width: width,
        height: height,
        child: CircularProgressIndicator(
          semanticsLabel: text,
          color: ThemeColor.of(darkTheme).textPrimary,
        ),
      ),
      const SizedBox(
        width: 5,
      ),
      Text(
        text,
        style: TextStyle(
          color: ThemeColor.of(darkTheme).textPrimary,
          fontSize: Variables.fontSizeMedium,
        ),
        textAlign: TextAlign.center,
      )
    ],
  );
}

Widget darkThemeSwitch(BuildContext context, bool darkTheme) {
  return Center(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppLocalizations.of(context).dark_theme,
          style: simpleTextStyle(
            Variables.fontSizeMedium,
            darkTheme,
          ),
        ),
        const SizedBox(
          width: 5,
        ),
        Switch(
          value: darkTheme,
          onChanged: (value) {
            SharedPref.setDarkThemeRestart(context, value);
          },
          activeColor: ThemeColor.of(darkTheme).textPrimary,
          activeTrackColor: ThemeColor.of(darkTheme).textSecondary,
        ),
      ],
    ),
  );
}

Future<void> defaultAlertbox(
  BuildContext _context, {
  required String title,
  required List<Widget> descriptions,
  required bool darkTheme,
  bool dismissible = true,
  VoidCallback? actionOk,
  VoidCallback? actionYes,
  VoidCallback? actionNo,
  VoidCallback? actionCancel,
}) {
  return showDialog(
    context: _context,
    barrierDismissible: dismissible,
    builder: (context) {
      return AlertDialog(
        backgroundColor: ThemeColor.of(darkTheme).alertBoxBackground,
        title: Text(
          title,
          style: simpleTextStyle(Variables.fontSizeMedium, darkTheme),
        ),
        content: SingleChildScrollView(
          child: ListBody(
            children: descriptions,
          ),
        ),
        actions: [
          if (actionOk != null)
            TextButton(
              onPressed: () {
                actionOk();
                Navigator.pop(context);
              },
              child: Text(
                AppLocalizations.of(context).ok,
                style: simpleTextStyle(Variables.fontSizeNormal, darkTheme),
              ),
            ),
          if (actionYes != null)
            TextButton(
              onPressed: () {
                actionYes();
                Navigator.pop(context);
              },
              child: Text(
                AppLocalizations.of(context).yes,
                style: simpleTextStyle(Variables.fontSizeNormal, darkTheme),
              ),
            ),
          if (actionNo != null)
            TextButton(
              onPressed: () {
                actionNo();
                Navigator.pop(context);
              },
              child: Text(
                AppLocalizations.of(context).no,
                style: simpleTextStyle(Variables.fontSizeNormal, darkTheme),
              ),
            ),
          if (actionCancel != null)
            TextButton(
              onPressed: () {
                actionCancel();
                Navigator.pop(context);
              },
              child: Text(
                AppLocalizations.of(context).cancel,
                style: simpleTextStyle(Variables.fontSizeNormal, darkTheme),
              ),
            ),
        ],
      );
    },
  );
}

loadingAlert(BuildContext context, bool darkTheme, {String? text}) {
  text ??= AppLocalizations.of(context).loading;
  AlertDialog alert = AlertDialog(
    backgroundColor: ThemeColor.of(darkTheme).backgroundPrimary,
    elevation: 0,
    content: SingleChildScrollView(
      child: ListBody(
        children: [
          loadingRow(
            context,
            darkTheme,
            text: text,
          ),
        ],
      ),
    ),
  );
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

Widget profilePreview(
  BuildContext context, {
  required bool darkTheme,
  required UserModel user,
  String query = "",
  VoidCallback? beforeClicked,
}) {
  return InkWell(
    onTap: () {
      if (beforeClicked != null) {
        beforeClicked();
      }
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Profile(
            darkTheme: darkTheme,
            userID: user.id,
            showAppBar: true,
          ),
        ),
      );
    },
    child: Padding(
      padding: EdgeInsets.all(Variables.paddingDefault),
      child: Row(
        children: [
          profileImage(user.profileImage, rounded: true, width: 50, height: 50),
          const SizedBox(
            width: 5,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              highlightTextWidget(
                user.name,
                query,
                darkTheme: darkTheme,
                style: simpleTextStyle(Variables.fontSizeMedium, darkTheme),
              ),
              highlightTextWidget(
                user.getUserNameAt,
                query,
                darkTheme: darkTheme,
                style: simpleTextStyle(Variables.fontSizeMedium, darkTheme),
              ),
            ],
          )
        ],
      ),
    ),
  );
}

Future<void> onLinkOpen(BuildContext context, LinkableElement link) async {
  if (await canLaunchUrlString(link.url)) {
    await launchUrlString(link.url);
  } else {
    ScaffoldSnackbar.of(context)
        .show(AppLocalizations.of(context).can_not_open_links);
  }
}

class MyScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

Widget refreshableListView({
  required List<Widget> widgetList,
  required Future<void> Function() onRefresh,
  ScrollController? controller,
}) {
  return RefreshIndicator(
    onRefresh: onRefresh,
    child: ScrollConfiguration(
      behavior: MyScrollBehavior(),
      child: listView(
        widgetList: widgetList,
      ),
    ),
  );
}

ListView listView({
  required List<Widget> widgetList,
  ScrollController? controller,
}) {
  return ListView.builder(
    controller: controller,
    physics:
        const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
    itemCount: widgetList.length,
    itemBuilder: (context, index) {
      return ListTile(
        title: widgetList[index],
      );
    },
  );
}

Widget contentWidget({
  required BuildContext context,
  required bool darkTheme,
  required bool inProfile,
  required UserModel userModel,
  required DateTime date,
  required bool showContent,
  required String content,
}) {
  return Row(
    children: [
      const SizedBox(width: 1),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (!inProfile) const SizedBox(width: 5),
                if (!inProfile)
                  profileImage(
                    userModel.profileImage,
                    rounded: true,
                    width: 20,
                    height: 20,
                  ),
                const SizedBox(
                  width: 5,
                ),
                InkWell(
                  onTap: () {
                    if (!inProfile) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Profile(
                            userID: userModel.id,
                            darkTheme: darkTheme,
                            showAppBar: true,
                          ),
                        ),
                      );
                    }
                  },
                  child: Text(
                    userModel.username,
                    style: linktTextStyle(
                      Variables.fontSizeNormal,
                      darkTheme,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  Time.of(context).elapsed(date),
                  style: simpleTextStyleSecondary(
                      Variables.fontSizeNormal, darkTheme),
                ),
              ],
            ),
            if (showContent)
              const SizedBox(
                height: 2,
              ),
            if (showContent)
              SelectableLinkify(
                onOpen: (link) {
                  onLinkOpen(context, link);
                },
                text: content,
                style: simpleTextStyle(Variables.fontSizeNormal, darkTheme),
              ),
          ],
        ),
      ),
      const SizedBox(width: 1),
    ],
  );
}

void showBottomFormModal({
  required BuildContext context,
  required bool darkTheme,
  required String title,
  required VoidCallback? onSave,
  required List<Widget> children,
}) {
  double space = 10;
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: EdgeInsets.all(space),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: simpleTextStyle(Variables.fontSizeMedium, darkTheme),
              ),
              SizedBox(
                height: space,
              ),
              Column(
                children: children,
              ),
              SizedBox(
                height: space,
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      AppLocalizations.of(context).cancel.toUpperCase(),
                      style: linktTextStyle(
                        Variables.fontSizeMedium,
                        darkTheme,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  InkWell(
                    onTap: () {
                      onSave?.call();
                    },
                    child: Text(
                      AppLocalizations.of(context).save.toUpperCase(),
                      style: linktTextStyle(
                        Variables.fontSizeMedium,
                        darkTheme,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      );
    },
  );
}
