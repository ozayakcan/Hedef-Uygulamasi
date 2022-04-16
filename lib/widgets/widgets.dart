import 'dart:async';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:sosyal/firebase/database/posts_database.dart';
import 'package:sosyal/utils/time.dart';
import 'package:sosyal/widgets/buttons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../firebase/auth.dart';
import '../models/user.dart';
import '../utils/colors.dart';
import '../utils/shared_pref.dart';
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
    {double width = 15, double height = 15}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      SizedBox(
        width: width,
        height: height,
        child: CircularProgressIndicator(
          semanticsLabel: AppLocalizations.of(context).loading,
          color:
              darkTheme ? ThemeColorDark.textPrimary : ThemeColor.textPrimary,
        ),
      ),
      const SizedBox(
        width: 5,
      ),
      Text(
        AppLocalizations.of(context).loading,
        style: TextStyle(
          color:
              darkTheme ? ThemeColorDark.textPrimary : ThemeColor.textPrimary,
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
          activeColor:
              darkTheme ? ThemeColorDark.textPrimary : ThemeColor.textPrimary,
          activeTrackColor: darkTheme
              ? ThemeColorDark.textSecondary
              : ThemeColor.textSecondary,
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
        backgroundColor: darkTheme
            ? ThemeColorDark.alertBoxBackground
            : ThemeColor.alertBoxBackground,
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

loadingAlert(BuildContext context, bool darkTheme) {
  AlertDialog alert = AlertDialog(
    backgroundColor: darkTheme
        ? ThemeColorDark.backgroundPrimary
        : ThemeColor.backgroundPrimary,
    elevation: 0,
    content: SingleChildScrollView(
      child: ListBody(
        children: [
          loadingRow(context, darkTheme),
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
            username: user.username,
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

class PostWidget extends StatefulWidget {
  const PostWidget({
    Key? key,
    required this.darkTheme,
    required this.userModel,
    required this.postKey,
    required this.content,
    required this.dateTime,
    this.inProfile = true,
  }) : super(key: key);

  final bool darkTheme;
  final UserModel userModel;
  final String postKey;
  final String content;
  final DateTime dateTime;
  final bool inProfile;
  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  User user = Auth.user;
  int favoriteCount = 0;
  int commentCount = 0;
  bool isFavorited = false;

  StreamSubscription<DatabaseEvent>? favoritedEvent;
  StreamSubscription<DatabaseEvent>? favoriteEvent;
  StreamSubscription<DatabaseEvent>? commentEvent;

  @override
  void initState() {
    favoritedEvent =
        PostsDB.favoritedRef(widget.postKey, user.uid).onValue.listen((event) {
      if (event.snapshot.exists) {
        setState(() {
          isFavorited = true;
        });
      } else {
        setState(() {
          isFavorited = false;
        });
      }
    });
    favoriteEvent =
        PostsDB.getFavoritesRef(widget.postKey).onValue.listen((event) {
      if (event.snapshot.exists) {
        setState(() {
          favoriteCount = event.snapshot.children.length;
        });
      } else {
        setState(() {
          favoriteCount = 0;
        });
      }
    });
    commentEvent =
        PostsDB.getCommentsRef(widget.postKey).onValue.listen((event) {
      if (event.snapshot.exists) {
        setState(() {
          commentCount = event.snapshot.children.length;
        });
      } else {
        setState(() {
          commentCount = 0;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    favoritedEvent?.cancel();
    favoriteEvent?.cancel();
    commentEvent?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
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
                      if (!widget.inProfile) const SizedBox(width: 5),
                      if (!widget.inProfile)
                        profileImage(
                          widget.userModel.profileImage,
                          rounded: true,
                          width: 20,
                          height: 20,
                        ),
                      const SizedBox(
                        width: 5,
                      ),
                      InkWell(
                        onTap: () {
                          if (!widget.inProfile) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Profile(
                                  username: widget.userModel.username,
                                  darkTheme: widget.darkTheme,
                                  showAppBar: true,
                                ),
                              ),
                            );
                          }
                        },
                        child: Text(
                          widget.userModel.username,
                          style: linktTextStyle(
                              Variables.fontSizeNormal, widget.darkTheme),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        Time.of(context).elapsed(widget.dateTime),
                        style: simpleTextStyleSecondary(
                            Variables.fontSizeNormal, widget.darkTheme),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  SelectableLinkify(
                    onOpen: (link) {
                      onLinkOpen(context, link);
                    },
                    text: widget.content,
                    style: simpleTextStyle(
                        Variables.fontSizeNormal, widget.darkTheme),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 1),
          ],
        ),
        const SizedBox(
          height: 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            ToolTipButton(
              darkTheme: widget.darkTheme,
              tooltip: AppLocalizations.of(context).favorite_btn,
              text: favoriteCount.toString(),
              icon: isFavorited ? Icons.favorite : Icons.favorite_border,
              onPressed: () {
                ScaffoldSnackbar.of(context).show("Favori");
              },
            ),
            ToolTipButton(
              darkTheme: widget.darkTheme,
              tooltip: AppLocalizations.of(context).comment_btn,
              text: commentCount.toString(),
              icon: Icons.comment,
              onPressed: () {
                ScaffoldSnackbar.of(context).show("Yorum Yap");
              },
            ),
            ToolTipButton(
              darkTheme: widget.darkTheme,
              tooltip: AppLocalizations.of(context).share_btn,
              icon: Icons.share,
              onPressed: () {
                ScaffoldSnackbar.of(context).show("Paylaş");
              },
            ),
          ],
        ),
      ],
    );
  }
}

Future<void> onLinkOpen(BuildContext context, LinkableElement link) async {
  if (await canLaunch(link.url)) {
    await launch(link.url);
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
  required,
  ScrollController? controller,
}) {
  return RefreshIndicator(
    onRefresh: onRefresh,
    child: ScrollConfiguration(
      behavior: MyScrollBehavior(),
      child: ListView.builder(
        controller: controller,
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        itemCount: widgetList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: widgetList[index],
          );
        },
      ),
    ),
  );
}
