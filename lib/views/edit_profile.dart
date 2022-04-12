import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../utils/variables.dart';
import '../utils/widget_drawer_model.dart';
import '../widgets/texts.dart';
import 'bottom_navigation.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key, required this.darkTheme}) : super(key: key);

  final bool darkTheme;

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationPage(
      darkTheme: widget.darkTheme,
      showSearchbar: false,
      widgetModel: WidgetModel(
        context,
        title: AppLocalizations.of(context).edit_profile,
        child: Text(
          "Profil Düzenleme Sayfası",
          style: simpleTextStyle(Variables.fontSizeNormal, widget.darkTheme),
        ),
      ),
    );
  }
}
