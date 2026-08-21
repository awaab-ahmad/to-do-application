import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:to_do_app/utils/textStyles/styles.dart';

class GlobalIndicator extends StatelessWidget {
  const GlobalIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        strokeWidth: 4.5,
        color: const Color(0xFF3B82F6),
      ),
    );
  }
}

final mainRadius = RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(25),
);

TextStyle styleOnly(Color c, double size, FontWeight fw) {
  return GoogleFonts.poppins(color: c, fontSize: size, fontWeight: fw);
}

final focusedBorders = OutlineInputBorder(
  borderSide: BorderSide(color: const Color(0xFfFFE372), width: 1.2),
  borderRadius: BorderRadius.circular(20),
);

final enabledBorders = OutlineInputBorder(
  borderRadius: BorderRadius.circular(20),
  borderSide: BorderSide(color: const Color(0xFF787878), width: 1.2),
);
// Making the SystemOverlay Style for Whole App

class AlertDialogOfTaskInformation extends StatelessWidget {
  final String? task1;
  final String? task2;
  final String? task3;
  final String? task4;
  const AlertDialogOfTaskInformation({
    super.key,
    this.task1,
    this.task2,
    this.task3,
    this.task4,
  });

  @override
  Widget build(BuildContext context) {
    final sz = MediaQuery.sizeOf(context);
    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 15),
      titlePadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 05),
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 02),
      backgroundColor: const Color(0xFFFFF9F0),
      title: const Text('Task Behaviors', style: Style.black18),
      content: SizedBox(
        height: sz.height * 0.14,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            (task1 != null && task1!.isNotEmpty)
                ? Text('1: $task1', style: Style.black13)
                : SizedBox.shrink(),
            (task2 != null && task2!.isNotEmpty)
                ? Text('2: $task2', style: Style.black13)
                : SizedBox.shrink(),
            (task3 != null && task3!.isNotEmpty)
                ? Text('3: $task3', style: Style.black13)
                : SizedBox.shrink(),
            (task4 != null && task4!.isNotEmpty)
                ? Text('4: $task4', style: Style.black13)
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}

class BehaviorDialog extends StatelessWidget {
  const BehaviorDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 15),
      titlePadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 05),
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 02),
      backgroundColor: const Color(0xFFFFF9F0),
      title: const Text('Task Behaviors', style: Style.black18),
      content: SizedBox(
        height: height * 0.17,
        child: Column(
          crossAxisAlignment: .start,
          children: [
            const Text('1: Click to Open up Details.', style: Style.black14),
            const Text(
              '2: Click the Circular Button to change Task Status',
              style: Style.black14,
            ),
            const Text(
              '3: Trash Button to move task to Recently deleted',
              style: Style.black14,
            ),
          ],
        ),
      ),
    );
  }
}
