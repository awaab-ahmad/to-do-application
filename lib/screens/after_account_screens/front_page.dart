import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/screens/after_account_screens/creating_task_page.dart';
import 'package:to_do_app/screens/after_account_screens/manage_account.dart';
import 'package:to_do_app/utils/alert_dialog.dart';
import 'package:to_do_app/utils/global_items.dart';
import 'package:to_do_app/utils/navigator.dart';
import 'package:to_do_app/utils/provider_page.dart';
import 'package:to_do_app/screens/after_account_screens/model_class_status.dart';
import 'package:to_do_app/utils/reusables.dart/no_category_box.dart';
import 'package:to_do_app/utils/textStyles/styles.dart';
import 'package:to_do_app/screens/after_account_screens/model_class_category.dart';

class FrontPage extends StatefulWidget {
  const FrontPage({super.key});

  @override
  State<FrontPage> createState() => _FrontPageState();
}

class _FrontPageState extends State<FrontPage> {
  @override
  void initState() {
    super.initState();
    context.read<StateManagementProvider>().frontPgLengthHelper();
  }

  @override
  Widget build(BuildContext context) {
    final sz = MediaQuery.sizeOf(context);
    final c = Theme.of(context).colorScheme;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: .start,
            children: [
              const Text('Good to see you here!', style: Style.gry14),
              const Text('Hi, Awaab Ahmad Minhas', style: Style.blc14),
              const SizedBox(height: 15),
              const _MainCategories(),
              const SizedBox(height: 10),
              const _DeletedButton(),
              const SizedBox(height: 10),
              const _MyCategories(),
              const Expanded(child: SizedBox()),
              const _BottomBar(),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class _MainCategories extends StatelessWidget {
  const _MainCategories();

  static ButtonStyle categoriesButtonStyle(Color c, Color sd) {
    return ElevatedButton.styleFrom(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
      alignment: Alignment.centerLeft,
      elevation: 0,
      backgroundColor: c,
      side: BorderSide(color: sd, width: 1.4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    return Row(
      children: [
        Expanded(
          child: AspectRatio(
            aspectRatio: 1.0,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  navigate(const ModelStatusClass(appBarTitle: 'Pending')),
                );
              },
              style: categoriesButtonStyle(c.secondary, c.secondary),
              child: Column(
                crossAxisAlignment: .start,
                mainAxisAlignment: .center,
                children: [
                  Icon(Icons.check_circle_outline, color: c.primary, size: 35),
                  const SizedBox(height: 10),
                  Selector<StateManagementProvider, int>(
                    selector: (_, pro) => pro.pendingTasks,
                    builder: (_, pending, _) =>
                        Text('$pending', style: Style.wht25),
                  ),
                  const SizedBox(height: 10),
                  const Text('Pending', style: Style.gry14),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: AspectRatio(
            aspectRatio: 1.0,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  navigate(const ModelStatusClass(appBarTitle: 'Completed')),
                );
              },
              style: categoriesButtonStyle(c.onSecondary, c.onPrimaryFixed),
              child: Column(
                mainAxisAlignment: .center,
                crossAxisAlignment: .start,
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    color: c.tertiary,
                    size: 35,
                  ),
                  const SizedBox(height: 10),
                  Selector<StateManagementProvider, int>(
                    selector: (_, pro) => pro.completedTasks,
                    builder: (_, completed, _) =>
                        Text('$completed', style: Style.blc25),
                  ),
                  const SizedBox(height: 10),
                  const Text('Completed', style: Style.gry14),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// class _AddCategoryButton extends StatelessWidget {
//   static TextEditingController categoryController = TextEditingController();

//   const _AddCategoryButton();

//   @override
//   Widget build(BuildContext context) {
//     final sz = MediaQuery.sizeOf(context);
//     return ElevatedButton(
//       onPressed: () async {
//         showModalBottomSheet(
//           isScrollControlled: true,
//           useSafeArea: true,
//           backgroundColor: const Color(0x00000000),
//           context: context,
//           builder: (context) {
//             return Padding(
//               padding: EdgeInsets.only(
//                 bottom: MediaQuery.of(context).viewInsets.bottom,
//               ),
//               child: categoryCreatingBottomSheet(
//                 sz.width,
//                 sz.height,
//                 context,
//                 categoryController,
//                 () => context.read<StateManagementProvider>().categoryCreation(
//                   categoryController,
//                 ),
//               ),
//             );
//           },
//         );
//       },
//       style: ElevatedButton.styleFrom(
//         alignment: Alignment.centerLeft,
//         overlayColor: const Color(0xFF000000),
//         backgroundColor: const Color(0xFF86B2C5),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//         side: BorderSide(width: 1.5, color: const Color(0xFF000000)),
//         padding: const EdgeInsets.symmetric(vertical: 08, horizontal: 15),
//       ),
//       child: Row(
//         mainAxisAlignment: .start,
//         children: [
//           SizedBox(
//             width: sz.width * 0.65,
//             child: FittedBox(
//               child: const Text(
//                 'Create your own category',
//                 style: Style.black14,
//               ),
//             ),
//           ),
//           const Expanded(child: SizedBox()),
//           Image.asset('images/list.png', height: sz.height * 0.04),
//         ],
//       ),
//     );
//   }
// }

class _MyCategories extends StatelessWidget {
  const _MyCategories();

  @override
  Widget build(BuildContext context) {
    final sz = MediaQuery.sizeOf(context);
    return StreamBuilder(
      stream: context.read<StateManagementProvider>().streamFetching(),
      builder: (context, snaps) {
        if (snaps.connectionState == ConnectionState.waiting) {
          return Center(child: GlobalIndicator());
        } else if (!snaps.hasData || snaps.data!.docs.isEmpty) {
          return EmptyCategoryBox();
        }
        final data = snaps.data!.docs;
        return Column(
          crossAxisAlignment: .start,
          children: [
            Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                const Text('Categories', style: Style.black14),
                IconButton(
                  onPressed: () {},
                  padding: .zero,
                  icon: Row(
                    children: [
                      Icon(Icons.add, color: const Color(0xFF0F6E56)),
                      const Text('Add new', style: Style.grn12),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: sz.height * 0.06,
              width: sz.width * 1.0,
              child: Card(
                margin: const EdgeInsets.all(0),
                color: const Color(0x00000000),
                shadowColor: const Color(0x00000000),
                clipBehavior: .antiAlias,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 03),
                      child: ElevatedButton(
                        onLongPress: () {
                          if (kDebugMode) print(data[index].id);
                          showDialog(
                            context: context,
                            builder: (alertContext) => ModelAlertDialogs(
                              alertDialogContext: alertContext,
                              title: 'Want to remove this Category?',
                              firstElevatedButtonTitle: 'No',
                              secondElevatedButtonTitle: 'Yes',
                              firstElevatedButtonFunc: () =>
                                  Navigator.of(context).pop(),
                              secondElevatedButtonFunc: () async {
                                await context
                                    .read<StateManagementProvider>()
                                    .categoryDeletion(data[index].id);
                              },
                            ),
                          );
                        },
                        onPressed: () {
                          if (kDebugMode) {
                            print(
                              'The Name of this Page is: ${data[index]['Category Name']}',
                            );
                          }
                          // Navigator.of(context).push(
                          //   navigate(
                          //     ModelCategoryClass(
                          //       appBarTitle: data[index]['Category Name'],
                          //       taskTypeTitle:
                          //           '${data[index]['Category Name']} Tasks',
                          //     ),
                          //   ),
                          // );
                        },
                        style: ElevatedButton.styleFrom(
                          overlayColor: const Color(0xFF000000),
                          fixedSize: Size(sz.width * 0.4, sz.height * 0.035),
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          backgroundColor: const Color(0xFFF3DEBC),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                            side: BorderSide(
                              color: const Color(0xFF000000),
                              width: 1.4,
                            ),
                          ),
                        ),
                        child: Text(
                          data[index]['Category Name'],
                          style: Style.black15,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _DeletedButton extends StatelessWidget {
  const _DeletedButton();

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    return ElevatedButton(
      onPressed: () => Navigator.of(
        context,
      ).push(navigate(const ModelStatusClass(appBarTitle: 'Deleted'))),
      style: ElevatedButton.styleFrom(
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        backgroundColor: c.onSecondary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        side: BorderSide(color: c.onPrimaryFixed, width: 1.4),
      ),
      child: Row(
        children: [
          Icon(Icons.delete, color: c.error, size: 35),
          const SizedBox(width: 10),
          const Text('Deleted Tasks', style: Style.blc14),
          const Expanded(child: SizedBox()),
          const Text('0', style: Style.gry14),
          Icon(Icons.keyboard_arrow_right, color: c.onSurface, size: 25),
        ],
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar();
  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    return Container(
      margin: const .symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: c.onSecondary,
        border: BoxBorder.all(color: c.onPrimaryFixed),
        borderRadius: .circular(15),
      ),
      child: Row(
        mainAxisAlignment: .spaceEvenly,
        children: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.home_sharp, size: 35, color: c.secondary),
          ),
          Transform.translate(
            offset: Offset(0, -20),
            child: Container(
              padding: const .all(0),
              decoration: BoxDecoration(
                color: c.primary,
                borderRadius: .circular(15),
              ),
              child: IconButton(
                onPressed: () {
                  Navigator.of(
                    context,
                  ).push(navigate(const TaskCreationPage()));
                },
                icon: Icon(Icons.add, size: 40, color: c.surface),
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).push(navigate(ManageAccountPage()));
            },
            icon: Icon(Icons.settings, size: 35, color: c.onSurface),
          ),
        ],
      ),
    );
  }
}
