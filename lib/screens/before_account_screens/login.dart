import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/screens/before_account_screens/reset_pass.dart';
import 'package:to_do_app/utils/state/provider_page.dart';
import 'package:to_do_app/utils/reusables.dart/before_acc_topbar.dart';
import 'package:to_do_app/utils/reusables.dart/field_borders.dart';
import 'package:to_do_app/utils/reusables.dart/indicator_navigator.dart';
import 'package:to_do_app/utils/textStyles/styles.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Padding(
            padding: const .symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: .start,
              children: [
                const BeforeAccTopBar(),
                const SizedBox(height: 20),
                const Text('Welcome back', style: Style.blc20),
                const Text(
                  'Your list is right where you left it.',
                  style: Style.gry12,
                ),
                const SizedBox(height: 15),
                const Text('Email', style: Style.gry14),
                const SizedBox(height: 8),
                const _EmailField(),
                const SizedBox(height: 8),
                const Text('Password', style: Style.gry14),
                const SizedBox(height: 8),
                const _PassField(),
                Align(
                  alignment: .centerRight,
                  child: IconButton(
                    onPressed: () {
                      Navigator.of(context).push(navigate(ResetPassPage()));
                    },
                    icon: const Text('Forgot Password?', style: Style.org12),
                  ),
                ),
                const _LoginButton(),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: .center,
                  children: [
                    const Text('New here? ', style: Style.gry12),
                    const Text('Create an account', style: Style.grn12),
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

class _EmailField extends StatelessWidget {
  const _EmailField();

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    return TextField(
      controller: context.read<StateManagementProvider>().loginEmail,
      style: Style.gry13,
      decoration: InputDecoration(
        filled: true,
        fillColor: c.onSecondary,
        isDense: true,
        visualDensity: VisualDensity(vertical: 0),
        contentPadding: const EdgeInsets.symmetric(horizontal: 06, vertical: 1),
        prefixIcon: Icon(Icons.mail, size: 25, color: c.onSurfaceVariant),
        hintText: 'name@company.com',
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
      controller: context.read<StateManagementProvider>().loginPassword,
      style: Style.gry13,
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: c.onSecondary,
        visualDensity: VisualDensity(vertical: 0),
        contentPadding: const EdgeInsets.symmetric(horizontal: 06, vertical: 0),
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
                passShowingIcon = Icon(
                  Icons.visibility_off,
                  size: 25,
                  color: const Color(0xFF333333),
                );
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

class _LoginButton extends StatelessWidget {
  const _LoginButton();

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    final sz = MediaQuery.sizeOf(context);
    return Selector<StateManagementProvider, bool>(
      selector: (_, pro) => pro.isSettingTask,
      builder: (_, isDone, _) {
        if (isDone == true) {
          return const GlobalIndicator();
        }
        return ElevatedButton(
          onPressed: () async {
            final p = context.read<StateManagementProvider>();
            if (p.loginEmail.text.trim().isNotEmpty &&
                p.loginPassword.text.trim().isNotEmpty) {
              await p.loginFunction(context);
            } else {
              if (kDebugMode) {
                print('Please fill all fields');
              }
            }
          },
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: c.primary,
            fixedSize: Size(sz.width * 1.0, sz.height * 0.075),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text('Log in', style: Style.blc18),
        );
      },
    );
  }
}
