import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/services/global_items.dart';
import 'package:to_do_app/services/provider_page.dart';

// This file contains all the AlertDialogs for the app
// ignore: must_be_immutable
class ModelAlertDialogs extends StatelessWidget {
  BuildContext alertDialogContext;
  String title;
  String firstElevatedButtonTitle;
  String secondElevatedButtonTitle;
  Function() firstElevatedButtonFunc;
  Function() secondElevatedButtonFunc;
  ModelAlertDialogs({
    super.key,
    required this.alertDialogContext,
    required this.title,
    required this.firstElevatedButtonTitle,
    required this.secondElevatedButtonTitle,
    required this.firstElevatedButtonFunc,
    required this.secondElevatedButtonFunc,
  });

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    final buttonStyle = ElevatedButton.styleFrom(
      fixedSize: Size(w * 0.25, h * 0.06),
      overlayColor: const Color(0x00000000),
      padding: const EdgeInsets.symmetric(vertical: 06),
      backgroundColor: const Color(0xFFFFB74D),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    );
    return Dialog(
      backgroundColor: const Color(0xFFFFF9F0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      insetPadding: EdgeInsets.zero,
      child: SizedBox(
        height: h * 0.18,
        width: w * 0.8,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: .start,
            mainAxisSize: .min,
            children: [
              const SizedBox(height: 05),
              globalText(title, 14, FontWeight.w600),
              const Expanded(child: SizedBox()),
              Row(
                mainAxisAlignment: .end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      firstElevatedButtonFunc();
                    },
                    style: buttonStyle,
                    child: globalText(
                      firstElevatedButtonTitle,
                      13,
                      FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 08),
                  context.watch<StateManagementProvider>().isSettingTask == true
                      ? SizedBox(
                          height: h * 0.06,
                          width: w * 0.25,
                          child: Center(child: globalProgressIndicator()),
                        )
                      : ElevatedButton(
                          onPressed: () async {
                            await secondElevatedButtonFunc();
                            if (!context.mounted) return;
                            Navigator.of(context).pop();
                             await context
                            .read<StateManagementProvider>()
                            .helperOfPendingCompletedLength();
                          },
                          style: buttonStyle,
                          child: globalText(
                            secondElevatedButtonTitle,
                            13,
                            FontWeight.w600,
                          ),
                        ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
