import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../utils/transitions.dart';
import '../widgets/images.dart';
import '../widgets/page_style.dart';

class ProfileImage extends StatelessWidget {
  const ProfileImage({
    Key? key,
    required this.darkTheme,
    required this.username,
    required this.imageUrl,
  }) : super(key: key);

  final bool darkTheme;
  final String username;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    double size = squareFullScreen(context);
    return defaultScaffold(
      context,
      darkTheme,
      title: AppLocalizations.of(context)
          .s_profile_image
          .replaceAll("%s", username),
      body: Center(
        child: SizedBox(
          width: size,
          height: size,
          child: Hero(
            tag: Transitions.profileImage,
            child: profileImage(
              imageUrl,
              width: size,
              height: size,
              rounded: false,
            ),
          ),
        ),
      ),
      showBackButton: true,
    );
  }
}
