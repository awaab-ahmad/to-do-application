import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/services/global_items.dart';
import 'package:to_do_app/services/provider_page.dart';
import 'package:to_do_app/taskPages/reset_pass.dart';
import 'package:to_do_app/services/styles.dart';

// ignore: must_be_immutable
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final sz = MediaQuery.sizeOf(context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        appBar: AppBar(
          systemOverlayStyle: systemOverlay,
          backgroundColor: Theme.of(context).colorScheme.onPrimary,
          toolbarHeight: sz.height * 0.07,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back,
              size: sz.height * 0.04,
              color: const Color(0xFF333333),
            ),
          ),
          centerTitle: true,
          title: const Text('Login', style: Style.black18),
        ),
        body: Column(
          children: [
            const SizedBox(height: 40),
            Image.asset('images/key.png', height: sz.height * 0.1),
            const SizedBox(height: 80),
            Expanded(
              child: Container(
                margin: EdgeInsets.zero,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onSecondary,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      SizedBox(
                        width: sz.width * 0.5,
                        child: FittedBox(
                          child: const Text(
                            'Welcome back!',
                            style: Style.black18,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      const _EmailField(),
                      const SizedBox(height: 20),
                      const _PassField(),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ResetPassPage(),
                            ),
                          ),
                          child: const Text(
                            'Forget Password?',
                            style: Style.black10,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(child: const _LoginButton()),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmailField extends StatelessWidget {
  const _EmailField();

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: context.read<StateManagementProvider>().loginEmail,
      style: Style.brown13,
      decoration: InputDecoration(
        isDense: true,
        visualDensity: VisualDensity(vertical: 4),
        contentPadding: const EdgeInsets.symmetric(horizontal: 06, vertical: 1),
        hintText: 'e.g. user@gmail.com',
        labelText: 'Enter your email',
        labelStyle: Style.brown13,
        hintStyle: Style.brown13,
        focusedBorder: focusedBorders,
        enabledBorder: enabledBorder,
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
    return TextField(
      obscureText: passNotVisible,
      controller: context.read<StateManagementProvider>().loginPassword,
      style: Style.brown13,
      decoration: InputDecoration(
        isDense: true,
        visualDensity: VisualDensity(vertical: -2),
        contentPadding: const EdgeInsets.symmetric(horizontal: 06, vertical: 0),
        labelText: 'Enter your password',
        labelStyle: Style.brown13,
        hintText: '',
        hintStyle: Style.brown10,
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
        focusedBorder: focusedBorders,
        enabledBorder: enabledBorder,
      ),
    );
  }
}

class _LoginButton extends StatelessWidget {
  const _LoginButton();

  @override
  Widget build(BuildContext context) {
    final sz = MediaQuery.sizeOf(context);
    return Selector<StateManagementProvider, bool>(
      selector: (_, pro) => pro.isSettingTask,
      builder: (_, isDone, _) {
        if (isDone == true) {
          return globalProgressIndicator();
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
            overlayColor: Colors.black,
            backgroundColor: Theme.of(context).colorScheme.onPrimaryFixed,
            fixedSize: Size(sz.width * 1.0, sz.height * 0.08),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text('Login', style: Style.black18),
        );
      },
    );
  }
}
