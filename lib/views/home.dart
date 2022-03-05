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

  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String userID;
  late String userEmail;

  Future<void> getUser() async {
    setState(() {
      userID = _auth.currentUser!.uid;
      userEmail = _auth.currentUser!.email!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return defaultTabController(
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
        Text("Aktifler Sayfası, Üye ID:" + userID + " Üye Eposta:" + userEmail),
        Text("Tamamlananlar Sayfası, Üye ID:" +
            userID +
            " Üye Eposta:" +
            userEmail),
      ],
    );
  }
}
