import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/services/alert_dialog.dart';
import 'package:to_do_app/services/bottom_sheets.dart';
import 'package:to_do_app/services/global_items.dart';
import 'package:to_do_app/services/navigator.dart';
import 'package:to_do_app/services/provider_page.dart';
import 'package:to_do_app/taskPages/creating_task_page.dart';
import 'package:to_do_app/taskPages/model_class_status.dart';
import 'package:to_do_app/services/styles.dart';
import 'package:to_do_app/taskPages/model_class_category.dart';

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
    return Scaffold(
      drawer: SafeArea(child: frontPageDrawer(sz.width, context, sz.height)),
      appBar: AppBar(
        systemOverlayStyle: systemOverlay,
        scrolledUnderElevation: 0,
        backgroundColor: Theme.of(context).colorScheme.onSecondary,
        toolbarHeight: sz.height * 0.06,
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
            icon: Image.asset('images/side-menu.png', height: sz.height * 0.03),
          ),
        ),
        title: const Text('Dashboard', style: Style.black18),
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
            const Text('Create Your Tasks', style: Style.black18),
            const _AddTaskButton(),
            const Text('Assign To', style: Style.black18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      navigate(const ModelStatusClass(appBarTitle: 'Pending')),
                    );
                  },
                  style: categoriesButtonStyle(
                    sz.width,
                    sz.height,
                    Theme.of(context).colorScheme.primary,
                  ),
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      const Text('Pending', style: Style.black15),
                      const Expanded(child: SizedBox()),
                      Selector<StateManagementProvider, int>(
                        selector: (_, pro) => pro.pendingTasks,
                        builder: (_, pending, _) =>
                            Text('Tasks: $pending', style: Style.black14),
                      ),
                      const SizedBox(height: 02),
                    ],
                  ),
                ),
                const Expanded(child: SizedBox()),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      navigate(
                        const ModelStatusClass(appBarTitle: 'Completed'),
                      ),
                    );
                  },
                  style: categoriesButtonStyle(
                    sz.width,
                    sz.height,
                    Theme.of(context).colorScheme.secondary,
                  ),
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      const Text('Completed', style: Style.black15),
                      const Expanded(child: SizedBox()),
                      Selector<StateManagementProvider, int>(
                        selector: (_, pro) => pro.completedTasks,
                        builder: (_, completed, _) =>
                            Text('Tasks: $completed', style: Style.black14),
                      ),
                      const SizedBox(height: 02),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 06),
            _AddCategoryButton(),
            const _MyCategories(),
            const SizedBox(height: 03),
            Row(
              children: [
                const Text('Recently Deleted', style: Style.black18),
                const SizedBox(width: 05),
                const Text('', style: Style.black15),
              ],
            ),
            const _DeletedButton(),
          ],
        ),
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

class _AddTaskButton extends StatelessWidget {
  const _AddTaskButton();

  @override
  Widget build(BuildContext context) {
    final sz = MediaQuery.sizeOf(context);
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).push(navigate(const TaskCreationPage()));
      },
      style: ElevatedButton.styleFrom(
        overlayColor: const Color(0xFF000000),
        fixedSize: Size(sz.width * 1.0, sz.height * 0.14),
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 15),
        backgroundColor: const Color(0xFFF2BB6C),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        side: BorderSide(color: const Color(0xFF000000), width: 1.4),
      ),
      child: Column(
        children: [
          ClipOval(
            child: Image.asset('images/add.png', height: sz.height * 0.05),
          ),
          const Expanded(child: SizedBox()),
          const Text('Add a New Task', style: Style.black14),
        ],
      ),
    );
  }
}

class _AddCategoryButton extends StatelessWidget {
  final TextEditingController categoryController = TextEditingController();

  _AddCategoryButton();

  @override
  Widget build(BuildContext context) {
    final sz = MediaQuery.sizeOf(context);
    return ElevatedButton(
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
                sz.width,
                sz.height,
                context,
                categoryController,
                () => context.read<StateManagementProvider>().categoryCreation(
                  categoryController,
                ),
              ),
            );
          },
        );
      },
      style: ElevatedButton.styleFrom(
        alignment: Alignment.centerLeft,
        overlayColor: const Color(0xFF000000),
        backgroundColor: const Color(0xFF86B2C5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        side: BorderSide(width: 1.5, color: const Color(0xFF000000)),
        padding: const EdgeInsets.symmetric(vertical: 08, horizontal: 15),
      ),
      child: Row(
        mainAxisAlignment: .start,
        children: [
          SizedBox(
            width: sz.width * 0.65,
            child: FittedBox(
              child: const Text(
                'Create your own category',
                style: Style.black14,
              ),
            ),
          ),
          const Expanded(child: SizedBox()),
          Image.asset('images/list.png', height: sz.height * 0.04),
        ],
      ),
    );
  }
}

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
          return SizedBox.shrink();
        }
        final data = snaps.data!.docs;
        return Column(
          crossAxisAlignment: .start,
          children: [
            const Text('My Categories', style: Style.black18),
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
                          Navigator.of(context).push(
                            navigate(
                              ModelCategoryClass(
                                appBarTitle: data[index]['Category Name'],
                                taskTypeTitle:
                                    '${data[index]['Category Name']} Tasks',
                              ),
                            ),
                          );
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
    final sz = MediaQuery.sizeOf(context);
    return ElevatedButton(
      onPressed: () => Navigator.of(
        context,
      ).push(navigate(const ModelStatusClass(appBarTitle: 'Deleted'))),
      style: ElevatedButton.styleFrom(
        overlayColor: const Color(0xFF000000),
        fixedSize: Size(sz.width * 1.0, sz.height * 0.14),
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 15),
        backgroundColor: const Color(0xFFAEAEAE),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        side: BorderSide(color: const Color(0xFF000000), width: 1.4),
      ),
      child: Column(
        children: [
          Image.asset('images/delete.png', height: sz.height * 0.05),
          const Expanded(child: SizedBox()),
          const Text('Deleted Tasks', style: Style.black14),
        ],
      ),
    );
  }
}
