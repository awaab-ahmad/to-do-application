import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/services/global_items.dart';
import 'package:to_do_app/services/provider_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
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
              color: const Color(0xFF000000),
            ),
          ),
          centerTitle: true,
          title: globalText('Sign Up', 18, FontWeight.w600),
        ),
        body: Column(
          children: [
            const SizedBox(height: 30),
            Image.asset('images/add-user.png', height: height * 0.1),
            const SizedBox(height: 40),
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
                            'Create Account!',
                            18,
                            FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      TextField(
                        controller: context
                            .read<StateManagementProvider>()
                            .signUpUserName,
                        style: styleOnly(
                          Color(0xff787878),
                          13,
                          FontWeight.w600,
                        ),
                        decoration: InputDecoration(
                          isDense: true,
                          visualDensity: VisualDensity(vertical: 4),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 06,
                            vertical: 2,
                          ),
                          labelText: 'Enter username',
                          labelStyle: styleOnly(
                            Color(0xFF787878),
                            13,
                            FontWeight.w600,
                          ),
                          hintText: 'e.g. Imran',
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
                        controller: context
                            .read<StateManagementProvider>()
                            .signUpEmail,
                        style: styleOnly(
                          Color(0xff787878),
                          13,
                          FontWeight.w600,
                        ),
                        decoration: InputDecoration(
                          isDense: true,
                          visualDensity: VisualDensity(vertical: 4),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 06,
                            vertical: 2,
                          ),
                          labelText: 'Enter your email',
                          labelStyle: styleOnly(
                            Color(0xFF787878),
                            13,
                            FontWeight.w600,
                          ),
                          hintText: 'e.g. user@gmail.com',
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
                            .signUpPassword,
                        style: styleOnly(
                          Color(0xff787878),
                          13,
                          FontWeight.w600,
                        ),
                        decoration: InputDecoration(
                          isDense: true,
                          visualDensity: VisualDensity(vertical: -2),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 06,
                            vertical: 0,
                          ),
                          labelText: 'Create your password',
                          hintText: '',
                          labelStyle: styleOnly(
                            Color(0xFF787878),
                            13,
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
                                  if (p.signUpUserName.text.trim().isNotEmpty &&
                                      p.signUpEmail.text.trim().isNotEmpty &&
                                      p.signUpPassword.text.trim().isNotEmpty) {
                                    await p.signUpFunction(context);
                                  } else {
                                    if (kDebugMode) print('Fill all first');
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  overlayColor: const Color(0xFF000000),
                                  backgroundColor: Theme.of(
                                    context,
                                  ).colorScheme.onPrimaryFixed,
                                  fixedSize: Size(width * 1.0, height * 0.08),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: globalText(
                                  'Sign Up',
                                  20,
                                  FontWeight.w600,
                                ),
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
