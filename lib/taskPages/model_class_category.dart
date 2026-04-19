// here we would be making the model class for the working of the Pending
// and the completed Tasks and other pages
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/services/alert_dialog.dart';
import 'package:to_do_app/services/bottom_sheets.dart';
import 'package:to_do_app/services/global_items.dart';
import 'package:to_do_app/services/provider_page.dart';
import 'package:to_do_app/taskPages/task_details_page.dart';

// ignore: must_be_immutable
class ModelCategoryClass extends StatefulWidget {
  String appBarTitle;
  String taskTypeTitle;
  ModelCategoryClass({
    super.key,
    required this.appBarTitle,
    required this.taskTypeTitle,
  });

  @override
  State<ModelCategoryClass> createState() => _ModelClassState();
}

class _ModelClassState extends State<ModelCategoryClass> {
  Stream? myCategoriesStream;
  Stream? nameCategories;
  @override
  void initState() {
    super.initState();
    myCategoriesStream = context
        .read<StateManagementProvider>()
        .givingStreamOfCategoryPage(widget.appBarTitle, 'Pending');
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
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: systemOverlay,
        toolbarHeight: height * 0.05,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          padding: EdgeInsets.zero,
          icon: Icon(Icons.arrow_back, size: height * 0.04),
        ),
        title: globalText(widget.appBarTitle, 18, FontWeight.w600),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.onSecondary,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                globalText(widget.taskTypeTitle, 18, FontWeight.w600),
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: (context),
                      builder: (context) => behaviorAlertDialog(height * 0.17),
                    );
                  },
                  padding: EdgeInsets.zero,
                  icon: Image.asset(
                    'images/information-button.png',
                    height: height * 0.04,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      myCategoriesStream = context
                          .read<StateManagementProvider>()
                          .givingStreamOfCategoryPage(
                            widget.appBarTitle,
                            'Pending',
                          );
                    });
                  },
                  style: style(width, height, const Color(0xFFF97F7F)),
                  child: globalText('Pending', 14, FontWeight.w600),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      myCategoriesStream = context
                          .read<StateManagementProvider>()
                          .givingStreamOfCategoryPage(
                            widget.appBarTitle,
                            'Completed',
                          );
                    });
                  },
                  style: style(width, height, const Color(0xFF81C784)),
                  child: globalText('Completed', 14, FontWeight.w600),
                ),
              ],
            ),
            Expanded(
              child: Card(
                shape: mainRadius,
                clipBehavior: .antiAlias,
                color: const Color(0x00000000),
                shadowColor: const Color(0x00000000),
                child: StreamBuilder(
                  stream: myCategoriesStream,
                  builder: (context, snp) {
                    if (snp.connectionState == ConnectionState.waiting) {
                      return Center(child: globalProgressIndicator());
                    } else if (!snp.hasData || snp.data!.docs.isEmpty) {
                      return Center(
                        child: globalText(
                          'No ${widget.appBarTitle} Tasks Present',
                          16,
                          FontWeight.w600,
                        ),
                      );
                    }
                    final data = snp.data!.docs;
                    return ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 04),
                          child: ListTile(
                            visualDensity: VisualDensity(vertical: -2),
                            isThreeLine: true,
                            tileColor: Theme.of(context).colorScheme.onPrimary,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 0,
                            ),
                            leading: IconButton(
                              onPressed: () {
                                if (kDebugMode) print(data[index].id);
                                showModalBottomSheet(
                                  backgroundColor: const Color(0x00000000),
                                  useSafeArea: true,
                                  context: context,
                                  builder: (context) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 15,
                                    ),
                                    child: movingTasksFromOneToOtherSheet(
                                      context,
                                      nameCategories,
                                      data[index].id,
                                      width,
                                      height,
                                    ),
                                  ),
                                );
                              },
                              padding: EdgeInsets.zero,
                              icon: Icon(
                                Icons.circle_outlined,
                                color: const Color(0xFF000000),
                                size: height * 0.05,
                              ),
                            ),
                            trailing: IconButton(
                              onPressed: () {
                                if (kDebugMode) {
                                  print(
                                    'The id of the doc is: ${data[index].id}',
                                  );
                                }
                                if (widget.appBarTitle == 'Deleted') {
                                  showDialog(
                                    context: context,
                                    builder: (alertContext) =>
                                        ModelAlertDialogs(
                                          alertDialogContext: alertContext,
                                          title: 'Delete Task Permanently?',
                                          firstElevatedButtonTitle: 'No',
                                          secondElevatedButtonTitle: 'Yes',
                                          firstElevatedButtonFunc: () =>
                                              Navigator.of(context).pop(),
                                          secondElevatedButtonFunc: () async {
                                            await context
                                                .read<StateManagementProvider>()
                                                .taskDeletion(data[index].id);
                                          },
                                        ),
                                  );
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (alertContext) =>
                                        ModelAlertDialogs(
                                          alertDialogContext: alertContext,
                                          title: 'Trash this task?',
                                          firstElevatedButtonTitle: 'No',
                                          secondElevatedButtonTitle: 'Yes',
                                          firstElevatedButtonFunc: () =>
                                              Navigator.of(context).pop(),
                                          secondElevatedButtonFunc: () async {
                                            await context
                                                .read<StateManagementProvider>()
                                                .movingTaskToDeletedCategory(
                                                  data[index].id,
                                                );
                                          },
                                        ),
                                  );
                                }
                              },
                              padding: EdgeInsets.zero,
                              icon: Image.asset(
                                'images/delete.png',
                                height: height * 0.05,
                              ),
                            ),
                            onTap: () {                   
                              context
                                    .read<StateManagementProvider>()
                                    .assigningTaskCompletionDateOnPageAppearing(
                                      data[index]['Completion Date'],
                                    );
                                if (kDebugMode) {
                                  print(
                                    'Task Date is: ${context.read<StateManagementProvider>().taskCompletionDate}',
                                  );
                                }          
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => TaskDetailsPage(
                                    taskId: data[index].id,
                                    title: data[index]['Task Title'],
                                    description:
                                        data[index]['Task Description'],
                                    date: data[index]['Dated on'],
                                    category: data[index]['Category Name'],
                                    completionDate:
                                        data[index]['Completion Date'],
                                    isPressed: false,
                                  ),
                                ),
                              );
                            },
                            shape: mainRadius,
                            title: textForTaskPages(data[index]['Task Title']),
                            subtitle: Column(
                              crossAxisAlignment: .start,
                              children: [
                                textForTaskPages(data[index]['Dated on']),
                                textForTaskPages(
                                  'Category: ${data[index]['Category Name']}',
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
                // shadowColor: Colors.transparent,
              ),
            ),
          ],
        ),
      ),
    );
  }

  ButtonStyle style(double w, double h, Color c) {
    return ElevatedButton.styleFrom(
      overlayColor: const Color(0xFF000000),
      backgroundColor: c,
      shape: mainRadius,
      fixedSize: Size(w * 0.46, h * 0.05),
    );
  }
}
