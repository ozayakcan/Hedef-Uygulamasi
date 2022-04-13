import 'package:flutter/material.dart';

class WidgetModel {
  WidgetModel(this.context,
      {required this.title, required this.child, this.showBackButton = true});
  final BuildContext context;
  final bool showBackButton;
  final String title;
  final Widget child;
  Widget get widget {
    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.topLeft,
        width: MediaQuery.of(context).size.width,
        child: child,
      ),
    );
  }
}
