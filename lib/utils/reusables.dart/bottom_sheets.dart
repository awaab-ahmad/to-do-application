import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/utils/state/provider_page.dart';
import 'package:to_do_app/utils/reusables.dart/field_borders.dart';
import 'package:to_do_app/utils/reusables.dart/indicator_navigator.dart';
import 'package:to_do_app/utils/textStyles/styles.dart';

// This bottom sheet below is for changing the user's name
// Container userNameChangingBottomSheet(
//   double w,
//   double h,
//   BuildContext context,
//   TextEditingController controller,
// ) {
//   final buttonStyle = ElevatedButton.styleFrom(
//     fixedSize: Size(w * 0.33, h * 0.05),
//     backgroundColor: const Color(0xFFFFB74D),
//     padding: const EdgeInsets.symmetric(vertical: 05),
//     overlayColor: const Color(0xFF000000),
//     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//   );
//   return Container(
//     height: h * 0.23,
//     width: w * 1.0,
//     decoration: BoxDecoration(
//       color: const Color(0xFFFFF9F0),
//       borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
//     ),
//     child: Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 12),
//       child: Column(
//         mainAxisSize: .min,
//         crossAxisAlignment: .center,
//         children: [
//           const SizedBox(height: 05),
//           const SizedBox(
//             height: 15,
//             width: 60,
//             child: Card(color: Color(0xFF000000)),
//           ),
//           const SizedBox(height: 10),
//           TextField(
//             controller: controller,
//             cursorColor: const Color(0xFF000000),
//             cursorRadius: Radius.circular(15),
//             autofocus: true,
//             style: styleOnly(const Color(0xFF787878), 13, FontWeight.w600),
//             decoration: InputDecoration(
//               contentPadding: const EdgeInsets.symmetric(
//                 horizontal: 05,
//                 vertical: 0,
//               ),
//               iconColor: const Color(0xFF000000),
//               hintText: 'Enter New Name',
//               hintStyle: styleOnly(
//                 const Color(0xFf787878),
//                 13,
//                 FontWeight.w600,
//               ),
//               focusedBorder: focusB,
//               enabledBorder: enabledB,
//             ),
//           ),
//           const Expanded(child: SizedBox()),
//           Row(
//             mainAxisAlignment: .end,
//             children: [
//               ElevatedButton(
//                 style: buttonStyle,
//                 onPressed: () {
//                   if (controller.text.isNotEmpty) controller.clear();
//                   Navigator.of(context).pop();
//                 },
//                 child: const Text('Cancel', style: Style.black13),
//               ),
//               const SizedBox(width: 08),
//               context.watch<StateManagementProvider>().isSettingTask == true
//                   ? SizedBox(
//                       height: h * 0.05,
//                       width: w * 0.33,
//                       child: Center(child: const GlobalIndicator()),
//                     )
//                   : ElevatedButton(
//                       style: buttonStyle,
//                       onPressed: () async {
//                         final br = ScaffoldMessenger.of(context);
//                         await context
//                             .read<StateManagementProvider>()
//                             .nameUpdating(controller);
//                         br.showSnackBar(
//                           globalBar('Restart app to see changes'),
//                         );
//                         if (!context.mounted) return;
//                         Navigator.of(context).pop();
//                       },
//                       child: const Text('Change', style: Style.black13),
//                     ),
//             ],
//           ),
//           const SizedBox(height: 20),
//         ],
//       ),
//     ),
//   );s
// }

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

class ChangeCategorySheet extends StatelessWidget {
  final String oldCate;
  final String taskId;
  const ChangeCategorySheet({
    super.key,
    required this.oldCate,
    required this.taskId,
  });

  static ButtonStyle stl(Color bg, Color bor) {
    return ElevatedButton.styleFrom(
      backgroundColor: bg,
      shape: RoundedRectangleBorder(borderRadius: .circular(12)),
      elevation: 0,
      padding: const .symmetric(vertical: 12, horizontal: 18),
      side: BorderSide(color: bor),
    );
  }

  static Container colorCon(Color color) {
    return Container(
      height: 13,
      width: 13,
      decoration: BoxDecoration(color: color, shape: .circle),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sz = MediaQuery.sizeOf(context);
    final c = Theme.of(context).colorScheme;
    return Container(
      height: sz.height * 0.45,
      padding: const .symmetric(horizontal: 16),
      width: double.maxFinite,
      decoration: BoxDecoration(
        borderRadius: .circular(15),
        color: const Color(0xFFF5F3ED),
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          const SizedBox(height: 8),
          Center(
            child: Container(
              height: 8,
              width: 70,
              decoration: BoxDecoration(
                color: c.onSurfaceVariant,
                borderRadius: .circular(15),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              Text('Change category', style: Style.blc17Light),
              Selector<StateManagementProvider, bool>(
                selector: (_, pro) => pro.inSheetLoading,
                builder: (_, allowed, _) {
                  if (allowed) {
                    return SizedBox(
                      height: 20,
                      width: 20,
                      child: const GlobalIndicator(),
                    );
                  }
                  return SizedBox.shrink();
                },
              ),
            ],
          ),
          Text('Current category is $oldCate', style: Style.gry12),
          const SizedBox(height: 5),
          StreamBuilder(
            stream: context.read<StateManagementProvider>().streamFetching(),
            builder: (context, snaps) {
              if (snaps.connectionState == ConnectionState.waiting) {
                return Center(child: const GlobalIndicator());
              } else if (!snaps.hasData || snaps.data!.docs.isEmpty) {
                return SizedBox.shrink();
              }
              final data = snaps.data?.docs;
              final p = context.read<StateManagementProvider>();
              return Expanded(
                child: ListView.builder(
                  itemCount: data.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Selector<StateManagementProvider, int>(
                        selector: (_, pro) => pro.categoryInd,
                        builder: (_, indx, _) {
                          final select = indx == -1;
                          return ElevatedButton(
                            onPressed: () {
                              p.changeCategoryInd(-1);
                              p.newCateName('Not Set');
                            },
                            style: stl(
                              select ? c.secondary : c.onSecondary,
                              select ? c.secondary : c.onPrimaryFixed,
                            ),
                            child: Row(
                              children: [
                                colorCon(c.onSurfaceVariant),
                                const SizedBox(width: 10),
                                Text(
                                  'No category',
                                  style: select ? Style.wht14 : Style.blc14,
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }
                    return Padding(
                      padding: const .symmetric(vertical: 4),
                      child: Selector<StateManagementProvider, int>(
                        selector: (_, pro) => pro.categoryInd,
                        builder: (_, indx, _) {
                          final indData = data[index - 1];
                          final cateName = indData['Category Name'];
                          final hasColor = indData.data().containsKey('color');
                          final color = hasColor
                              ? Color(indData['color'])
                              : c.primary;
                          final select = indx == index;
                          return ElevatedButton(
                            onPressed: () {
                              p.changeCategoryInd(index);
                              p.newCateName(cateName);
                            },
                            style: stl(
                              select ? c.secondary : c.onSecondary,
                              select ? c.secondary : c.onPrimaryFixed,
                            ),
                            child: Row(
                              children: [
                                colorCon(color),
                                const SizedBox(width: 10),
                                Text(
                                  cateName,
                                  style: select ? Style.wht14 : Style.blc14,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              );
            },
          ),
          const SizedBox(height: 5),
          ElevatedButton(
            onPressed: () async {
              final p = context.read<StateManagementProvider>();
              await p.changeTaskCategory(context, taskId, p.taskCategory);
            },
            style: ElevatedButton.styleFrom(
              fixedSize: Size(double.maxFinite, 50),
              backgroundColor: c.primary,
              shape: RoundedRectangleBorder(borderRadius: .circular(10)),
            ),
            child: const Text('Change', style: Style.blc14),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class CategoryRelatedSheet extends StatelessWidget {
  final String? id, oldName;
  final String title;
  final TextEditingController controller;
  final bool deletable;
  const CategoryRelatedSheet({
    super.key,
    this.id,
    this.oldName,
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
      padding: const .symmetric(horizontal: 16),
      height: sz.height * 0.45,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F3ED),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
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
                        await p.categoryDeletion(oldName!, id!, context);
                      },
                      icon: Icon(Icons.delete, color: c.error, size: 25),
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
            style: Style.gry13,
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
                        await p.editCategoryName(oldName!, id!, color, context);
                      } else {
                        if (!allowed) {
                          await p.categoryCreation(color, context);
                        }
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
    );
  }
}
