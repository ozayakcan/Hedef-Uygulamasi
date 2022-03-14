import 'package:flutter/material.dart';

class WidgetModel {
  WidgetModel(this.context, this._widget, this.drawer, this.showDrawer);
  final BuildContext context;
  final Widget _widget;
  Widget get widget {
    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.topLeft,
        width: MediaQuery.of(context).size.width,
        child: _widget,
      ),
    );
  }

  Widget drawer;
  bool showDrawer;
}
