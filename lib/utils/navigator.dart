import 'package:flutter/material.dart';

PageRouteBuilder navigate(Widget page) {
  return PageRouteBuilder(
    reverseTransitionDuration: Duration(milliseconds: 250),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curvedAnimate = CurvedAnimation(
        parent: animation,
        curve: Curves.fastOutSlowIn,
      );
      return FadeTransition(
        opacity: curvedAnimate,
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
