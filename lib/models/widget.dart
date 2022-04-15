import 'package:flutter/material.dart';

class WidgetModel {
  WidgetModel(this.context,
      {required this.title,
      required this.child,
      this.showBackButton = true,
      this.showScrollView = true});
  final BuildContext context;
  final bool showBackButton;
  final String title;
  final Widget child;
  final bool showScrollView;
  Widget get widget {
    Widget container = Container(
      alignment: Alignment.topLeft,
      width: MediaQuery.of(context).size.width,
      child: child,
    );
    if (showScrollView) {
      return SingleChildScrollView(
        child: container,
      );
    } else {
      return container;
    }
  }
}
