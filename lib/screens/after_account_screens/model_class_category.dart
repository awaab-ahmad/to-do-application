// // here we would be making the model class for the working of the Pending
// // and the completed Tasks and other pages
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:to_do_app/utils/alert_dialog.dart';
// import 'package:to_do_app/utils/bottom_sheets.dart';
// import 'package:to_do_app/utils/global_items.dart';
// import 'package:to_do_app/utils/navigator.dart';
// import 'package:to_do_app/utils/provider_page.dart';
// import 'package:to_do_app/utils/textStyles/styles.dart';
// import 'package:to_do_app/screens/after_account_screens/task_details_page.dart';

// // ignore: must_be_immutable
// class ModelCategoryClass extends StatefulWidget {
//   String appBarTitle;
//   String taskTypeTitle;
//   ModelCategoryClass({
//     super.key,
//     required this.appBarTitle,
//     required this.taskTypeTitle,
//   });

//   @override
//   State<ModelCategoryClass> createState() => _ModelClassState();
// }

// class _ModelClassState extends State<ModelCategoryClass> {
//   Stream? myCategoriesStream;
//   @override
//   void initState() {
//     super.initState();
//     myCategoriesStream = context
//         .read<StateManagementProvider>()
//         .givingStreamOfCategoryPage(widget.appBarTitle, 'Pending');
//   }

//   @override
//   Widget build(BuildContext context) {
//     final sz = MediaQuery.sizeOf(context);
//     return Scaffold(
//       appBar: AppBar(
//         systemOverlayStyle: systemOverlay,
//         toolbarHeight: sz.height * 0.05,
//         scrolledUnderElevation: 0,
//         leading: IconButton(
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//           padding: EdgeInsets.zero,
//           icon: Icon(Icons.arrow_back, size: sz.height * 0.04),
//         ),
//         title: Text(widget.appBarTitle, style: Style.black18),
//         centerTitle: true,
//         backgroundColor: Theme.of(context).colorScheme.onSecondary,
//         shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
//         ),
//       ),
//       body: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 12),
//         child: Column(
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(widget.taskTypeTitle, style: Style.black18),
//                 IconButton(
//                   onPressed: () {
//                     showDialog(
//                       context: (context),
//                       builder: (context) => const BehaviorDialog(),
//                     );
//                   },
//                   padding: EdgeInsets.zero,
//                   icon: Image.asset(
//                     'images/information-button.png',
//                     height: sz.height * 0.04,
//                   ),
//                 ),
//               ],
//             ),
//             Row(
//               mainAxisAlignment: .spaceBetween,
//               children: [
//                 ElevatedButton(
//                   onPressed: () {
//                     setState(() {
//                       myCategoriesStream = context
//                           .read<StateManagementProvider>()
//                           .givingStreamOfCategoryPage(
//                             widget.appBarTitle,
//                             'Pending',
//                           );
//                     });
//                   },
//                   style: style(sz.width, sz.height, const Color(0xFFF97F7F)),
//                   child: const Text('Pending', style: Style.black14),
//                 ),
//                 ElevatedButton(
//                   onPressed: () {
//                     setState(() {
//                       myCategoriesStream = context
//                           .read<StateManagementProvider>()
//                           .givingStreamOfCategoryPage(
//                             widget.appBarTitle,
//                             'Completed',
//                           );
//                     });
//                   },
//                   style: style(sz.width, sz.height, const Color(0xFF81C784)),
//                   child: const Text('Completed', style: Style.black14),
//                 ),
//               ],
//             ),
//             Expanded(
//               child: Card(
//                 shape: mainRadius,
//                 clipBehavior: .antiAlias,
//                 color: const Color(0x00000000),
//                 shadowColor: const Color(0x00000000),
//                 child: StreamBuilder(
//                   stream: myCategoriesStream,
//                   builder: (context, snp) {
//                     if (snp.connectionState == ConnectionState.waiting) {
//                       return Center(child: const GlobalIndicator());
//                     } else if (!snp.hasData || snp.data!.docs.isEmpty) {
//                       return Center(
//                         child: Text(
//                           'No ${widget.appBarTitle} Tasks Present',
//                           style: Style.black15,
//                         ),
//                       );
//                     }
//                     final data = snp.data!.docs;
//                     return ListView.builder(
//                       itemCount: data.length,
//                       itemBuilder: (context, index) {
//                         return Padding(
//                           padding: const EdgeInsets.symmetric(vertical: 04),
//                           child: ListTile(
//                             visualDensity: VisualDensity(vertical: -2),
//                             isThreeLine: true,
//                             tileColor: Theme.of(context).colorScheme.onPrimary,
//                             contentPadding: EdgeInsets.symmetric(
//                               horizontal: 10,
//                               vertical: 0,
//                             ),
//                             leading: IconButton(
//                               onPressed: () {
//                                 if (kDebugMode) print(data[index].id);
//                                 // showModalBottomSheet(
//                                 //   backgroundColor: const Color(0x00000000),
//                                 //   useSafeArea: true,
//                                 //   context: context,
//                                 //   builder: (context) => Padding(
//                                 //     padding: const EdgeInsets.symmetric(
//                                 //       horizontal: 10,
//                                 //       vertical: 15,
//                                 //     ),
//                                 //     child: MovingTaskSheet(
//                                 //       taskId: data[index].id,
//                                 //     ),
//                                 //   ),
//                                 // );
//                               },
//                               padding: EdgeInsets.zero,
//                               icon: Icon(
//                                 Icons.circle_outlined,
//                                 color: const Color(0xFF000000),
//                                 size: sz.height * 0.05,
//                               ),
//                             ),
//                             trailing: IconButton(
//                               onPressed: () {
//                                 if (widget.appBarTitle == 'Deleted') {
//                                   showDialog(
//                                     context: context,
//                                     builder: (alertContext) =>
//                                         ModelAlertDialogs(
//                                           alertDialogContext: alertContext,
//                                           title: 'Delete Task Permanently?',
//                                           firstElevatedButtonTitle: 'No',
//                                           secondElevatedButtonTitle: 'Yes',
//                                           firstElevatedButtonFunc: () =>
//                                               Navigator.of(context).pop(),
//                                           secondElevatedButtonFunc: () async {
//                                             await context
//                                                 .read<StateManagementProvider>()
//                                                 .taskDeletion(data[index].id);
//                                           },
//                                         ),
//                                   );
//                                 } else {
//                                   showDialog(
//                                     context: context,
//                                     builder: (alertContext) =>
//                                         ModelAlertDialogs(
//                                           alertDialogContext: alertContext,
//                                           title: 'Trash this task?',
//                                           firstElevatedButtonTitle: 'No',
//                                           secondElevatedButtonTitle: 'Yes',
//                                           firstElevatedButtonFunc: () =>
//                                               Navigator.of(context).pop(),
//                                           secondElevatedButtonFunc: () async {
//                                             await context
//                                                 .read<StateManagementProvider>()
//                                                 .movingTaskToDeletedCategory(
//                                                   data[index].id,
//                                                 );
//                                           },
//                                         ),
//                                   );
//                                 }
//                               },
//                               padding: EdgeInsets.zero,
//                               icon: Image.asset(
//                                 'images/delete.png',
//                                 height: sz.height * 0.05,
//                               ),
//                             ),
//                             onTap: () {
//                               context
//                                   .read<StateManagementProvider>()
//                                   .assigningTaskCompletionDateOnPageAppearing(
//                                     data[index]['Completion Date'],
//                                   );
//                               if (kDebugMode) {
//                                 print(
//                                   'Task Date is: ${context.read<StateManagementProvider>().taskCompletionDate}',
//                                 );
//                               }
//                               Navigator.of(context).push(
//                                 navigate(
//                                   TaskDetailsPage(
//                                     taskId: data[index].id,
//                                     title: data[index]['Task Title'],
//                                     description:
//                                         data[index]['Task Description'],
//                                     date: data[index]['Dated on'],
//                                     category: data[index]['Category Name'],
//                                     completionDate:
//                                         data[index]['Completion Date'],                                 
//                                   ),
//                                 ),
//                               );
//                             },
//                             shape: mainRadius,
//                             title: Text(
//                               maxLines: 1,
//                               overflow: .ellipsis,
//                               data[index]['Task Title'],
//                               style: Style.black12,
//                             ),
//                             subtitle: Column(
//                               crossAxisAlignment: .start,
//                               children: [
//                                 Text(
//                                   data[index]['Dated on'],
//                                   style: Style.black12,
//                                 ),
//                                 Text(
//                                   'Category: ${data[index]['Category Name']}',
//                                   style: Style.black12,
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
//                       },
//                     );
//                   },
//                 ),
//                 // shadowColor: Colors.transparent,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   static ButtonStyle style(double w, double h, Color c) {
//     return ElevatedButton.styleFrom(
//       overlayColor: const Color(0xFF000000),
//       backgroundColor: c,
//       shape: mainRadius,
//       fixedSize: Size(w * 0.46, h * 0.05),
//     );
//   }
// }
