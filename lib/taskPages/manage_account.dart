import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/services/bottom_sheets.dart';
import 'package:to_do_app/services/global_items.dart';
import 'package:to_do_app/services/provider_page.dart';
import 'package:to_do_app/taskPages/intro_page.dart';

// ignore: must_be_immutable
class ManageAccountPage extends StatelessWidget {
  TextEditingController newNameController = TextEditingController();
  ManageAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF9F0),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            Icons.arrow_back,
            size: height * 0.04,
            color: const Color(0xFF000000),
          ),
        ),
        toolbarHeight: height * 0.05,
        centerTitle: true,
        title: globalText('Manage Account', 18, FontWeight.w600),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          crossAxisAlignment: .center,
          // mainAxisAlignment: .center,
          children: [
            const SizedBox(height: 40),
            ClipOval(
              child: Image.asset('images/boy.png', height: height * 0.12),
            ),                       
            const SizedBox(height: 40),
            ListTile(
              visualDensity: VisualDensity(vertical: -4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              contentPadding: const EdgeInsets.only(left: 08, right: 04),
              tileColor: Theme.of(context).colorScheme.secondary,
              title: globalText(
                'Username: ${context.read<StateManagementProvider>().auth.currentUser!.displayName}',
                12,
                FontWeight.w600,
              ),
              trailing: IconButton(
                onPressed: () {
                  final p = context.read<StateManagementProvider>();
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    showModalBottomSheet(
                      useSafeArea: true,
                      enableDrag: p.isSettingTask == true ? false : true,
                      isDismissible: p.isSettingTask == true ? false : true,
                      isScrollControlled: true,
                      context: context,
                      builder: (context) {
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom,
                          ),
                          child: userNameChangingBottomSheet(
                            width,
                            height,
                            context,
                            newNameController,
                          ),
                        );
                      },
                    );
                  });
                },
                padding: EdgeInsets.zero,
                icon: Icon(
                  Icons.edit,
                  color: const Color(0xFF000000),
                  size: height * 0.035,
                ),
              ),
            ),
            const SizedBox(height: 10),
            ListTile(
              dense: true,
              visualDensity: VisualDensity(vertical: -2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              contentPadding: EdgeInsets.only(left: 08, right: 04),
              tileColor: Theme.of(context).colorScheme.secondary,
              title: globalText(
                'Email: ${context.read<StateManagementProvider>().auth.currentUser!.email}',
                12,
                FontWeight.w600,
              ),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () async {
                await context.read<StateManagementProvider>().auth.signOut();
                if (!context.mounted) return;
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => StartUpPage()),
                  (Route<dynamic> route) => false,
                );
              },
              style: signOutStyle(width, height),
              child: globalText('Sign Out', 14, FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  ButtonStyle changeButtonStyle(double w, double h) {
    return ElevatedButton.styleFrom(
      visualDensity: VisualDensity(vertical: -2),
      overlayColor: const Color(0xFF000000),
      padding: const EdgeInsets.all(0),
      fixedSize: Size(w * 0.24, h * 0.04),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      backgroundColor: const Color(0xFF4FC3F7),
    );
  }

  ButtonStyle signOutStyle(double w, double h) {
    return ElevatedButton.styleFrom(
      overlayColor: Colors.black,
      fixedSize: Size(w * 0.5, h * 0.07),
      shape: mainRadius,
      backgroundColor: const Color(0xFFFFB74D),
    );
  }
}
