import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../utils/variables.dart';
import '../widgets/menu.dart';
import '../widgets/page_style.dart';
import '../widgets/texts.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key, required this.darkTheme}) : super(key: key);

  final bool darkTheme;

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  @override
  Widget build(BuildContext context) {
    return defaultScaffold(
      context,
      widget.darkTheme,
      title: AppLocalizations.of(context).edit_profile,
      body: Text(
        "Profil Düzenleme Sayfası",
        style: simpleTextStyle(Variables.fontSizeNormal, widget.darkTheme),
      ),
      endDrawer: DrawerMenu(
        darkTheme: widget.darkTheme,
        showSettings: false,
      ),
    );
  }
}
