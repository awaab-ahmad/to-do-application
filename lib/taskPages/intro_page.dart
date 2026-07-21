import 'package:flutter/material.dart';
import 'package:to_do_app/services/global_items.dart';
import 'package:to_do_app/services/navigator.dart';
import 'package:to_do_app/services/styles.dart';
import 'package:to_do_app/taskPages/login.dart';
import 'package:to_do_app/taskPages/sign_up.dart';

class StartUpPage extends StatelessWidget {
  const StartUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final sz = MediaQuery.sizeOf(context);
    final s = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Opacity(
            opacity: 0.7,
            child: Image.asset(
              fit: BoxFit.cover,
              'images/front.jpg',
              height: sz.height * 1.0,
              width: sz.width * 1.0,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 08),
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  const SizedBox(height: 70),
                  Center(
                    child: Image.asset(
                      'images/logo.png',
                      height: sz.height * 0.15,
                    ),
                  ),
                  const SizedBox(height: 70),
                  SizedBox(
                    width: sz.width * 0.5,
                    child: FittedBox(
                      child: const Text('Get Started', style: Style.white16),
                    ),
                  ),
                  // globalText('Set up your account to begin', 16, FontWeight.w600),
                  const Text(
                    'Set up your accout to begin',
                    style: Style.white16,
                  ),
                  const SizedBox(height: 70),
                  Center(
                    child: _LoginSignButton(
                      type: 'Login',
                      page: LoginPage(),
                      c: s.secondary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: _LoginSignButton(
                      type: 'Sign Up',
                      page: SignUpPage(),
                      c: s.onPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoginSignButton extends StatelessWidget {
  final String type;
  final Widget page;
  final Color c;
  const _LoginSignButton({
    required this.type,
    required this.page,
    required this.c,
  });

  @override
  Widget build(BuildContext context) {
    final sz = MediaQuery.sizeOf(context);
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        overlayColor: const Color.fromRGBO(0, 0, 0, 1),
        shape: mainRadius,
        fixedSize: Size(sz.width * 0.5, sz.height * 0.08),
        backgroundColor: c,
      ),
      onPressed: () {
        Navigator.of(context).push(navigate(page));
      },
      child: Text(type, style: Style.black15),
    );
  }
}
