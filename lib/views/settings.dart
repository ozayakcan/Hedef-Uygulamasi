import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../utils/variables.dart';
import '../utils/widget_drawer_model.dart';
import '../widgets/texts.dart';
import 'bottom_navigation.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key, required this.darkTheme}) : super(key: key);

  final bool darkTheme;

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationPage(
      darkTheme: widget.darkTheme,
      widgetModel: WidgetModel(
        context,
        title: AppLocalizations.of(context).settings,
        child: Text(
          "Ayarlar Sayfası",
          style: simpleTextStyle(Variables.fontSizeNormal, widget.darkTheme),
        ),
      ),
    );
  }
}
