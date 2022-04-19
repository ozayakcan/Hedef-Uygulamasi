import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../firebase/auth.dart';
import '../firebase/database/posts_database.dart';
import '../utils/colors.dart';
import '../utils/variables.dart';
import '../widgets/buttons.dart';
import '../widgets/page_style.dart';
import '../widgets/widgets.dart';

class SharePage extends StatefulWidget {
  const SharePage({
    Key? key,
    required this.darkTheme,
    this.onShared,
  }) : super(key: key);

  final bool darkTheme;
  final VoidCallback? onShared;

  @override
  State<SharePage> createState() => _SharePageState();
}

class _SharePageState extends State<SharePage> {
  User user = Auth.user;
  TextEditingController textEditingController = TextEditingController();

  bool alertDialogVisible = false;

  void showLoadingAlert() {
    if (!alertDialogVisible) {
      loadingAlert(context, widget.darkTheme);
      setState(() {
        alertDialogVisible = true;
      });
    }
  }

  void closeLoadingAlert(BuildContext context) {
    if (alertDialogVisible) {
      Navigator.pop(context);
      setState(() {
        alertDialogVisible = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return defaultScaffold(
      context,
      widget.darkTheme,
      title: AppLocalizations.of(context).create_post,
      body: Column(children: [
        TextField(
          controller: textEditingController,
          maxLines: 8,
          minLines: 8,
          maxLength: Variables.maxLengthShare,
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context).share_your_thoughts,
            hintStyle: TextStyle(
              color: widget.darkTheme
                  ? ThemeColorDark.textSecondary
                  : ThemeColor.textSecondary,
            ),
          ),
        ),
      ]),
      showBackButton: true,
      actions: [
        customButton(
          darkTheme: widget.darkTheme,
          text: AppLocalizations.of(context).share,
          buttonStyle: ButtonStyleEnum.secondaryButton,
          margin: const EdgeInsets.all(5.0),
          padding: const EdgeInsets.symmetric(
            vertical: 5.0,
            horizontal: 20.0,
          ),
          borderRadius: Variables.buttonRadiusRound,
          onPressed: () {
            if (textEditingController.text
                    .replaceAll("\n", "")
                    .replaceAll(" ", "")
                    .length >=
                2) {
              showLoadingAlert();
              PostsDB.addPost(
                      userid: user.uid, content: textEditingController.text)
                  .then((value) {
                if (value == null) {
                  VoidCallback? onShared = widget.onShared;
                  if (onShared != null) {
                    onShared();
                  }
                  closeLoadingAlert(context);
                  Navigator.pop(context);
                } else {
                  closeLoadingAlert(context);
                  ScaffoldSnackbar.of(context).show(
                      AppLocalizations.of(context).post_could_not_created);
                }
              });
            } else {
              ScaffoldSnackbar.of(context)
                  .show(AppLocalizations.of(context).post_must_2_character);
            }
          },
        ),
      ],
    );
  }
}
