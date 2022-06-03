import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sosyal/firebase/auth.dart';
import 'package:sosyal/widgets/text_fields.dart';
import 'package:sosyal/widgets/widgets.dart';

import '../firebase/database/user_database.dart';
import '../models/user.dart';
import '../utils/variables.dart';
import '../models/widget.dart';
import '../widgets/texts.dart';
import 'bottom_navigation.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key, required this.darkTheme}) : super(key: key);

  final bool darkTheme;

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  User user = Auth.of().user;
  bool canChangeEmail = false;
  StreamSubscription<DatabaseEvent>? userEvent;
  UserModel userModel = UserModel.empty();

  String errorString = "";

  @override
  void initState() {
    super.initState();
    userEvent = UserDB.getUserRef(user.uid).onValue.listen((event) {
      final json = event.snapshot.value as Map<dynamic, dynamic>;
      setState(() {
        userModel = UserModel.fromJson(json);
      });
    });
    UserInfo userInfo = user.providerData.first;
    if (userInfo.providerId == "password") {
      setState(() {
        canChangeEmail = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationPage(
      darkTheme: widget.darkTheme,
      showSearchbar: false,
      widgetModel: WidgetModel(
        context,
        title: AppLocalizations.of(context).edit_profile,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context).username_dot.replaceAll(
                          "{username}",
                          userModel.getUserNameAt,
                        ),
                    style: simpleTextStyle(
                      Variables.fontSizeNormal,
                      widget.darkTheme,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      TextEditingController usernameController =
                          TextEditingController();
                      FocusNode focusNode = FocusNode();
                      showBottomFormModal(
                        context: context,
                        darkTheme: widget.darkTheme,
                        title: AppLocalizations.of(context).change_username,
                        onSave: () {
                          setState(() {
                            errorString = "";
                          });
                          UserDB.checkUsername(context, usernameController.text)
                              .then((valueUsername) {
                            if (valueUsername.isEmpty) {
                              UserDB.updateUserName(
                                      user.uid, usernameController.text)
                                  .then((value) {
                                if (value == null) {
                                  Navigator.pop(context);
                                } else {
                                  setState(() {
                                    errorString = AppLocalizations.of(context)
                                        .could_not_update_username;
                                  });
                                }
                              });
                            } else {
                              setState(() {
                                errorString = valueUsername;
                              });
                            }
                          });
                        },
                        children: [
                          customTextField(
                            context,
                            widget.darkTheme,
                            textController: usernameController,
                            prevFocus: focusNode,
                            maxLength: Variables.maxLengthUsername,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            errorString,
                            style: simpleTextStyleColorable(
                              Variables.fontSizeNormal,
                              Colors.red,
                            ),
                          ),
                        ],
                      );
                      usernameController.text = userModel.username;
                      focusNode.addListener(() {
                        if (focusNode.hasFocus) {
                          usernameController.selection = TextSelection(
                              baseOffset: 0,
                              extentOffset: usernameController.text.length);
                        }
                      });
                    },
                    child: Text(
                      AppLocalizations.of(context).change,
                      style: linktTextStyle(
                        Variables.fontSizeNormal,
                        widget.darkTheme,
                      ),
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context).email_dot.replaceAll(
                          "{email}",
                          user.email!,
                        ),
                    style: simpleTextStyle(
                      Variables.fontSizeNormal,
                      widget.darkTheme,
                    ),
                  ),
                  if (canChangeEmail)
                    InkWell(
                      onTap: () {
                        showBottomFormModal(
                          context: context,
                          darkTheme: widget.darkTheme,
                          title: AppLocalizations.of(context).change_email,
                          onSave: () {},
                          children: [
                            const Text("Deneme"),
                          ],
                        );
                      },
                      child: Text(
                        AppLocalizations.of(context).change,
                        style: linktTextStyle(
                          Variables.fontSizeNormal,
                          widget.darkTheme,
                        ),
                      ),
                    )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
