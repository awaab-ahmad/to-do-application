import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/utils/navigator.dart';
import 'package:to_do_app/utils/provider_page.dart';
import 'package:to_do_app/utils/reusables.dart/after_acc_topbar.dart';
import 'package:to_do_app/utils/textStyles/styles.dart';
import 'package:to_do_app/screens/before_account_screens/intro_page.dart';

// ignore: must_be_immutable
class ManageAccountPage extends StatelessWidget {
  TextEditingController newNameController = TextEditingController();
  ManageAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    const img = 'assets/images/boy.png';
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: .center,
            children: [
              AfterAccTopBar(
                title: 'Settings',
                subTitle: 'Manage user profile',
                extra: () {},
              ),
              const SizedBox(height: 40),
              Container(
                clipBehavior: .antiAlias,
                decoration: BoxDecoration(shape: .circle),
                height: 100,
                width: 100,
                child: Image.asset(img),
              ),
              const SizedBox(height: 5),
              const Text('Profile Photo', style: Style.gry12),
              Column(
                crossAxisAlignment: .start,
                children: [
                  const Text('Username', style: Style.gry14),
                  const SizedBox(height: 3),
                  _Fields(
                    nm: 'Awaab Ahmad',
                    nmStyle: Style.blc14,
                    ic: Icons.edit,
                    icColor: c.onSecondaryFixed,
                    containerBg: c.secondary,
                  ),
                  const SizedBox(height: 8),
                  const Text('Email', style: Style.gry14),
                  const SizedBox(height: 3),
                  _Fields(
                    nm: 'awaab8856@gmail.com',
                    nmStyle: Style.mutedGry13,
                    ic: Icons.lock,
                    icColor: c.onSurfaceVariant,
                    containerBg: c.primaryFixed,
                  ),
                ],
              ),
              const Expanded(child: SizedBox()),
              const _SignOutButton(),
              const SizedBox(height: 5),
            ],
          ),
        ),
      ),
    );
  }
}

class _Fields extends StatelessWidget {
  final String nm;
  final TextStyle nmStyle;
  final IconData ic;
  final Color icColor;
  final Color containerBg;
  const _Fields({
    required this.nm,
    required this.nmStyle,
    required this.ic,
    required this.icColor,
    required this.containerBg,
  });

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    return Container(
      padding: const .symmetric(horizontal: 8),
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: c.onSecondary,
        borderRadius: .circular(15),
        border: Border.all(color: c.onPrimaryFixed),
      ),
      child: Row(
        mainAxisAlignment: .spaceBetween,
        children: [
          Text(nm, style: nmStyle),
          IconButton(
            visualDensity: const VisualDensity(vertical: -2),
            onPressed: () {},
            icon: Icon(ic, color: icColor, size: 25),
          ),
        ],
      ),
    );
  }
}

class _SignOutButton extends StatelessWidget {
  const _SignOutButton();

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    return ElevatedButton(
      onPressed: () async {
        await context.read<StateManagementProvider>().auth.signOut();
        if (!context.mounted) return;
        Navigator.of(context).pushAndRemoveUntil(
          navigate(StartUpPage()),
          (Route<dynamic> route) => false,
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: c.onSecondary,
        shape: RoundedRectangleBorder(borderRadius: .circular(15)),
        side: BorderSide(color: c.error),
        fixedSize: Size(double.maxFinite, 50),
      ),
      child: Row(
        mainAxisAlignment: .center,
        children: [
          Icon(Icons.logout, color: c.error, size: 25),
          const SizedBox(width: 8),
          const Text('Sign Out', style: Style.red14),
        ],
      ),
    );
  }
}
 //   trailing: IconButton(
                  //     onPressed: () {
                  //       final p = context.read<StateManagementProvider>();
                  //       WidgetsBinding.instance.addPostFrameCallback((_) {
                  //         // showModalBottomSheet(
                  //         //   useSafeArea: true,
                  //         //   enableDrag: p.isSettingTask == true ? false : true,
                  //         //   isDismissible: p.isSettingTask == true ? false : true,
                  //         //   isScrollControlled: true,
                  //         //   context: context,
                  //         //   builder: (context) {
                  //         //     return Padding(
                  //         //       padding: EdgeInsets.only(
                  //         //         bottom: MediaQuery.of(context).viewInsets.bottom,
                  //         //       ),
                  //         //       child: userNameChangingBottomSheet(
                  //         //         width,
                  //         //         height,
                  //         //         context,
                  //         //         newNameController,
                  //         //       ),
                  //         //     );
                  //         //   },
                  //         // );
                  //       });

                     // ListTile(
              //   visualDensity: VisualDensity(vertical: -4),
              //   shape: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.circular(15),
              //   ),
              //   contentPadding: const EdgeInsets.only(left: 08, right: 04),
              //   tileColor: Theme.of(context).colorScheme.secondary,
              //   title: Text(
              //     'Username: ${context.read<StateManagementProvider>().auth.currentUser!.displayName}',
              //     style: Style.black12,
              //   ),
              //   trailing: IconButton(
              //     onPressed: () {
              //       final p = context.read<StateManagementProvider>();
              //       WidgetsBinding.instance.addPostFrameCallback((_) {
              //         showModalBottomSheet(
              //           useSafeArea: true,
              //           enableDrag: p.isSettingTask == true ? false : true,
              //           isDismissible: p.isSettingTask == true ? false : true,
              //           isScrollControlled: true,
              //           context: context,
              //           builder: (context) {
              //             return Padding(
              //               padding: EdgeInsets.only(
              //                 bottom: MediaQuery.of(context).viewInsets.bottom,
              //               ),
              //               child: userNameChangingBottomSheet(
              //                 width,
              //                 height,
              //                 context,
              //                 newNameController,
              //               ),
              //             );
              //           },
              //         );
              //       });
              //     },
              //     padding: EdgeInsets.zero,
              //     icon: Icon(
              //       Icons.edit,
              //       color: const Color(0xFF000000),
              //       size: height * 0.035,
              //     ),
              //   ),
              // ),