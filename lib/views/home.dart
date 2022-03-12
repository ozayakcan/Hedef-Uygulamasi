import 'dart:async';

import 'package:auth_buttons/auth_buttons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hedef/widgets/menu.dart';

import '../widgets/page_style.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.redirectEnabled}) : super(key: key);
  final bool redirectEnabled;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    getUser();
  }

  final FirebaseAuth auth = FirebaseAuth.instance;
  late User? user;
  late String userEmail;
  late bool isEmailVerified;
  late Timer _timer;

  Future<void> getUser() async {
    setState(() {
      user = auth.currentUser!;
      isEmailVerified = user!.emailVerified;
    });
    Future(() async {
      _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
        if (isEmailVerified) {
          _timer.cancel();
        } else {
          setState(() {
            isEmailVerified = user!.emailVerified;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: user!.emailVerified
              ? MediaQuery.of(context).size.height
              : MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: defaultTabController(
            context,
            [
              Tab(
                text: AppLocalizations.of(context).active_up,
              ),
              Tab(
                text: AppLocalizations.of(context).completed_up,
              ),
            ],
            [
              Text("Aktifler Sayfası, Üye ID:" +
                  user!.uid +
                  " Üye Eposta:" +
                  user!.email!),
              Text("Tamamlananlar Sayfası, Üye ID:" +
                  user!.uid +
                  " Üye Eposta:" +
                  user!.email!),
            ],
            drawer: DrawerMenu(
              user: user,
              redirectEnabled: widget.redirectEnabled,
            ),
          ),
        )
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }
}
