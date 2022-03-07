import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hedef/utils/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

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

  Future<void> getUser() async {
    setState(() {
      user = auth.currentUser!;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> emailVerifiyWarning =
        AppLocalizations.of(context).email_not_verified.split("|");

    return Column(
      children: [
        SizedBox(
          height: user!.emailVerified
              ? MediaQuery.of(context).size.height
              : MediaQuery.of(context).size.height - 35,
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
          ),
        ),
        if (!user!.emailVerified)
          warningBox(
            getClickableText(context, emailVerifiyWarning),
            MediaQuery.of(context).size.width,
            35,
          ),
      ],
    );
  }
}
