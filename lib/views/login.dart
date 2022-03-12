import 'package:auth_buttons/auth_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../widgets/buttons.dart';
import '../widgets/page_style.dart';
import '../widgets/text_fields.dart';

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
                emailLoginBtn(context),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EmailLogin extends StatelessWidget {
  EmailLogin({Key? key}) : super(key: key);

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    final CustomAuthButton loginBtnVar = loginBtn(
      context,
      emailController,
      passwordController,
    );
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
                emailTextField(
                  context: context,
                  emailController: emailController,
                  passwordFocus: passwordFocus,
                ),
                const SizedBox(
                  height: 10,
                ),
                passwordTextField(
                  context: context,
                  pwtext: AppLocalizations.of(context).password,
                  passwordController: passwordController,
                  authButton: loginBtnVar,
                  passwordFocus: passwordFocus,
                ),
                const SizedBox(
                  height: 10,
                ),
                loginBtnVar,
                const SizedBox(
                  height: 10,
                ),
                routeBtn(
                  context,
                  ResetPassword(),
                  AppLocalizations.of(context).reset_password,
                ),
                const SizedBox(
                  height: 10,
                ),
                routeBtn(
                  context,
                  EmailRegister(),
                  AppLocalizations.of(context).register,
                ),
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

class EmailRegister extends StatelessWidget {
  EmailRegister({Key? key}) : super(key: key);

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
    );
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
                emailTextField(
                  context: context,
                  emailController: emailController,
                  passwordFocus: passwordFocus,
                ),
                const SizedBox(
                  height: 10,
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
                const SizedBox(
                  height: 10,
                ),
                registerBtnVar,
                const SizedBox(
                  height: 10,
                ),
                backBtn(context, action: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => EmailLogin()),
                  );
                }),
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

class ResetPassword extends StatelessWidget {
  ResetPassword({Key? key}) : super(key: key);

  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final CustomAuthButton resetPasswordBtnVar = resetPasswordBtn(
      context,
      emailController,
    );
    return Scaffold(
      appBar: appBarMain(AppLocalizations.of(context).reset_password),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height - 50,
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                emailTextField(
                  context: context,
                  emailController: emailController,
                  authButton: resetPasswordBtnVar,
                ),
                const SizedBox(
                  height: 10,
                ),
                resetPasswordBtnVar,
                const SizedBox(
                  height: 10,
                ),
                backBtn(context, action: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => EmailLogin()),
                  );
                }),
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
