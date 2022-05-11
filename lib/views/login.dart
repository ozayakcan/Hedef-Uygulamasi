import 'package:auth_buttons/auth_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sosyal/utils/shared_pref.dart';
import 'package:sosyal/views/language.dart';

import '../utils/variables.dart';
import '../widgets/buttons.dart';
import '../widgets/text_fields.dart';
import '../widgets/widgets.dart';

class Login extends StatefulWidget {
  const Login({Key? key, required this.darkTheme}) : super(key: key);

  final bool darkTheme;

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String currentLanguageCode = getLanguageCode();

  @override
  void initState() {
    SharedPref.getLocale().then((value) {
      setState(() {
        currentLanguageCode = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height - 50,
          alignment: Alignment.center,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                googleAuthBtn(
                  context,
                  widget.darkTheme,
                ),
                const SizedBox(
                  height: 10,
                ),
                emailLoginBtn(
                  context,
                  widget.darkTheme,
                ),
                const SizedBox(
                  height: 30,
                ),
                darkThemeSwitch(context, widget.darkTheme),
                chooseLanguageWidget(
                  context,
                  darkTheme: widget.darkTheme,
                  currentLanguageCode: currentLanguageCode,
                  centered: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EmailLogin extends StatelessWidget {
  EmailLogin({Key? key, required this.darkTheme}) : super(key: key);

  final bool darkTheme;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    final CustomAuthButton loginBtnVar = loginBtn(
      context,
      emailController,
      passwordController,
      darkTheme,
    );
    return formPage(
      context,
      [
        customTextField(
          context,
          darkTheme,
          labelText: AppLocalizations.of(context).email,
          textController: emailController,
          inputType: TextInputType.emailAddress,
          nextFocus: passwordFocus,
        ),
        passwordTextField(
          context,
          darkTheme,
          pwtext: AppLocalizations.of(context).password,
          passwordController: passwordController,
          authButton: loginBtnVar,
          prevFocus: passwordFocus,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            linkButton(
              context,
              EmailRegister(
                darkTheme: darkTheme,
              ),
              AppLocalizations.of(context).i_dont_have_an_account,
              darkTheme: darkTheme,
              replacement: true,
              fontSiza: Variables.fontSizeMedium,
            ),
            linkButton(
              context,
              ResetPassword(
                darkTheme: darkTheme,
              ),
              AppLocalizations.of(context).forget_password,
              darkTheme: darkTheme,
              replacement: true,
              fontSiza: Variables.fontSizeMedium,
            ),
          ],
        ),
        loginBtnVar,
        backBtn(context, darkTheme),
      ],
    );
  }
}

class EmailRegister extends StatelessWidget {
  EmailRegister({Key? key, required this.darkTheme}) : super(key: key);

  final bool darkTheme;

  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordRpController = TextEditingController();
  final usernameFocus = FocusNode();
  final nameFocus = FocusNode();
  final passwordFocus = FocusNode();
  final passwordRpFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    final CustomAuthButton registerBtnVar = registerBtn(
      context,
      emailController,
      usernameController,
      nameController,
      passwordController,
      passwordRpController,
      darkTheme,
    );
    return WillPopScope(
      onWillPop: () async {
        back(context);
        return false;
      },
      child: formPage(
        context,
        [
          customTextField(
            context,
            darkTheme,
            labelText: AppLocalizations.of(context).email,
            textController: emailController,
            inputType: TextInputType.emailAddress,
            nextFocus: passwordFocus,
          ),
          customTextField(
            context,
            darkTheme,
            labelText: AppLocalizations.of(context).username,
            maxLength: Variables.maxLengthUsername,
            textController: usernameController,
            prevFocus: usernameFocus,
            nextFocus: nameFocus,
          ),
          customTextField(
            context,
            darkTheme,
            labelText: AppLocalizations.of(context).name,
            maxLength: Variables.maxLengthName,
            textController: nameController,
            prevFocus: nameFocus,
            nextFocus: passwordFocus,
          ),
          passwordTextField(
            context,
            darkTheme,
            pwtext: AppLocalizations.of(context).password,
            passwordController: passwordController,
            prevFocus: passwordFocus,
            nextFocus: passwordRpFocus,
          ),
          passwordTextField(
            context,
            darkTheme,
            pwtext: AppLocalizations.of(context).password_repeat,
            passwordController: passwordRpController,
            authButton: registerBtnVar,
            prevFocus: passwordRpFocus,
          ),
          registerBtnVar,
          backBtn(
            context,
            darkTheme,
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
          darkTheme: darkTheme,
        ),
      ),
    );
  }
}

class ResetPassword extends StatelessWidget {
  ResetPassword({Key? key, required this.darkTheme}) : super(key: key);

  final bool darkTheme;

  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final CustomAuthButton resetPasswordBtnVar = resetPasswordBtn(
      context,
      emailController,
      darkTheme,
    );
    return WillPopScope(
      onWillPop: () async {
        back(context);
        return false;
      },
      child: formPage(
        context,
        [
          customTextField(
            context,
            darkTheme,
            labelText: AppLocalizations.of(context).email,
            textController: emailController,
            authButton: resetPasswordBtnVar,
            inputType: TextInputType.emailAddress,
          ),
          resetPasswordBtnVar,
          backBtn(
            context,
            darkTheme,
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
          darkTheme: darkTheme,
        ),
      ),
    );
  }
}
