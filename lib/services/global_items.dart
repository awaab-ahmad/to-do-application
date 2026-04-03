import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/services/provider_page.dart';
import 'package:to_do_app/taskPages/manage_account.dart';

// Making the Circular Progress Indicator for all use
CircularProgressIndicator globalProgressIndicator() {
  return CircularProgressIndicator(
    strokeWidth: 4.5,
    color: const Color(0xFF3B82F6),
  );
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

final enabledBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(20),
  borderSide: BorderSide(color: const Color(0xFF787878), width: 1.2),
);

Container frontPageDrawer(double width, BuildContext context, double height) {
  final pro = context.read<StateManagementProvider>();
  Text drawerText(String text, double size, FontWeight fw) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        color: const Color(0xFF333333),
        fontSize: size,
        fontWeight: fw,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  return Container(
    margin: const EdgeInsets.only(top: 10, bottom: 10, left: 10),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25),
      color: Theme.of(context).colorScheme.onSecondary,
    ),
    width: width * 0.78,
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              globalText('To Do List', 18, FontWeight.w600),
              Builder(
                builder: (context) => IconButton(
                  onPressed: () {
                    Scaffold.of(context).closeDrawer();
                  },
                  icon: Icon(
                    Icons.close,
                    size: height * 0.04,
                    color: const Color(0xFF000000),
                  ),
                ),
              ),
            ],
          ),
          Card(
            margin: const EdgeInsets.all(0),
            color: Theme.of(context).colorScheme.secondary,
            child: Row(
              children: [
                ClipOval(
                  child: Image.asset('images/boy.png', height: height * 0.08),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 03),
                    child: Column(
                      crossAxisAlignment: .start,
                      children: [
                        const SizedBox(height: 05),
                        drawerText(
                          '${pro.auth.currentUser!.displayName}',
                          11,
                          FontWeight.w600,
                        ),
                        drawerText(
                          '${pro.auth.currentUser!.email}',
                          11,
                          FontWeight.w600,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Builder(
                            builder: (context) => ElevatedButton(
                              onPressed: () {
                                Scaffold.of(context).closeDrawer();
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => ManageAccountPage(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.zero,
                                overlayColor: const Color(0xFF000000),
                                backgroundColor: const Color(0xFF4FC3F7),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                fixedSize: Size(width * 0.32, height * 0.045),
                                side: BorderSide(
                                  color: const Color(0xFF000000),
                                  width: 1.4,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: .spaceBetween,
                                children: [
                                  const SizedBox(width: 04),
                                  drawerText('Manage', 12, FontWeight.w600),
                                  Icon(
                                    Icons.settings,
                                    color: const Color(0xFF333333),
                                    size: height * 0.03,
                                  ),
                                  const SizedBox(width: 04),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 05),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Expanded(child: SizedBox()),
          Align(
            alignment: Alignment.centerLeft,
            child: globalText('App Version: 2.3.3', 12, FontWeight.w600),
          ),
          const SizedBox(height: 10),
        ],
      ),
    ),
  );
}

Text textForTaskPages(String s) {
  return Text(
    maxLines: 1,
    overflow: TextOverflow.ellipsis,
    s,
    style: GoogleFonts.poppins(
      color: const Color(0xFf000000),
      fontSize: 12,
      fontWeight: FontWeight.w600,
    ),
  );
}

Text globalText(String s, double fontSize, FontWeight fw) {
  return Text(
    s,
    style: GoogleFonts.poppins(
      color: const Color(0xFF333333),
      fontSize: fontSize,
      fontWeight: fw,
    ),
  );
}

// Making the SystemOverlay Style for Whole App
final systemOverlay = const SystemUiOverlayStyle(
  statusBarColor: Color(0x00000000),
  statusBarIconBrightness: Brightness.dark,
  systemNavigationBarColor: Color(0xFFFFF9F0),
  systemNavigationBarContrastEnforced: false,
  systemNavigationBarDividerColor: Color(0xFFFFF9F0),
  systemNavigationBarIconBrightness: Brightness.dark,
);

class AlertDialogOfTaskInformation extends StatelessWidget {
  final double height;
  final String? task1;
  final String? task2;
  final String? task3;
  final String? task4;
  const AlertDialogOfTaskInformation({
    super.key,
    required this.height,
    this.task1,
    this.task2,
    this.task3,
    this.task4,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 15),
      titlePadding: EdgeInsets.symmetric(horizontal: 15, vertical: 05),
      contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 02),
      backgroundColor: const Color(0xFFFFF9F0),
      title: globalText('Task Behaviors', 18, FontWeight.w600),
      content: SizedBox(
        height: height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            (task1 != null && task1!.isNotEmpty)
                ? globalText('1: $task1', 13, FontWeight.w600)
                : SizedBox.shrink(),
            (task2 != null && task2!.isNotEmpty)
                ? globalText('2: $task2', 13, FontWeight.w600)
                : SizedBox.shrink(),
            (task3 != null && task3!.isNotEmpty)
                ? globalText('3: $task3', 13, FontWeight.w600)
                : SizedBox.shrink(),
            (task4 != null && task4!.isNotEmpty)
                ? globalText('4: $task4', 13, FontWeight.w600)
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}

Widget behaviorAlertDialog(double height) {
  return AlertDialog(
    insetPadding: const EdgeInsets.symmetric(horizontal: 15),
    titlePadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 05),
    contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 02),
    backgroundColor: const Color(0xFFFFF9F0),
    title: globalText('Task Behaviors', 18, FontWeight.w600),
    content: SizedBox(
      height: height,
      child: Column(
        crossAxisAlignment: .start,
        children: [
          globalText('1: Click to Open up Details.', 14, FontWeight.w600),
          globalText(
            '2: Click the Circular Button to change Task Status',
            14,
            FontWeight.w600,
          ),
          globalText(
            '3: Trash Button to move task to Recently deleted',
            14,
            FontWeight.w600,
          ),
        ],
      ),
    ),
  );
}
