import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/services/alert_dialog.dart';
import 'package:to_do_app/services/bottom_sheets.dart';
import 'package:to_do_app/services/global_items.dart';
import 'package:to_do_app/services/provider_page.dart';
import 'package:to_do_app/taskPages/creating_task_page.dart';
import 'package:to_do_app/taskPages/model_class_status.dart';
import 'package:to_do_app/taskPages/model_class_category.dart';

class FrontPage extends StatefulWidget {
  const FrontPage({super.key});

  @override
  State<FrontPage> createState() => _FrontPageState();
}

class _FrontPageState extends State<FrontPage> {
  TextEditingController categoryController = TextEditingController();
  // making the Stream to just fetch once
  Stream? myCategoriesStream;

  @override
  void initState() {
    super.initState();
    context.read<StateManagementProvider>().assigningLength();
    myCategoriesStream = context
        .read<StateManagementProvider>()
        .firestore
        .collection('Users')
        .doc(context.read<StateManagementProvider>().auth.currentUser!.uid)
        .collection('Categories')
        .snapshots();
    context.read<StateManagementProvider>().pendingCompletedLengthGetting();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      drawer: SafeArea(child: frontPageDrawer(width, context, height)),
      appBar: AppBar(
        systemOverlayStyle: systemOverlay,
        scrolledUnderElevation: 0,
        backgroundColor: Theme.of(context).colorScheme.onSecondary,
        toolbarHeight: height * 0.06,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(15),
            bottomRight: Radius.circular(15),
          ),
        ),
        leading: Builder(
          builder: (context) => IconButton(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: Image.asset('images/side-menu.png', height: height * 0.03),
          ),
        ),
        title: globalText('Dashboard', 18, FontWeight.w600),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: ListView(
          physics: BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          children: [
            const SizedBox(height: 10),
            globalText('Create Your Tasks', 18, FontWeight.w600),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => TaskCreationPage()),
                );
              },
              style: addingTaskButtonStyle(Color(0xFFF2BB6C), width, height),
              child: Column(
                children: [
                  ClipOval(
                    child: Image.asset('images/add.png', height: height * 0.05),
                  ),
                  const Expanded(child: SizedBox()),
                  globalText('Add a New Task', 14, FontWeight.w600),
                ],
              ),
            ),
            globalText('Categories:', 18, FontWeight.w600),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ModelStatusClass(
                          appBarTitle: 'Pending',
                          taskTypeTitle: 'Pending Tasks',
                        ),
                      ),
                    );
                  },
                  style: categoriesButtonStyle(
                    width,
                    height,
                    Theme.of(context).colorScheme.primary,
                  ),
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      globalText('Pending', 15, FontWeight.w600),
                      const Expanded(child: SizedBox()),
                      globalText(
                        'Tasks: ${context.watch<StateManagementProvider>().pendingTasks}',
                        14,
                        FontWeight.w600,
                      ),
                      const SizedBox(height: 02),
                    ],
                  ),
                ),
                const Expanded(child: SizedBox()),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ModelStatusClass(
                          appBarTitle: 'Completed',
                          taskTypeTitle: 'Completed Tasks',
                        ),
                      ),
                    );
                  },
                  style: categoriesButtonStyle(
                    width,
                    height,
                    Theme.of(context).colorScheme.secondary,
                  ),
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      globalText('Completed', 15, FontWeight.w600),
                      const Expanded(child: SizedBox()),
                      globalText(
                        'Tasks: ${context.watch<StateManagementProvider>().completedTasks}',
                        14,
                        FontWeight.w600,
                      ),
                      const SizedBox(height: 02),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 06),
            ElevatedButton(
              onPressed: () async {
                showModalBottomSheet(
                  isScrollControlled: true,
                  useSafeArea: true,
                  backgroundColor: const Color(0x00000000),
                  context: context,
                  builder: (context) {
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                      ),
                      child: categoryCreatingBottomSheet(
                        width,
                        height,
                        context,
                        categoryController,
                        () => context
                            .read<StateManagementProvider>()
                            .categoryCreation(categoryController),
                      ),
                    );
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                alignment: Alignment.centerLeft,
                overlayColor: const Color(0xFF000000),
                backgroundColor: const Color(0xFF86B2C5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                side: BorderSide(width: 1.5, color: const Color(0xFF000000)),
                padding: const EdgeInsets.symmetric(
                  vertical: 08,
                  horizontal: 15,
                ),
              ),
              child: Row(
                mainAxisAlignment: .start,
                children: [
                  SizedBox(
                    width: width * 0.65,
                    child: FittedBox(
                      child: globalText(
                        'Create your own category',
                        14,
                        FontWeight.w600,
                      ),
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                  Image.asset('images/list.png', height: height * 0.04),
                ],
              ),
            ),
            globalText('My Categories', 18, FontWeight.w600),
            StreamBuilder(
              stream: myCategoriesStream,
              builder: (context, snaps) {
                if (snaps.connectionState == ConnectionState.waiting) {
                  return Center(child: globalProgressIndicator());
                } else if (!snaps.hasData || snaps.data!.docs.isEmpty) {
                  return SizedBox.shrink();
                }
                final data = snaps.data!.docs;
                return SizedBox(
                  height: height * 0.06,
                  width: width * 1.0,
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
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => ModelCategoryClass(
                                    appBarTitle: data[index]['Category Name'],
                                    taskTypeTitle:
                                        '${data[index]['Category Name']} Tasks',
                                  ),
                                ),
                              );
                            },
                            style: myCategoriesStyle(width, height),
                            child: globalText(
                              data[index]['Category Name'],
                              15,
                              FontWeight.w600,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 03),
            Row(
              children: [
                globalText('Recently Deleted', 18, FontWeight.w600),
                const SizedBox(width: 05),
                globalText('', 12, FontWeight.w600),
              ],
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ModelStatusClass(
                    appBarTitle: 'Deleted',
                    taskTypeTitle: 'Deleted Tasks',
                  ),
                ),
              ),
              style: addingTaskButtonStyle(
                const Color(0xFFAEAEAE),
                width,
                height,
              ),
              child: Column(
                children: [
                  Image.asset('images/delete.png', height: height * 0.05),
                  const Expanded(child: SizedBox()),
                  globalText('Deleted Tasks', 14, FontWeight.w600),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  ButtonStyle addingTaskButtonStyle(Color c, double w, double h) {
    return ElevatedButton.styleFrom(
      overlayColor: const Color(0xFF000000),
      fixedSize: Size(w * 1.0, h * 0.14),
      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 15),
      backgroundColor: c,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      side: BorderSide(color: const Color(0xFF000000), width: 1.4),
    );
  }

  ButtonStyle myCategoriesStyle(double w, double h) {
    return ElevatedButton.styleFrom(
      overlayColor: const Color(0xFF000000),
      fixedSize: Size(w * 0.4, h * 0.035),
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: 10),
      backgroundColor: const Color(0xFFF3DEBC),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: const Color(0xFF000000), width: 1.4),
      ),
    );
  }

  ButtonStyle categoriesButtonStyle(double width, double height, Color c) {
    return ElevatedButton.styleFrom(
      padding: EdgeInsets.symmetric(horizontal: 08, vertical: 04),
      alignment: Alignment.centerLeft,
      overlayColor: const Color(0xFF000000),
      fixedSize: Size(width * 0.45, height * 0.1),
      backgroundColor: c,
      side: BorderSide(color: Colors.black, width: 1.4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    );
  }
}
