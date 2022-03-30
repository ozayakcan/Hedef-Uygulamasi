import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../utils/widget_drawer_model.dart';
import '../widgets/buttons.dart';
import 'bottom_navigation.dart';
import 'profile.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
    required this.darkTheme,
  }) : super(key: key);
  final bool darkTheme;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationPage(
      darkTheme: widget.darkTheme,
      widgetModel: WidgetModel(
        context,
        title: AppLocalizations.of(context).app_name,
        child: Column(
          children: [
            customButton(
              context,
              text: "Örnek Profil 1",
              buttonStyle: ButtonStyleEnum.primaryButton,
              darkTheme: widget.darkTheme,
              action: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Profile(
                      darkTheme: widget.darkTheme,
                      username: "ozay_akcan",
                      showAppBar: true,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(
              height: 10,
            ),
            customButton(
              context,
              text: "Örnek Profil 2",
              buttonStyle: ButtonStyleEnum.primaryButton,
              darkTheme: widget.darkTheme,
              action: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Profile(
                      darkTheme: widget.darkTheme,
                      username: "ozayakcan",
                      showAppBar: true,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
