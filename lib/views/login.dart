import 'package:auth_buttons/auth_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hedef/widgets/widgets.dart';

import '../widgets/buttons.dart';
import '../widgets/page_style.dart';
import '../widgets/text_fields.dart';

class Login extends StatelessWidget {
  const Login({Key? key, required this.redirectEnabled}) : super(key: key);

  final bool redirectEnabled;
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
                googleAuthBtn(context, redirectEnabled),
                const SizedBox(
                  height: 10,
                ),
                emailLoginBtn(context, redirectEnabled),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EmailLogin extends StatelessWidget {
  EmailLogin({Key? key, required this.redirectEnabled}) : super(key: key);

  final bool redirectEnabled;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    final CustomAuthButton loginBtnVar = loginBtn(
      context,
      emailController,
      passwordController,
      redirectEnabled,
    );
    return formPage(
      context,
      AppLocalizations.of(context).login_with_email,
      [
        emailTextField(
          context: context,
          emailController: emailController,
          passwordFocus: passwordFocus,
        ),
        passwordTextField(
          context: context,
          pwtext: AppLocalizations.of(context).password,
          passwordController: passwordController,
          authButton: loginBtnVar,
          passwordFocus: passwordFocus,
        ),
        loginBtnVar,
        routeBtn(
          context,
          ResetPassword(
            redirectEnabled: redirectEnabled,
          ),
          AppLocalizations.of(context).reset_password,
        ),
        routeBtn(
          context,
          EmailRegister(
            redirectEnabled: redirectEnabled,
          ),
          AppLocalizations.of(context).register,
        ),
        backBtn(context),
      ],
    );
  }
}

class EmailRegister extends StatelessWidget {
  EmailRegister({Key? key, required this.redirectEnabled}) : super(key: key);

  final bool redirectEnabled;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordRpController = TextEditingController();
  final passwordFocus = FocusNode();
  final passwordRpFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    final CustomAuthButton registerBtnVar = registerBtn(
      context,
      emailController,
      passwordController,
      passwordRpController,
      redirectEnabled,
    );
    return WillPopScope(
      onWillPop: () async {
        back(context);
        return false;
      },
      child: formPage(
        context,
        AppLocalizations.of(context).register,
        [
          emailTextField(
            context: context,
            emailController: emailController,
            passwordFocus: passwordFocus,
          ),
          passwordTextField(
            context: context,
            pwtext: AppLocalizations.of(context).password,
            passwordController: passwordController,
            passwordFocus: passwordFocus,
            passwordRpFocus: passwordRpFocus,
          ),
          passwordTextField(
            context: context,
            pwtext: AppLocalizations.of(context).password_repeat,
            passwordController: passwordRpController,
            authButton: registerBtnVar,
            passwordFocus: passwordRpFocus,
          ),
          registerBtnVar,
          backBtn(
            context,
            action: () {
              back(context);
            },
          ),
        ],
      ),
    );
  }

  void back(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => EmailLogin(
          redirectEnabled: redirectEnabled,
        ),
      ),
    );
  }
}

class ResetPassword extends StatelessWidget {
  ResetPassword({Key? key, required this.redirectEnabled}) : super(key: key);

  final bool redirectEnabled;

  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final CustomAuthButton resetPasswordBtnVar = resetPasswordBtn(
      context,
      emailController,
    );
    return WillPopScope(
      onWillPop: () async {
        back(context);
        return false;
      },
      child: formPage(
        context,
        AppLocalizations.of(context).reset_password,
        [
          emailTextField(
            context: context,
            emailController: emailController,
            authButton: resetPasswordBtnVar,
          ),
          resetPasswordBtnVar,
          backBtn(
            context,
            action: () {
              back(context);
            },
          ),
        ],
      ),
    );
  }

  void back(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => EmailLogin(
          redirectEnabled: redirectEnabled,
        ),
      ),
    );
  }
}
