import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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

  Future<void> getUser() async {
    setState(() {
      userID = _auth.currentUser!.uid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
