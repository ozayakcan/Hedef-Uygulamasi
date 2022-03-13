import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hedef/widgets/buttons.dart';
import 'package:hedef/widgets/menu.dart';

import '../utils/auth.dart';
import '../widgets/page_style.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.redirectEnabled}) : super(key: key);
  final bool redirectEnabled;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  late User? user;

  @override
  void initState() {
    super.initState();
    Auth.getUser(auth).then((value) {
      setState(() {
        user = value;
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
            floatingActionButton: const AddButton(),
            endDrawer: DrawerMenu(
              redirectEnabled: widget.redirectEnabled,
            ),
          ),
        )
      ],
    );
  }
}
