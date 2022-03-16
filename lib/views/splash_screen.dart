import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../utils/images.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key, required this.darkTheme}) : super(key: key);

  final bool darkTheme;

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return Scaffold(
        body: Center(
          child: Image.asset(
            darkTheme
                ? AssetsImages.getAsset(AssetsImages.logoDark)
                : AssetsImages.getAsset(AssetsImages.logo),
            height: 40,
            width: 40,
          ),
        ),
      );
    } else {
      return SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
      );
    }
  }
}
