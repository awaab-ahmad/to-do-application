import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/services/global_items.dart';
import 'package:to_do_app/services/provider_page.dart';

// ignore: must_be_immutable
class ResetPassPage extends StatelessWidget {
  TextEditingController resetPassController = TextEditingController();
  ResetPassPage({super.key});

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
          centerTitle: true,
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
          title: globalText('Reset Password', 18, FontWeight.w600),
        ),
        body: Column(
          children: [
            const SizedBox(height: 50),
            Expanded(
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                ),
                margin: EdgeInsets.zero,
                color: Theme.of(context).colorScheme.onSecondary,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      const SizedBox(height: 30),
                      Image.asset(
                        'images/reset-password.png',
                        height: height * 0.1,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'To reset your password, Enter your email down below and press the reset button to get the email for resetting your password.',
                        style: styleOnly(
                          Color(0xFF787878),
                          11,
                          FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        controller: resetPassController,
                        style: styleOnly(
                          Color(0xFF787878),
                          14,
                          FontWeight.w600,
                        ),
                        decoration: InputDecoration(
                          isDense: true,
                          visualDensity: VisualDensity(vertical: 2),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 02,
                            horizontal: 08,
                          ),
                          hintText: 'Enter your email',
                          hintStyle: styleOnly(
                            Color(0xFF787878),
                            14,
                            FontWeight.w600,
                          ),
                          focusedBorder: focusedBorders,
                          enabledBorder: enabledBorder,
                        ),
                      ),
                      const SizedBox(height: 40),
                      ElevatedButton(
                        onPressed: () async {
                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) =>
                                Center(child: globalProgressIndicator()),
                          );
                          await context
                              .read<StateManagementProvider>()
                              .resettingPasswordFunction(resetPassController);
                          if (!context.mounted) return;
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.secondary,
                          overlayColor: const Color(0xFF000000),
                          padding: EdgeInsets.zero,
                          shape: mainRadius,
                          fixedSize: Size(width * 0.55, height * 0.08),
                        ),
                        child: globalText(
                          'Reset Password',
                          16,
                          FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 80),
                      globalText(
                        'Important Note: If you don\'t see email is your inbox. Check the spam of your Gmail. You might find an email from noreply to reset your password. Thank You',
                        08,
                        FontWeight.w500,
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
