import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class Routes {
  static Routes instance = Routes();
  Future<dynamic> pushAndRemoveUntil(
      {required Widget widget,
      required BuildContext context,
      bool routeNav = false,
      bool material = true}) {
    return Navigator.of(context, rootNavigator: routeNav).pushAndRemoveUntil(
        material
            ? MaterialPageRoute(builder: (ctx) => widget)
            : CupertinoPageRoute(builder: (ctx) => widget),
        (route) => false);
  }

  Future<dynamic> push(
      {required Widget widget, required BuildContext context}) {
    return PersistentNavBarNavigator.pushNewScreen(
      context,
      screen: widget,
      withNavBar: false,
    );
  }
}
