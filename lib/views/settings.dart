import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sosyal/views/language.dart';

import '../models/widget.dart';
import '../utils/shared_pref.dart';
import 'bottom_navigation.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key, required this.darkTheme}) : super(key: key);

  final bool darkTheme;

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  String currentLanguageCode = getLanguageCode();

  @override
  void initState() {
    SharedPref.getLocale().then((value) {
      setState(() {
        currentLanguageCode = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationPage(
      darkTheme: widget.darkTheme,
      showSearchbar: false,
      widgetModel: WidgetModel(
        context,
        title: AppLocalizations.of(context).settings,
        child: Column(
          children: [
            chooseLanguageWidget(
              context,
              darkTheme: widget.darkTheme,
              currentLanguageCode: currentLanguageCode,
            ),
          ],
        ),
      ),
    );
  }
}
