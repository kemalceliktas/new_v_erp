import 'package:flutter/material.dart';

mixin NavigatorManager {
  void navigateToWidget(BuildContext context, Widget widget) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return widget;
        },
        fullscreenDialog: false,
        settings: const RouteSettings(),
      ),
    );
  }
  void navigateToWidgetReplacment(BuildContext context, Widget widget) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) {
          return widget;
        },
        fullscreenDialog: false,
        settings: const RouteSettings(),
      ),
    );
  }
  Future<T?> navigate<T>(BuildContext context, Widget widget) {
    return Navigator.of(context).push<T>(
      MaterialPageRoute(
        builder: (context) {
          return widget;
        },
        fullscreenDialog: false,
        settings: const RouteSettings(),
      ),
    );
  }
}
