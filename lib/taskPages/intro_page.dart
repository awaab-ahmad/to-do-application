import 'package:flutter/material.dart';
import 'package:to_do_app/services/global_items.dart';
import 'package:to_do_app/taskPages/login.dart';
import 'package:to_do_app/taskPages/sign_up.dart';

class StartUpPage extends StatelessWidget {
  const StartUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Opacity(
            opacity: 0.7,
            child: Image.asset(
              fit: BoxFit.cover,
              'images/front.jpg',
              height: height * 1.0,
              width: width * 1.0,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 08),
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  const SizedBox(height: 70),
                  Center(
                    child: Image.asset(
                      'images/logo.png',
                      height: height * 0.15,
                    ),
                  ),
                  const SizedBox(height: 70),
                  SizedBox(
                    width: width * 0.5,
                    child: FittedBox(
                      child: Text(
                        'Get Started',
                        style: styleOnly(
                          const Color(0xFFFFFFFF),
                          15,
                          FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  // globalText('Set up your account to begin', 16, FontWeight.w600),
                  Text(
                    'Set up your accout to begin',
                    style: styleOnly(
                      const Color(0xFFffffff),
                      16,
                      FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 70),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(
                          context,
                        ).push(MaterialPageRoute(builder: (_) => LoginPage()));
                      },
                      style: buttonStyle(
                        width,
                        height,
                        Theme.of(context).colorScheme.secondary,
                      ),
                      child: globalText('Login', 16, FontWeight.w600),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(
                          context,
                        ).push(MaterialPageRoute(builder: (_) => SignUpPage()));
                      },
                      style: buttonStyle(
                        width,
                        height,
                        Theme.of(context).colorScheme.onPrimary,
                      ),
                      child: globalText('Sign Up', 16, FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      // body: Padding(
      //   padding: const EdgeInsets.symmetric(horizontal: 08),
      // ),
    );
  }

  ButtonStyle buttonStyle(double w, double h, Color c) {
    return ElevatedButton.styleFrom(
      overlayColor: Colors.black,
      shape: mainRadius,
      fixedSize: Size(w * 0.5, h * 0.08),
      backgroundColor: c,
    );
  }
}
