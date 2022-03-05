import 'package:flutter/material.dart';
import 'package:hedef/utils/colors.dart';
import 'package:hedef/utils/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(AppLocalizations.of(context).login),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height - 50,
          alignment: Alignment.center,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                googleAuthBtn(context),
                const SizedBox(
                  height: 10,
                ),
                emailAuthBtn(context),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EmailAuth extends StatelessWidget {
  EmailAuth({Key? key}) : super(key: key);

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(AppLocalizations.of(context).login_with_email),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height - 50,
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context).email,
                    labelStyle: const TextStyle(
                      color: MyColors.colorPrimary,
                    ),
                  ),
                  onSubmitted: (v) {
                    FocusScope.of(context).requestFocus(passwordFocus);
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: passwordController,
                  focusNode: passwordFocus,
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context).password,
                    labelStyle: const TextStyle(
                      color: MyColors.colorPrimary,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                signinBtn(context, emailController, passwordController),
                const SizedBox(
                  height: 10,
                ),
                signupBtn(context, emailController, passwordController),
                const SizedBox(
                  height: 10,
                ),
                backBtn(context),
                const SizedBox(
                  height: 40,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
