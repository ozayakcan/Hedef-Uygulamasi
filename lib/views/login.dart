import 'package:flutter/material.dart';
import 'package:hedef/utils/colors.dart';
import 'package:hedef/utils/widgets.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain("Giriş Yap"),
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
      appBar: appBarMain("Eposta ile Giriş Yap"),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height - 50,
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Hesabınız yoksa bilgileri girdikten sonra kaydol butonuna basın.",
                  style: simpleTextStyle(),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: "Eposta",
                    labelStyle: TextStyle(
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
                  decoration: const InputDecoration(
                    labelText: "Şifre",
                    labelStyle: TextStyle(
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
