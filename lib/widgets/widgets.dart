import 'dart:ui';

import 'package:flutter/material.dart';

class ScaffoldSnackbar {
  ScaffoldSnackbar(this._context);
  final BuildContext _context;

  factory ScaffoldSnackbar.of(BuildContext context) {
    return ScaffoldSnackbar(context);
  }
  void show(String message) {
    ScaffoldMessenger.of(_context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message)),
      );
  }
}

Scaffold formPage(
  BuildContext context,
  PreferredSizeWidget? appBar,
  List<Widget> list,
) {
  return Scaffold(
    appBar: appBar,
    body: SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height - 50,
        alignment: Alignment.bottomCenter,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: formList(list),
          ),
        ),
      ),
    ),
  );
}

List<Widget> formList(List<Widget> oldList) {
  List<Widget> newList = [];
  for (int i = 0; i < oldList.length; i++) {
    newList.add(oldList[i]);
    newList.add(
      SizedBox(
        height: (i >= oldList.length - 1) ? 40 : 10,
      ),
    );
  }
  return newList;
}

class HeroDialogRoute<T> extends PageRoute<T> {
  HeroDialogRoute({
    required WidgetBuilder builder,
    RouteSettings? settings,
    bool fullscreenDialog = false,
  })  : _builder = builder,
        super(settings: settings, fullscreenDialog: fullscreenDialog);

  final WidgetBuilder _builder;

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  bool get maintainState => true;

  @override
  Color? get barrierColor => Colors.black54;

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return child;
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return _builder(context);
  }

  @override
  String? get barrierLabel => "Popup dialog open";
}

class CustomRectTween extends RectTween {
  /// {@macro custom_rect_tween}
  CustomRectTween({
    required Rect? begin,
    required Rect? end,
  }) : super(begin: begin, end: end);

  @override
  Rect lerp(double t) {
    final elasticCurveValue = Curves.easeOut.transform(t);
    return Rect.fromLTRB(
      lerpDouble(begin!.left, end!.left, elasticCurveValue)!,
      lerpDouble(begin!.top, end!.top, elasticCurveValue)!,
      lerpDouble(begin!.right, end!.right, elasticCurveValue)!,
      lerpDouble(begin!.bottom, end!.bottom, elasticCurveValue)!,
    );
  }
}
