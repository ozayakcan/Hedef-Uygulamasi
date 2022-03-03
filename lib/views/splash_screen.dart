import 'package:flutter/material.dart';
import 'package:hedef/utils/images.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          AssetsImages.logo,
          height: 40,
          width: 40,
        ),
      ),
    );
  }
}
