import 'package:flutter/material.dart';

class GlobalIndicator extends StatelessWidget {
  const GlobalIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        strokeWidth: 4.5,
        color: const Color(0xFFE8A268),
      ),
    );
  }
}

PageRouteBuilder navigate(Widget page) {
  return PageRouteBuilder(
    reverseTransitionDuration: Duration(milliseconds: 250),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curvedAnimate = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      );
      return FadeTransition(
        opacity: curvedAnimate,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: Offset(1.0, 0),
            end: Offset(0, 0),
          ).animate(curvedAnimate),
          child: child,
        ),
      );
    },
    pageBuilder: (context, animation, secondaryAnimation) {
      return page;
    },
  );
}
