import 'package:auth_buttons/auth_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../utils/colors.dart';

TextField emailTextField(
    {required BuildContext context,
    required TextEditingController emailController,
    CustomAuthButton? authButton,
    FocusNode? prevFocus,
    FocusNode? nextFocus}) {
  return TextField(
    controller: emailController,
    focusNode: prevFocus,
    keyboardType: TextInputType.emailAddress,
    textInputAction:
        nextFocus != null ? TextInputAction.next : TextInputAction.done,
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
      if (nextFocus != null) {
        FocusScope.of(context).requestFocus(nextFocus);
        return;
      }
    },
  );
}

TextField nameTextField(
    {required BuildContext context,
    required TextEditingController nameController,
    CustomAuthButton? authButton,
    FocusNode? prevFocus,
    FocusNode? nextFocus}) {
  return TextField(
    controller: nameController,
    focusNode: prevFocus,
    keyboardType: TextInputType.name,
    textInputAction:
        nextFocus != null ? TextInputAction.next : TextInputAction.done,
    decoration: InputDecoration(
      labelText: AppLocalizations.of(context).name,
      labelStyle: const TextStyle(
        color: MyColors.colorPrimary,
      ),
    ),
    onSubmitted: (v) {
      if (authButton != null) {
        authButton.onPressed!();
        return;
      }
      if (nextFocus != null) {
        FocusScope.of(context).requestFocus(nextFocus);
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
    FocusNode? prevFocus,
    FocusNode? nextFocus}) {
  return TextField(
    controller: passwordController,
    focusNode: prevFocus,
    obscureText: true,
    enableSuggestions: false,
    autocorrect: false,
    textInputAction:
        nextFocus != null ? TextInputAction.next : TextInputAction.done,
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
      if (nextFocus != null) {
        FocusScope.of(context).requestFocus(nextFocus);
        return;
      }
    },
  );
}
