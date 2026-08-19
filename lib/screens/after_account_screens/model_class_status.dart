import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/screens/after_account_screens/task_details_page.dart';
import 'package:to_do_app/utils/global_items.dart';
import 'package:to_do_app/utils/navigator.dart';
import 'package:to_do_app/utils/provider_page.dart';
import 'package:to_do_app/utils/reusables.dart/after_acc_topbar.dart';
import 'package:to_do_app/utils/textStyles/styles.dart';

// ignore: must_be_immutable
class ModelStatusClass extends StatefulWidget {
  final String appBarTitle;
  const ModelStatusClass({super.key, required this.appBarTitle});

  @override
  State<ModelStatusClass> createState() => _ModelClassState();
}

class _ModelClassState extends State<ModelStatusClass> {
  Stream? nameCategories;
  @override
  void initState() {
    super.initState();
    nameCategories = context
        .read<StateManagementProvider>()
        .firestore
        .collection('Users')
        .doc(context.read<StateManagementProvider>().auth.currentUser!.uid)
        .collection('Categories')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    final isPen = widget.appBarTitle == 'Pending';
    return PopScope(
      onPopInvokedWithResult: (didPop, _) {
        context.read<StateManagementProvider>().cancelMultipleAllow();
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          child: SafeArea(
            child: Column(
              children: [
                Selector<StateManagementProvider, bool>(
                  selector: (_, pro) => pro.toSelectMultiple,
                  builder: (context, allowed, child) {
                    if (allowed) {
                      return _MoreOptionsBox(appBarTitle: widget.appBarTitle);
                    }
                    return Selector<StateManagementProvider, int>(
                      selector: (_, pro) =>
                          isPen ? pro.pendingTasks : pro.completedTasks,
                      builder: (_, length, _) => AfterAccTopBar(
                        title: widget.appBarTitle,
                        subTitle: '$length Tasks',
                        extra: () {},
                      ),
                    );
                  },
                ),
                _Tasks(appBarTitle: widget.appBarTitle),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MoreOptionsBox extends StatelessWidget {
  final String appBarTitle;
  const _MoreOptionsBox({required this.appBarTitle});

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    return Container(
      padding: const .symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: c.secondary,
        borderRadius: .circular(20),
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                padding: .zero,
                onPressed: () {
                  context.read<StateManagementProvider>().cancelMultipleAllow();
                },
                icon: Icon(Icons.close_rounded, color: c.onSecondary, size: 30),
              ),
              const SizedBox(width: 0),
              Selector<StateManagementProvider, int>(
                selector: (_, pro) => pro.toSelectMList.length,
                builder: (_, len, _) =>
                    Text('$len Selected', style: Style.wht14),
              ),
              const Expanded(child: SizedBox()),
              Selector<StateManagementProvider, bool>(
                selector: (_, pro) => pro.isSettingTask,
                builder: (_, toShow, _) {
                  if (toShow) {
                    return SizedBox(
                      height: 25,
                      width: 25,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: c.onSecondary,
                          strokeWidth: 5,
                        ),
                      ),
                    );
                  }
                  return SizedBox.shrink();
                },
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () async {
                  final p = context.read<StateManagementProvider>();
                  await p.movingMultipleTasks(
                    appBarTitle == 'Pending' ? 'Completed' : 'Pending',
                  );
                  await p.pendingCompletedLengthGetting();
                },
                style: ElevatedButton.styleFrom(
                  padding: const .symmetric(horizontal: 18),
                  backgroundColor: c.tertiary,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      color: c.onSecondary,
                      size: 25,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      appBarTitle == 'Pending'
                          ? 'Mark as completed'
                          : 'Mark as pending',
                      style: Style.wht12,
                    ),
                  ],
                ),
              ),

              ElevatedButton(
                onPressed: () {},
                child: Icon(Icons.delete, color: c.error, size: 30),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Tasks extends StatelessWidget {
  final String appBarTitle;
  const _Tasks({required this.appBarTitle});

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    return Expanded(
      child: Card(
        shape: mainRadius,
        clipBehavior: .antiAlias,
        color: const Color(0x00000000),
        shadowColor: const Color(0x00000000),
        child: StreamBuilder(
          stream: context.read<StateManagementProvider>().taskStreamFetch(
            appBarTitle,
          ),
          builder: (context, snp) {
            if (snp.connectionState == ConnectionState.waiting) {
              return Center(child: const GlobalIndicator());
            } else if (!snp.hasData || snp.data!.docs.isEmpty) {
              return Center(
                child: Text(
                  'No $appBarTitle Tasks Present',
                  style: Style.black14,
                ),
              );
            }
            final data = snp.data!.docs;
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final ind = data[index];
                final dynamic id = ind.id;
                final String title = ind['Task Title'];
                final String date = ind['Dated on'];
                final hasColor = ind.data().containsKey('color');
                final String category = ind['Category Name'];
                final String desc = ind['Task Description'];
                final String comDate = ind['Completion Date'];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 04),
                  child: _TaskTile(
                    id: id,
                    title: title,
                    desc: desc,
                    date: date,
                    color: hasColor ? c.error : c.primary,
                    status: ind['Task Status'],
                    category: category,
                    comDate: comDate,
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _TaskTile extends StatelessWidget {
  final dynamic id;
  final String title;
  final String desc;
  final String date;
  final Color color;
  final String status;
  final String category;
  final String comDate;
  const _TaskTile({
    this.id,
    required this.title,
    required this.desc,
    required this.date,
    required this.color,
    required this.status,
    required this.category,
    required this.comDate,
  });

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    return GestureDetector(
      onLongPress: () {
        context.read<StateManagementProvider>().allowMutlipleSelect();
      },
      onTap: () {
        if (kDebugMode) print(comDate);
        context.read<StateManagementProvider>().disallowEditDetailsPg();
        Navigator.of(context).push(
          navigate(
            TaskDetailsPage(
              taskId: id,
              title: title,
              description: desc,
              date: date,
              category: category,
              completionDate: comDate,
              status: status,
            ),
          ),
        );
      },
      child: Container(
        padding: const .only(left: 10, top: 5, bottom: 5),
        decoration: BoxDecoration(
          color: c.onSecondary,
          borderRadius: .circular(18),
          border: BoxBorder.all(color: c.onPrimaryFixed, width: 1.5),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Text(title, style: Style.blc14),
                  Text(
                    overflow: .ellipsis,
                    maxLines: 2,
                    desc,
                    style: Style.mutedGry11,
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Row(
                          children: [
                            Container(
                              height: 9,
                              width: 9,
                              decoration: BoxDecoration(
                                color: color,
                                shape: .circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(category, style: Style.gry12),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Row(
                          children: [
                            Icon(
                              Icons.calendar_today_outlined,
                              color: c.onSecondaryFixed,
                              size: 25,
                            ),
                            const SizedBox(width: 5),
                            FittedBox(child: Text(date, style: Style.drkOrg10)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            _IconChanging(id: id, status: status!, cate: category),
          ],
        ),
      ),
    );
  }
}

class _IconChanging extends StatelessWidget {
  final String id;
  final String status;
  final String cate;
  const _IconChanging({
    required this.id,
    required this.status,
    required this.cate,
  });

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    return Consumer<StateManagementProvider>(
      builder: (_, p, _) {
        final selected = p.toSelectMList.contains(id);
        if (!p.toSelectMultiple) {
          return PopupMenuButton(
            onSelected: (value) async {
              if (value == 'move') {
                final String moveTo = status == 'Pending'
                    ? 'Completed'
                    : 'Pending';
                await p.taskMovingBetweenLists(id, moveTo, cate);
                await p.pendingCompletedLengthGetting();
              }
              if (value == 'change') {}
            },
            elevation: 5,
            shape: RoundedRectangleBorder(borderRadius: .circular(20)),
            color: c.onSecondary,
            iconColor: c.onSurfaceVariant,
            iconSize: 30,
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  value: 'move',
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        color: status == 'Pending' ? c.tertiary : c.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        status == 'Pending'
                            ? 'Mark as completed'
                            : 'Mark as pending',
                        style: Style.blc10,
                      ),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'change',
                  child: Row(
                    children: [
                      Icon(Icons.folder_copy, color: c.onSurface, size: 20),
                      const SizedBox(width: 6),
                      const Text('Change category', style: Style.blc10),
                    ],
                  ),
                ),
              ];
            },
          );
        }
        return Transform.scale(
          scale: 1.4,
          child: Checkbox(
            activeColor: c.secondary,
            checkColor: c.onSecondary,
            shape: RoundedRectangleBorder(borderRadius: .circular(20)),
            value: selected,
            onChanged: (_) {
              p.addingMultipleItems(id);
            },
          ),
        );
      },
    );
  }
}

// ListTile(
//                               visualDensity: const VisualDensity(vertical: -2),
//                               isThreeLine: true,
//                               shape: mainRadius,
//                               tileColor: Theme.of(
//                                 context,
//                               ).colorScheme.onPrimary,
//                               contentPadding: const EdgeInsets.symmetric(
//                                 horizontal: 05,
//                                 vertical: 0,
//                               ),
//                               leading: IconButton(
//                                 onPressed: () {
//                                   context
//                                       .read<StateManagementProvider>()
//                                       .movingToANDcategoryCleaner();
//                                   showModalBottomSheet(
//                                     backgroundColor: const Color(0x00000000),
//                                     useSafeArea: true,
//                                     context: context,
//                                     builder: (context) => Padding(
//                                       padding: const EdgeInsets.symmetric(
//                                         horizontal: 10,
//                                         vertical: 15,
//                                       ),
//                                       child: MovingTaskSheet(
//                                         taskId: data[index].id,
//                                       ),
//                                     ),
//                                   );
//                                 },
//                                 padding: EdgeInsets.zero,
//                                 icon: Icon(
//                                   Icons.circle_outlined,
//                                   color: const Color(0xFF000000),
//                                   size: sz.height * 0.045,
//                                 ),
//                               ),
//                               trailing: IconButton(
//                                 onPressed: () {
//                                   if (widget.appBarTitle == 'Deleted') {
//                                     showDialog(
//                                       context: context,
//                                       builder: (alertContext) =>
//                                           ModelAlertDialogs(
//                                             alertDialogContext: alertContext,
//                                             title: 'Delete Task Permanently?',
//                                             firstElevatedButtonTitle: 'No',
//                                             secondElevatedButtonTitle: 'Yes',
//                                             firstElevatedButtonFunc: () =>
//                                                 Navigator.of(context).pop(),
//                                             secondElevatedButtonFunc: () async {
//                                               await context
//                                                   .read<
//                                                     StateManagementProvider
//                                                   >()
//                                                   .taskDeletion(data[index].id);
//                                             },
//                                           ),
//                                     );
//                                   } else {
//                                     showDialog(
//                                       context: context,
//                                       builder: (alertContext) =>
//                                           ModelAlertDialogs(
//                                             alertDialogContext: alertContext,
//                                             title: 'Trash this task?',
//                                             firstElevatedButtonTitle: 'No',
//                                             secondElevatedButtonTitle: 'Yes',
//                                             firstElevatedButtonFunc: () =>
//                                                 Navigator.of(context).pop(),
//                                             secondElevatedButtonFunc: () async {
//                                               await context
//                                                   .read<
//                                                     StateManagementProvider
//                                                   >()
//                                                   .movingTaskToDeletedCategory(
//                                                     data[index].id,
//                                                   );
//                                             },
//                                           ),
//                                     );
//                                   }
//                                 },
//                                 padding: EdgeInsets.zero,
//                                 icon: Image.asset(
//                                   'images/delete.png',
//                                   height: sz.height * 0.045,
//                                 ),
//                               ),
//                               onTap: () {
//                                 if (widget.appBarTitle == 'Deleted') {
//                                   if (kDebugMode) print('Nothing to do');
//                                 } else {
//                                   context
//                                       .read<StateManagementProvider>()
//                                       .assigningTaskCompletionDateOnPageAppearing(
//                                         data[index]['Completion Date'],
//                                       );
//                                   if (kDebugMode) {
//                                     print(
//                                       'Task Date is: ${context.read<StateManagementProvider>().taskCompletionDate}',
//                                     );
//                                   }
//                                   Navigator.of(context).push(
//                                     navigate(
//                                       TaskDetailsPage(
//                                         taskId: data[index].id,
//                                         title: data[index]['Task Title'],
//                                         description:
//                                             data[index]['Task Description'],
//                                         date: data[index]['Dated on'],
//                                         category: data[index]['Category Name'],
//                                         completionDate:
//                                             data[index]['Completion Date'],
//                                         isPressed: false,
//                                       ),
//                                     ),
//                                   );
//                                 }
//                               },
//                               title: Text(
//                                 data[index]['Task Title'],
//                                 maxLines: 1,
//                                 overflow: .ellipsis,
//                                 style: Style.black12,
//                               ),
//                               subtitle: Column(
//                                 crossAxisAlignment: .start,
//                                 children: [
//                                   Text(
//                                     data[index]['Dated on'],
//                                     style: Style.black12,
//                                   ),
//                                   Text(
//                                     'Category: ${data[index]['Category Name']}',
//                                     style: Style.black12,
//                                   ),
//                                 ],
//                               ),
//                             ),
