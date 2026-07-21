import 'package:flutter/material.dart';

PageRouteBuilder navigate(Widget page) {
  return PageRouteBuilder(
    reverseTransitionDuration: Duration(milliseconds: 250),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: Offset(1.0, 0),
            end: Offset(0, 0),
          ).animate(animation),
          child: child,
        ),
      );
    },
    pageBuilder: (context, animation, secondaryAnimation) {
      return page;
    },
  );
}
