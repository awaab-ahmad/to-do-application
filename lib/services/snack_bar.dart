import 'package:flutter/material.dart';

SnackBar globalBar(String message) {
  return SnackBar(
    behavior: SnackBarBehavior.floating,
    margin: EdgeInsets.symmetric(horizontal: 60, vertical: 50),
    hitTestBehavior: HitTestBehavior.translucent,
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
    backgroundColor: const Color(0x40333333),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    elevation: 0,
    content: Center(
      child: Text(
        message,
        style: TextStyle(
          color: const Color(0xFF000000),
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );
}
