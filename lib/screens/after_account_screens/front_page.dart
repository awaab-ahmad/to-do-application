import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/screens/after_account_screens/creating_task_page.dart';
import 'package:to_do_app/screens/after_account_screens/manage_account.dart';
import 'package:to_do_app/utils/state/provider_page.dart';
import 'package:to_do_app/screens/after_account_screens/model_class_status.dart';
import 'package:to_do_app/utils/reusables.dart/bottom_sheets.dart';
import 'package:to_do_app/utils/reusables.dart/indicator_navigator.dart';
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
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: .start,
            children: [
              const Text('Good to see you here!', style: Style.gry14),
              Selector<StateManagementProvider, String?>(
                selector: (_, pro) => pro.auth.currentUser!.displayName,
                builder: (context, user, child) {
                  return Text('Hi, $user', style: Style.blc14);
                },
              ),
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
                  Icon(Icons.check_circle_outline, color: c.tertiary, size: 35),
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

class _MyCategories extends StatelessWidget {
  const _MyCategories();

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
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
                  onPressed: () {
                    final p = context.read<StateManagementProvider>();
                    final contro = p.categoryCon;
                    sheet(
                      context,
                      CategoryRelatedSheet(
                        title: 'New Category',
                        controller: contro,
                        deletable: false,
                      ),
                    );
                  },
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
              height: sz.height * 0.3,
              width: sz.width * 1.0,
              child: Card(
                margin: const EdgeInsets.all(0),
                color: const Color(0x00000000),
                shadowColor: const Color(0x00000000),
                clipBehavior: .antiAlias,
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final ind = data[index];
                    final cateName = ind['Category Name'];
                    final hasColor = ind.data().containsKey('color');
                    final color = hasColor ? Color(ind['color']) : c.primary;
                    return _CategoryBtn(
                      data: data,
                      index: index,
                      color: color,
                      cateName: cateName,
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

class _CategoryBtn extends StatelessWidget {
  final dynamic data;
  final int index;
  final Color color;
  final String cateName;
  const _CategoryBtn({
    required this.data,
    required this.index,
    required this.color,
    required this.cateName,
  });

  static ButtonStyle stl() {
    return ElevatedButton.styleFrom(
      elevation: 0,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      backgroundColor: const Color(0xFFFFFFFF),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: const Color(0xFFD9D6C9), width: 1.6),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    final p = context.read<StateManagementProvider>();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: ElevatedButton(
        onLongPress: () {
          final oldName = data[index]['Category Name'];
          p.oldCateNameAssign(oldName);
          sheet(
            context,
            CategoryRelatedSheet(
              oldName: oldName,
              id: data[index].id,
              title: 'Edit category',
              controller: p.categoryCon,
              deletable: true,
            ),
          );
        },
        onPressed: () {
          Navigator.of(context).push(
            navigate(
              ModelCategoryClass(appBarTitle: data[index]['Category Name']),
            ),
          );
        },
        style: stl(),
        child: Row(
          children: [
            Container(
              height: 8,
              width: 8,
              decoration: BoxDecoration(shape: .circle, color: color),
            ),
            const SizedBox(width: 10),
            Text(cateName, style: Style.black15),
            const Expanded(child: SizedBox()),
            StreamBuilder(
              stream: p.firestore
                  .collection('Users')
                  .doc(p.auth.currentUser!.uid)
                  .collection('Tasks')
                  .where('Category Name', isEqualTo: cateName)
                  .snapshots(),
              builder: (context, snapShots) {
                if (!snapShots.hasData) return SizedBox();
                final length = snapShots.data!.size;
                return SizedBox(
                  width: 70,
                  child: Text(
                    length > 1 ? '$length Tasks' : '$length Task',
                    style: Style.gry12,
                  ),
                );
              },
            ),
            Icon(
              Icons.keyboard_arrow_right_rounded,
              size: 25,
              color: c.onSurface,
            ),
          ],
        ),
      ),
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
          const Text('Recently deleted', style: Style.blc14),
          const Expanded(child: SizedBox()),
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
            onPressed: null,
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
