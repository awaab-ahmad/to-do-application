import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/utils/global_items.dart';
import 'package:to_do_app/utils/provider_page.dart';
import 'package:to_do_app/utils/reusables.dart/field_borders.dart';
import 'package:to_do_app/utils/reusables.dart/snack_bar.dart';
import 'package:to_do_app/utils/textStyles/styles.dart';

// In This file all the model Bottom sheets of this app would be managed
// here making the list of all the images
List<String> images = [
  'images/girl.png',
  'images/boy.png',
  'images/man.png',
  'images/man (1).png',
  'images/man (2).png',
  'images/woman.png',
  'images/woman (1).png',
  'images/woman (2).png',
];

// This bottom sheet is below container is for selecting the image
Container imageModalBottomSheet(double w, double h) {
  return Container(
    height: h * 0.32,
    width: w * 1.0,
    decoration: BoxDecoration(
      color: const Color(0xFFFFF9F0),
      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
    ),
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 05),
      child: Column(
        mainAxisSize: .min,
        crossAxisAlignment: .start,
        children: [
          Center(
            child: const SizedBox(
              height: 20,
              width: 100,
              child: Card(color: Colors.black),
            ),
          ),
          const SizedBox(height: 05),
          const Text('Select Image', style: Style.black13),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.symmetric(horizontal: 05, vertical: 05),
              itemCount: images.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
              ),
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 05, vertical: 05),
                  child: ClipOval(
                    child: Image.asset(images[index], height: h * 0.04),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    ),
  );
}

// This bottom sheet below is for changing the user's name
Container userNameChangingBottomSheet(
  double w,
  double h,
  BuildContext context,
  TextEditingController controller,
) {
  final buttonStyle = ElevatedButton.styleFrom(
    fixedSize: Size(w * 0.33, h * 0.05),
    backgroundColor: const Color(0xFFFFB74D),
    padding: const EdgeInsets.symmetric(vertical: 05),
    overlayColor: const Color(0xFF000000),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
  );
  return Container(
    height: h * 0.23,
    width: w * 1.0,
    decoration: BoxDecoration(
      color: const Color(0xFFFFF9F0),
      borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        mainAxisSize: .min,
        crossAxisAlignment: .center,
        children: [
          const SizedBox(height: 05),
          const SizedBox(
            height: 15,
            width: 60,
            child: Card(color: Color(0xFF000000)),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: controller,
            cursorColor: const Color(0xFF000000),
            cursorRadius: Radius.circular(15),
            autofocus: true,
            style: styleOnly(const Color(0xFF787878), 13, FontWeight.w600),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 05,
                vertical: 0,
              ),
              iconColor: const Color(0xFF000000),
              hintText: 'Enter New Name',
              hintStyle: styleOnly(
                const Color(0xFf787878),
                13,
                FontWeight.w600,
              ),
              focusedBorder: focusB,
              enabledBorder: enabledB,
            ),
          ),
          const Expanded(child: SizedBox()),
          Row(
            mainAxisAlignment: .end,
            children: [
              ElevatedButton(
                style: buttonStyle,
                onPressed: () {
                  if (controller.text.isNotEmpty) controller.clear();
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel', style: Style.black13),
              ),
              const SizedBox(width: 08),
              context.watch<StateManagementProvider>().isSettingTask == true
                  ? SizedBox(
                      height: h * 0.05,
                      width: w * 0.33,
                      child: Center(child: const GlobalIndicator()),
                    )
                  : ElevatedButton(
                      style: buttonStyle,
                      onPressed: () async {
                        final br = ScaffoldMessenger.of(context);
                        await context
                            .read<StateManagementProvider>()
                            .nameUpdating(controller);
                        br.showSnackBar(
                          globalBar('Restart app to see changes'),
                        );
                        if (!context.mounted) return;
                        Navigator.of(context).pop();
                      },
                      child: const Text('Change', style: Style.black13),
                    ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    ),
  );
}

Future sheet(BuildContext context, Widget child) async {
  return showModalBottomSheet(
    useSafeArea: true,
    isScrollControlled: true,
    context: context,
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: child,
      );
    },
  );
}

class CategoryRelatedSheet extends StatelessWidget {
  final String? id;
  final String title;
  final TextEditingController controller;
  final bool deletable;
  const CategoryRelatedSheet({
    super.key,
    this.id,
    required this.title,
    required this.controller,
    required this.deletable,
  });

  static const List<Color> colors = [
    Color(0xFFE8A268),
    Color(0xFF4A6B6B),
    Color(0xFF0F6E56),
    Color(0xFF7D6BC4),
    Color(0xFFC0574F),
    Color(0xFFB9722E),
  ];

  static ButtonStyle stl(Color bg, Color bor) {
    return ElevatedButton.styleFrom(
      elevation: 0,
      padding: const .symmetric(vertical: 15),
      shape: RoundedRectangleBorder(borderRadius: .circular(12)),
      backgroundColor: bg,
      side: BorderSide(color: bor, width: 1.4),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sz = MediaQuery.sizeOf(context);
    final c = Theme.of(context).colorScheme;
    return Container(
      height: sz.height * 0.45,
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9F0),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            const SizedBox(height: 10),
            Center(
              child: SizedBox(
                height: 10,
                width: 60,
                child: Card(margin: .zero, color: c.onSurfaceVariant),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                Text(title, style: Style.blc17Light),
                Selector<StateManagementProvider, bool>(
                  selector: (_, pro) => pro.isSettingTask,
                  builder: (_, allowed, _) {
                    if (allowed) {
                      return SizedBox(
                        height: 20,
                        width: 20,
                        child: const GlobalIndicator(),
                      );
                    }
                    if (deletable) {
                      return IconButton(
                        onPressed: () async {
                          final p = context.read<StateManagementProvider>();
                          await p.categoryDeletion(id!, context);
                        },
                        icon: Icon(Icons.delete),
                      );
                    }
                    return SizedBox.shrink();
                  },
                ),
              ],
            ),
            const Text('Category Name', style: Style.gry12),
            const SizedBox(height: 5),
            TextField(
              controller: controller,
              style: Style.mutedGry13,
              decoration: InputDecoration(
                filled: true,
                fillColor: c.onSecondary,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 08,
                ),
                focusedBorder: focusB,
                enabledBorder: enabledB,
                hintText: 'e.g. Programming',
                hintStyle: Style.mutedGry11,
              ),
            ),
            const SizedBox(height: 5),
            const Text('Choose the color', style: Style.gry12),
            SizedBox(
              height: sz.height * 0.08,
              child: ListView.builder(
                scrollDirection: .horizontal,
                itemCount: colors.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      final p = context.read<StateManagementProvider>();
                      p.changeColorInd(index);
                    },
                    child: Selector<StateManagementProvider, int>(
                      selector: (_, pro) => pro.colorInd,
                      builder: (_, indx, _) {
                        final selected = indx == index;
                        return Container(
                          margin: .symmetric(horizontal: 3),
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            border: BoxBorder.all(
                              width: 1.7,
                              color: selected ? c.secondary : colors[index],
                            ),
                            color: colors[index],
                            shape: .circle,
                          ),
                          child: selected
                              ? Icon(Icons.check, size: 30, color: c.surface)
                              : SizedBox.shrink(),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: stl(c.onSecondary, c.onPrimaryFixed),
                    onPressed: () {
                      controller.clear();
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel', style: Style.black13),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Selector<StateManagementProvider, bool>(
                    selector: (_, pro) => pro.isSettingTask,
                    builder: (_, allowed, _) => ElevatedButton(
                      style: stl(c.primary, c.primary),
                      onPressed: () async {
                        final p = context.read<StateManagementProvider>();
                        final color = colors[p.colorInd].toARGB32();
                        if (deletable) {
                          await p.editCategoryName(id!, color, context);
                        } else {
                          !allowed
                              ? () async {
                                  await p.categoryCreation(color, context);
                                }
                              : null;
                        }
                      },
                      child: Text(
                        deletable ? 'Save' : 'Create',
                        style: Style.black13,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// This bottom sheet is used for Creating our own category
// Container categoryCreatingBottomSheet(
//   double w,
//   double h,
//   BuildContext context,
//   TextEditingController controller,
//   Future<void> Function() func,
// ) {
//   final buttonStyle = ElevatedButton.styleFrom(
//     overlayColor: const Color(0xff000000),
//     shape: mainRadius,
//     padding: const EdgeInsets.symmetric(vertical: 05),
//     backgroundColor: const Color(0xFFFFB74D),
//     fixedSize: Size(w * 0.3, h * 0.06),
//   );
  
// }

// This below bottom sheet for moving tasks from one section to others
// class MovingTaskSheet extends StatelessWidget {
//   final String taskId;
//   const MovingTaskSheet({super.key, required this.taskId});

//   static ButtonStyle buttonStyleLastBtn(double w, double h) {
//     return ElevatedButton.styleFrom(
//       overlayColor: const Color(0xff000000),
//       padding: const EdgeInsets.symmetric(vertical: 08),
//       shape: mainRadius,
//       backgroundColor: const Color(0xFFFFB74D),
//       fixedSize: Size(w * 0.35, h * 0.06),
//     );
//   }

//   static ButtonStyle buttonStyle(Color c, double w, double h) {
//     return ElevatedButton.styleFrom(
//       overlayColor: const Color(0xFF000000),
//       padding: const EdgeInsets.all(0),
//       shape: mainRadius,
//       backgroundColor: c,
//       fixedSize: Size(w * 0.43, h * 0.05),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final sz = MediaQuery.sizeOf(context);
//     return Container(
//       clipBehavior: .antiAlias,
//       height: sz.height * 0.48,
//       width: sz.width * 1.0,
//       decoration: BoxDecoration(
//         color: const Color(0xFFFFF9F0),
//         borderRadius: BorderRadius.circular(25),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 08),
//         child: Column(
//           crossAxisAlignment: .start,
//           children: [
//             const SizedBox(height: 05),
//             const Center(
//               child: SizedBox(
//                 height: 15,
//                 width: 70,
//                 child: Card(color: Color(0xFF000000)),
//               ),
//             ),
//             const SizedBox(height: 05),
//             const Text('Move your task to', style: Style.black14),
//             Row(
//               mainAxisAlignment: .center,
//               children: [
//                 ElevatedButton(
//                   onPressed: () async {
//                     context.read<StateManagementProvider>().movingToWhichStatus(
//                       'Pending',
//                     );
//                   },
//                   style: buttonStyle(
//                     const Color(0xFF4FC3F7),
//                     sz.width,
//                     sz.height,
//                   ),
//                   child: const Text('Pending', style: Style.black12),
//                 ),
//                 const SizedBox(width: 05),
//                 ElevatedButton(
//                   onPressed: () async {
//                     context.read<StateManagementProvider>().movingToWhichStatus(
//                       'Completed',
//                     );
//                   },
//                   style: buttonStyle(
//                     const Color(0xFF81C784),
//                     sz.width,
//                     sz.height,
//                   ),
//                   child: const Text('Completed', style: Style.black12),
//                 ),
//               ],
//             ),
//             const Text('My Categories', style: Style.black14),
//             Expanded(
//               child: StreamBuilder(
//                 stream: context
//                     .read<StateManagementProvider>()
//                     .streamFetching(),
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return Center(child: const GlobalIndicator());
//                   } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                     return const Center(
//                       child: Text(
//                         'No User Categories found',
//                         style: Style.blc10,
//                       ),
//                     );
//                   }
//                   final data = snapshot.data!.docs;
//                   return GridView.builder(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 02,
//                       vertical: 0,
//                     ),
//                     itemCount: data.length,
//                     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 2,
//                       childAspectRatio: 3.2,
//                     ),
//                     itemBuilder: (context, index) {
//                       return Padding(
//                         padding: const EdgeInsets.symmetric(
//                           vertical: 04,
//                           horizontal: 04,
//                         ),
//                         child: ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                             shape: mainRadius,
//                             overlayColor: const Color(0xFF000000),
//                             backgroundColor: const Color(0xFFFFE3D2),
//                             side: BorderSide(
//                               color: const Color(0xff000000),
//                               width: 1.2,
//                             ),
//                           ),
//                           onPressed: () async {
//                             context
//                                 .read<StateManagementProvider>()
//                                 .movingToWhichCategory(
//                                   index,
//                                   data[index]['Category Name'],
//                                 );
//                           },
//                           child: Text(
//                             data[index]['Category Name'],
//                             style: Style.black14,
//                           ),
//                         ),
//                       );
//                     },
//                   );
//                 },
//               ),
//             ),
//             Selector<StateManagementProvider, String>(
//               selector: (_, pro) => pro.movingTo,
//               builder: (_, moveTo, _) =>
//                   Text('Moving To: $moveTo', style: Style.black11),
//             ),
//             Selector<StateManagementProvider, String>(
//               selector: (_, pro) => pro.category,
//               builder: (_, category, _) =>
//                   Text('Category: $category', style: Style.black11),
//             ),
//             const SizedBox(height: 10),
//             Row(
//               mainAxisAlignment: .end,
//               children: [
//                 ElevatedButton(
//                   style: buttonStyleLastBtn(sz.width, sz.height),
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                   child: const Text('Cancel', style: Style.black12),
//                 ),
//                 const SizedBox(width: 08),
//                 Selector<StateManagementProvider, bool>(
//                   selector: (_, pro) => pro.isSettingTask,
//                   builder: (_, isSetting, _) {
//                     if (isSetting) {
//                       return SizedBox(
//                         height: sz.height * 0.06,
//                         width: sz.width * 0.35,
//                         child: Center(child: const GlobalIndicator()),
//                       );
//                     }
//                     return ElevatedButton(
//                       style: buttonStyleLastBtn(sz.width, sz.height),
                      // onPressed: () async {
                      //   await context
                      //       .read<StateManagementProvider>()
                      //       .taskMovingBetweenLists(taskId);
                      //   if (!context.mounted) return;
                      //   Navigator.of(context).pop();
                      //   await context
                      //       .read<StateManagementProvider>()
                      //       .helperOfPendingCompletedLength();
                      // },
//                       child: const Text('Move', style: Style.black12),
//                     );
//                   },
//                 ),
//               ],
//             ),
//             const SizedBox(height: 10),
//           ],
//         ),
//       ),
//     );
//   }
// }
