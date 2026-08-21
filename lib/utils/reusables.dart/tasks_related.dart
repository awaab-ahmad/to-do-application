import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/screens/after_account_screens/task_details_page.dart';
import 'package:to_do_app/utils/global_items.dart';
import 'package:to_do_app/utils/navigator.dart';
import 'package:to_do_app/utils/provider_page.dart';
import 'package:to_do_app/utils/textStyles/styles.dart';

class Tasks extends StatelessWidget {
  final Stream st;
  final String appBarTitle;
  const Tasks({super.key, required this.st, required this.appBarTitle});

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
          stream: st,
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
                final hasLastEdit = ind.data().containsKey('Last edited');
                String lastEdit = 'No date yet';
                if (hasLastEdit) {
                  Timestamp ts = ind['Last edited'];
                  DateTime dt = ts.toDate();
                  lastEdit = DateFormat('MMMM dd, yyyy').format(dt);
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 04),
                  child: TaskTile(
                    appBarTitle: appBarTitle,
                    id: id,
                    title: title,
                    desc: desc,
                    date: date,
                    color: hasColor ? c.error : c.primary,
                    status: ind['Task Status'],
                    category: category,
                    comDate: comDate,
                    lastEdit: lastEdit,
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

class TaskTile extends StatelessWidget {
  final String appBarTitle;
  final dynamic id;
  final String title, desc, date;
  final Color color;
  final String status, category, comDate, lastEdit;
  const TaskTile({
    super.key,
    required this.appBarTitle,
    this.id,
    required this.title,
    required this.desc,
    required this.date,
    required this.color,
    required this.status,
    required this.category,
    required this.comDate,
    required this.lastEdit,
  });

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    return Selector<StateManagementProvider, bool>(
      selector: (_, pro) => pro.toSelectMultiple,
      builder: (_, allowed, _) => GestureDetector(
        onLongPress:
            appBarTitle == 'Pending' ||
                appBarTitle == 'Completed' ||
                appBarTitle == 'Deleted'
            ? () {
                context.read<StateManagementProvider>().allowMutlipleSelect();
              }
            : null,
        onTap: () {
          if (appBarTitle != 'Deleted') {
            if (kDebugMode) print(comDate);
            if (!allowed) {
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
                    lastEdited: lastEdit,
                  ),
                ),
              );
            } else {
              context.read<StateManagementProvider>().addingMultipleItems(id);
            }
          }
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
                              FittedBox(
                                child: Text(date, style: Style.drkOrg10),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconChanging(
                appBarTitle: appBarTitle,
                id: id,
                status: status,
                cate: category,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class IconChanging extends StatelessWidget {
  final String appBarTitle, id, status, cate;
  const IconChanging({
    super.key,
    required this.appBarTitle,
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
        if (appBarTitle == 'Deleted') {
          if (p.toSelectMultiple) {
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
          } else {
            return const SizedBox.shrink();
          }
        }
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
        } else {
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
        }
      },
    );
  }
}
