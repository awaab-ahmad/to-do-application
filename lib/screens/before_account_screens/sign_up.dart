import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/utils/state/provider_page.dart';
import 'package:to_do_app/utils/reusables.dart/before_acc_topbar.dart';
import 'package:to_do_app/utils/reusables.dart/field_borders.dart';
import 'package:to_do_app/utils/reusables.dart/indicator_navigator.dart';
import 'package:to_do_app/utils/textStyles/styles.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: .start,
              children: [
                const BeforeAccTopBar(),
                const SizedBox(height: 20),
                const Text('Create an account', style: Style.blc20),
                const Text(
                  'Takes less time than your first task.',
                  style: Style.gry12,
                ),
                const SizedBox(height: 15),
                const Text('Full name', style: Style.gry14),
                const SizedBox(height: 8),
                _TField(
                  tc: context.read<StateManagementProvider>().signUpUserName,
                  ic: Icons.person_2_rounded,
                  hint: 'Your Name',
                ),
                const SizedBox(height: 8),
                const Text('Email', style: Style.gry14),
                const SizedBox(height: 8),
                _TField(
                  tc: context.read<StateManagementProvider>().signUpEmail,
                  ic: Icons.mail,
                  hint: 'name@company.com',
                ),
                const SizedBox(height: 8),
                const Text('Password', style: Style.gry14),
                const SizedBox(height: 8),
                const _PassField(),
                const SizedBox(height: 8),
                const _PrivacyLine(),
                const SizedBox(height: 40),
                const _SignUpButton(),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: .center,
                  children: [
                    const Text('Already have an account? ', style: Style.gry12),
                    const Text('Log in', style: Style.grn12),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TField extends StatelessWidget {
  final TextEditingController tc;
  final IconData ic;
  final String hint;
  const _TField({required this.tc, required this.ic, required this.hint});

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    return TextField(
      controller: tc,
      style: Style.gry13,
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: c.onSecondary,
        visualDensity: VisualDensity(vertical: -1),
        contentPadding: const EdgeInsets.symmetric(horizontal: 06, vertical: 2),
        prefixIcon: Icon(ic, size: 25, color: c.onSurfaceVariant),
        hintText: hint,
        hintStyle: Style.mutedGry13,
        focusedBorder: focusB,
        enabledBorder: enabledB,
      ),
    );
  }
}

class _PassField extends StatefulWidget {
  const _PassField();

  @override
  State<_PassField> createState() => _PassFieldState();
}

class _PassFieldState extends State<_PassField> {
  Icon passShowingIcon = Icon(
    Icons.visibility_off,
    color: const Color(0xFF333333),
    size: 25,
  );
  bool passNotVisible = true;
  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    return TextField(
      obscureText: passNotVisible,
      controller: context.read<StateManagementProvider>().signUpPassword,
      style: Style.gry13,
      decoration: InputDecoration(
        filled: true,
        fillColor: c.onSecondary,
        isDense: true,
        visualDensity: VisualDensity(vertical: -1),
        contentPadding: EdgeInsets.symmetric(horizontal: 06, vertical: 0),
        prefixIcon: Icon(
          Icons.lock_outline,
          size: 25,
          color: c.onSurfaceVariant,
        ),
        hintText: 'Min. 6 characters',
        hintStyle: Style.mutedGry13,
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              passNotVisible = !passNotVisible;
              if (passNotVisible == false) {
                passShowingIcon = Icon(
                  Icons.visibility,
                  size: 25,
                  color: const Color(0xFF333333),
                );
              } else {
                passShowingIcon = Icon(Icons.visibility_off, size: 25);
              }
            });
          },
          child: passShowingIcon,
        ),
        focusedBorder: focusB,
        enabledBorder: enabledB,
      ),
    );
  }
}

class _PrivacyLine extends StatelessWidget {
  const _PrivacyLine();

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(text: 'By continuing you agree to our ', style: Style.gry12),
          TextSpan(text: 'Terms and Privacy policy.', style: Style.grn12),
        ],
      ),
    );
  }
}

class _SignUpButton extends StatelessWidget {
  const _SignUpButton();

  @override
  Widget build(BuildContext context) {
    final sz = MediaQuery.sizeOf(context);
    final c = Theme.of(context).colorScheme;
    return Center(
      child: Selector<StateManagementProvider, bool>(
        selector: (_, pro) => pro.isSettingTask,
        builder: (_, isLoaded, _) {
          if (isLoaded == true) {
            return const GlobalIndicator();
          }
          return ElevatedButton(
            onPressed: () async {
              final p = context.read<StateManagementProvider>();
              if (p.signUpUserName.text.trim().isNotEmpty &&
                  p.signUpEmail.text.trim().isNotEmpty &&
                  p.signUpPassword.text.trim().isNotEmpty) {
                await p.signUpFunction(context);
              } else {
                if (kDebugMode) print('Fill all first');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: c.primary,
              fixedSize: Size(sz.width * 1.0, sz.height * 0.075),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Create account', style: Style.blc14),
          );
        },
      ),
    );
  }
}
