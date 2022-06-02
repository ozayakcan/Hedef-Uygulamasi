import 'package:flutter/material.dart';
import 'package:sosyal/utils/shared_pref.dart';
import 'package:sosyal/utils/variables.dart';
import 'package:sosyal/widgets/texts.dart';
import 'package:sosyal/widgets/widgets.dart';
import 'package:universal_io/io.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

List supportedLocales = [
  {"name": "English", "locale": "en"},
  {"name": "Türkçe", "locale": "tr"},
];

void languageDialog(BuildContext context, bool darkTheme) {
  List<Widget> localesWidget = [];
  for (final locale in supportedLocales) {
    localesWidget.add(
      InkWell(
        onTap: () {
          SharedPref.setLocaleRestart(context, locale["locale"]);
          Navigator.pop(context);
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            locale["name"],
            style: simpleTextStyle(Variables.fontSizeMedium, darkTheme),
          ),
        ),
      ),
    );
  }
  defaultAlertbox(
    context,
    title: AppLocalizations.of(context).choose_your_language,
    descriptions: localesWidget,
    darkTheme: darkTheme,
  );
}

Widget chooseLanguageWidget(
  BuildContext context, {
  required bool darkTheme,
  required String currentLanguageCode,
  bool centered = false,
}) {
  Widget langWidget = Text(
    AppLocalizations.of(context).language.replaceAll(
          "{lang}",
          supportedLocales.firstWhere(
              (element) => element["locale"] == currentLanguageCode,
              orElse: () => supportedLocales[0])["name"],
        ),
    style: simpleTextStyle(
      Variables.fontSizeMedium,
      darkTheme,
    ),
  );
  return InkWell(
    onTap: () {
      languageDialog(context, darkTheme);
    },
    child: Container(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
      ),
      width: MediaQuery.of(context).size.width,
      child: centered
          ? Center(
              child: langWidget,
            )
          : langWidget,
    ),
  );
}

String getLanguageCode() {
  return Platform.localeName.split('-')[0].split('_')[0];
}
