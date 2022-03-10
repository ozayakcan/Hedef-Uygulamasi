import 'package:auth_buttons/auth_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../utils/colors.dart';

TextField emailTextField(
    {required BuildContext context,
    required TextEditingController emailController,
    CustomAuthButton? authButton,
    FocusNode? passwordFocus}) {
  return TextField(
    controller: emailController,
    keyboardType: TextInputType.emailAddress,
    textInputAction:
        passwordFocus != null ? TextInputAction.next : TextInputAction.done,
    decoration: InputDecoration(
      labelText: AppLocalizations.of(context).email,
      labelStyle: const TextStyle(
        color: MyColors.colorPrimary,
      ),
    ),
    onSubmitted: (v) {
      if (authButton != null) {
        authButton.onPressed!();
        return;
      }
      if (passwordFocus != null) {
        FocusScope.of(context).requestFocus(passwordFocus);
        return;
      }
    },
  );
}

TextField passwordTextField(
    {required BuildContext context,
    required String pwtext,
    required TextEditingController passwordController,
    CustomAuthButton? authButton,
    FocusNode? passwordFocus,
    FocusNode? passwordRpFocus}) {
  return TextField(
    controller: passwordController,
    focusNode: passwordFocus,
    obscureText: true,
    enableSuggestions: false,
    autocorrect: false,
    textInputAction:
        passwordRpFocus != null ? TextInputAction.next : TextInputAction.done,
    decoration: InputDecoration(
      labelText: pwtext,
      labelStyle: const TextStyle(
        color: MyColors.colorPrimary,
      ),
    ),
    onSubmitted: (v) {
      if (authButton != null) {
        authButton.onPressed!();
        return;
      }
      if (passwordRpFocus != null) {
        FocusScope.of(context).requestFocus(passwordRpFocus);
        return;
      }
    },
  );
}
