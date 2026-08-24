import 'package:flutter/material.dart';
import 'package:to_do_app/screens/before_account_screens/login.dart';
import 'package:to_do_app/screens/before_account_screens/sign_up.dart';
import 'package:to_do_app/utils/reusables.dart/indicator_navigator.dart';
import 'package:to_do_app/utils/textStyles/styles.dart';

class StartUpPage extends StatelessWidget {
  const StartUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 08),
        child: Center(
          child: Column(
            mainAxisAlignment: .center,
            children: [
              const Expanded(flex: 4, child: SizedBox()),
              const _LogoContainer(),
              const SizedBox(height: 10),
              const Text('Doable', style: Style.blc22),
              const SizedBox(height: 10),
              const Text(
                textAlign: .center,
                'Small tasks, done daily. That\'s the \nwhole plan',
                style: Style.gry12,
              ),
              const Expanded(flex: 2, child: SizedBox()),
              _Button(
                type: 'Create an account',
                page: const SignUpPage(),
                c: c.primary,
                border: c.primary,
              ),
              const SizedBox(height: 10),
              _Button(
                type: 'Log in',
                page: const LoginPage(),
                c: c.onSecondary,
                border: c.onPrimaryFixed,
              ),
              const Expanded(flex: 2, child: SizedBox()),
            ],
          ),
        ),
      ),
    );
  }
}

class _LogoContainer extends StatelessWidget {
  const _LogoContainer();

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    return Container(
      height: 75,
      width: 75,
      decoration: BoxDecoration(
        color: c.onPrimary,
        borderRadius: .circular(15),
      ),
      child: Icon(Icons.check, size: 50, color: c.onSecondary),
    );
  }
}

class _Button extends StatelessWidget {
  final String type;
  final Widget page;
  final Color c;
  final Color border;
  const _Button({
    required this.type,
    required this.page,
    required this.c,
    required this.border,
  });

  @override
  Widget build(BuildContext context) {
    final sz = MediaQuery.sizeOf(context);
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        overlayColor: const Color.fromRGBO(0, 0, 0, 1),
        shape: RoundedRectangleBorder(borderRadius: .circular(15)),
        fixedSize: Size(sz.width * 0.65, sz.height * 0.075),
        backgroundColor: c,
        side: BorderSide(color: border, width: 1.2),
      ),
      onPressed: () {
        Navigator.of(context).push(navigate(page));
      },
      child: Text(type, style: Style.blc14),
    );
  }
}
