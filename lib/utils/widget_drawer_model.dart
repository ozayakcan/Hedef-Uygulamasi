import 'package:flutter/material.dart';

class WidgetModel {
  WidgetModel(this.context, this.name, this._widget);
  final BuildContext context;
  final String name;
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
}
