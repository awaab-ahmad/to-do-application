import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/services/global_items.dart';
import 'package:to_do_app/services/provider_page.dart';
import 'package:to_do_app/taskPages/reset_pass.dart';

// ignore: must_be_immutable
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Icon passShowingIcon = Icon(
    Icons.visibility_off,
    color: const Color(0xFF333333),
    size: 25,
  );
  bool passNotVisible = true;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        appBar: AppBar(
          systemOverlayStyle: systemOverlay,
          backgroundColor: Theme.of(context).colorScheme.onPrimary,
          toolbarHeight: height * 0.07,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back,
              size: height * 0.04,
              color: const Color(0xFF333333),
            ),
          ),
          centerTitle: true,
          title: globalText('Login', 18, FontWeight.w600),
        ),
        body: Column(
          children: [
            const SizedBox(height: 40),
            Image.asset('images/key.png', height: height * 0.1),
            const SizedBox(height: 80),
            Expanded(
              child: Container(
                margin: EdgeInsets.zero,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onSecondary,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      SizedBox(
                        width: width * 0.5,
                        child: FittedBox(
                          child: globalText(
                            'Welcome back!',
                            18,
                            FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      TextField(
                        controller: context
                            .read<StateManagementProvider>()
                            .loginEmail,
                        style: styleOnly(
                          Color(0xff787878),
                          13,
                          FontWeight.w600,
                        ),
                        decoration: InputDecoration(
                          isDense: true,
                          visualDensity: VisualDensity(vertical: 4),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 06,
                            vertical: 1,
                          ),
                          hintText: 'e.g. user@gmail.com',
                          labelText: 'Enter your email',
                          labelStyle: styleOnly(
                            const Color(0xFF787878),
                            13,
                            FontWeight.w600,
                          ),
                          hintStyle: styleOnly(
                            Color(0xFF787878),
                            10,
                            FontWeight.w600,
                          ),
                          focusedBorder: focusedBorders,
                          enabledBorder: enabledBorder,
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        obscureText: passNotVisible,
                        controller: context
                            .read<StateManagementProvider>()
                            .loginPassword,
                        style: styleOnly(
                          Color(0xff787878),
                          13,
                          FontWeight.w600,
                        ),
                        decoration: InputDecoration(
                          isDense: true,
                          visualDensity: VisualDensity(vertical: -2),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 06,
                            vertical: 0,
                          ),
                          labelText: 'Enter your password',
                          labelStyle: styleOnly(
                            const Color(0xFF787878),
                            13,
                            FontWeight.w600,
                          ),
                          hintText: '',
                          hintStyle: styleOnly(
                            Color(0xFF787878),
                            10,
                            FontWeight.w600,
                          ),
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
                      ),
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ResetPassPage(),
                            ),
                          ),
                          child: globalText(
                            'Forget Password?',
                            10,
                            FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child:
                            context
                                    .watch<StateManagementProvider>()
                                    .isSettingTask ==
                                true
                            ? globalProgressIndicator()
                            : ElevatedButton(
                                onPressed: () async {
                                  final p = context
                                      .read<StateManagementProvider>();
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
                                  backgroundColor: Theme.of(
                                    context,
                                  ).colorScheme.onPrimaryFixed,
                                  fixedSize: Size(width * 1.0, height * 0.08),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: globalText('Login', 20, FontWeight.w600),
                              ),
                      ),
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
