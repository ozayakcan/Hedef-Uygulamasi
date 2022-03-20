import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../utils/variables.dart';
import '../widgets/menu.dart';
import '../widgets/page_style.dart';
import '../widgets/texts.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key, required this.darkTheme}) : super(key: key);

  final bool darkTheme;

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return defaultScaffold(
      context,
      widget.darkTheme,
      title: AppLocalizations.of(context).settings,
      body: Text(
        "Ayarlar Sayfası",
        style: simpleTextStyle(Variables.fontSizeNormal, widget.darkTheme),
      ),
      endDrawer: DrawerMenu(
        darkTheme: widget.darkTheme,
        showSettings: false,
      ),
    );
  }
}
