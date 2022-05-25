import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sosyal/firebase/database/database.dart';

import '../firebase/auth.dart';
import '../firebase/database/posts_database.dart';
import '../firebase/storage/storage.dart';
import '../firebase/storage/upload_image.dart';
import '../utils/theme_colors.dart';
import '../utils/variables.dart';
import '../widgets/buttons.dart';
import '../widgets/page_style.dart';
import '../widgets/text_fields.dart';
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
  User user = Auth.of().user;
  TextEditingController textEditingController = TextEditingController();

  String image = Database.emptyString;

  bool alertDialogVisible = false;

  void showLoadingAlert(BuildContext context, String text) {
    if (!alertDialogVisible) {
      loadingAlert(
        context,
        widget.darkTheme,
        text: text,
      );
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

  Widget photoButton(
    BuildContext context, {
    required String text,
    required VoidCallback onPressed,
  }) {
    return customButton(
      darkTheme: widget.darkTheme,
      width: MediaQuery.of(context).size.width - Variables.buttonHeightDefault,
      height: Variables.buttonHeightSmall,
      text: text,
      buttonStyle: ButtonStyleEnum.primaryButton,
      padding: const EdgeInsets.all(5),
      borderRadius: Variables.buttonRadiusRound,
      onPressed: onPressed,
    );
  }

  @override
  Widget build(BuildContext context) {
    return defaultScaffold(
      context,
      widget.darkTheme,
      title: AppLocalizations.of(context).create_post,
      body: Container(
        padding: const EdgeInsets.only(top: 1),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              TextField(
                controller: textEditingController,
                maxLines: 8,
                minLines: 8,
                maxLength: Variables.maxLengthShare,
                style: TextStyle(
                  color: ThemeColor.of(widget.darkTheme).textPrimary,
                ),
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context).share_your_thoughts,
                  hintStyle: TextStyle(
                    color: ThemeColor.of(widget.darkTheme).textSecondary,
                  ),
                  counterStyle: TextStyle(
                    color: ThemeColor.of(widget.darkTheme).textPrimary,
                  ),
                  enabledBorder: enabledInputBorder(widget.darkTheme),
                  focusedBorder: focusedInputBorder(widget.darkTheme),
                ),
              ),
              image == Database.emptyString
                  ? photoButton(
                      context,
                      text: AppLocalizations.of(context).add_photo,
                      onPressed: () {
                        UploadImage.fromGallery(
                          context,
                          uploadLocation: Storage.postsLocation(user.uid),
                          beforeUpload: () {
                            showLoadingAlert(
                              context,
                              AppLocalizations.of(context).uploading,
                            );
                          },
                          onError: () {
                            closeLoadingAlert(context);
                            ScaffoldSnackbar.of(context).show(
                                AppLocalizations.of(context).an_error_occurred);
                          },
                          whenComplete: (downloadUrl) {
                            closeLoadingAlert(context);
                            setState(() {
                              image = downloadUrl;
                            });
                          },
                        );
                      },
                    )
                  : Column(
                      children: [
                        photoButton(
                          context,
                          text: AppLocalizations.of(context).remove_photo,
                          onPressed: () {
                            setState(() {
                              image = Database.emptyString;
                            });
                          },
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        CachedNetworkImage(
                          imageUrl: image,
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
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
            showLoadingAlert(context, AppLocalizations.of(context).sharing);
            bool canShare = false;
            if (textEditingController.text
                    .replaceAll("\n", "")
                    .replaceAll(" ", "")
                    .length >=
                2) {
              canShare = true;
            }
            if (image != Database.emptyString) {
              canShare = true;
            }
            if (canShare) {
              PostsDB.addPost(
                userid: user.uid,
                content: textEditingController.text,
                image: image,
              ).then((value) {
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
              closeLoadingAlert(context);
            }
          },
        ),
      ],
    );
  }
}
