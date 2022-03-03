import 'package:flutter/material.dart';
import 'package:hedef/utils/widgets.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
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
                googleSignInBtn(googleSignIn),
                const SizedBox(
                  height: 10,
                ),
                emailSignInBtn(googleSignIn),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void googleSignIn() {}
}
