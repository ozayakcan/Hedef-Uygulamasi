import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../utils/colors.dart';
import '../utils/variables.dart';
import '../widgets/widgets.dart';

class AddPage extends StatelessWidget {
  const AddPage({Key? key, required this.darkTheme}) : super(key: key);
  final bool darkTheme;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Hero(
          tag: Variables.heroAddTag,
          createRectTween: (begin, end) {
            return CustomRectTween(begin: begin, end: end);
          },
          child: Material(
            color: darkTheme
                ? ThemeColorDark.backgroundPrimary
                : ThemeColor.backgroundPrimary,
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        AppLocalizations.of(context).add,
                        style: TextStyle(
                            color: darkTheme
                                ? ThemeColorDark.textPrimary
                                : ThemeColor.textPrimary),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
