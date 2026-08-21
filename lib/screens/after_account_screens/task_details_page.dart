import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/utils/global_items.dart';
import 'package:to_do_app/utils/provider_page.dart';
import 'package:to_do_app/utils/reusables.dart/field_borders.dart';
import 'package:to_do_app/utils/textStyles/styles.dart';

// ignore: must_be_immutable
class TaskDetailsPage extends StatefulWidget {
  final String taskId;
  final String title;
  final String description;
  final String date;
  final String category;
  final String completionDate;
  final String status;
  final String lastEdited;

  const TaskDetailsPage({
    super.key,
    required this.taskId,
    required this.title,
    required this.description,
    required this.date,
    required this.category,
    required this.completionDate,
    required this.status,
    required this.lastEdited,
  });

  @override
  State<TaskDetailsPage> createState() => _TaskDetailsPageState();
}

class _TaskDetailsPageState extends State<TaskDetailsPage> {
  @override
  void initState() {
    super.initState();
    context.read<StateManagementProvider>().makingComDateEmpty();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: PopScope(
          onPopInvokedWithResult: (didPop, result) {
            setState(() {
              context.read<StateManagementProvider>().formattedCompletionDate =
                  'Not Set';
            });
          },
          child: AnimatedSwitcher(
            duration: Duration(milliseconds: 400),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    _TopContainer(
                      title: widget.title,
                      category: widget.category,
                      desc: widget.description,
                      status: widget.status,
                    ),
                    const SizedBox(height: 5),
                    const Text('Description', style: Style.gry12),
                    const SizedBox(height: 5),
                    _DescriptionBox(description: widget.description),
                    const SizedBox(height: 10),
                    _DueDateButton(date: widget.completionDate),
                    const SizedBox(height: 5),
                    _TimeLineBox(
                      date: widget.date,
                      lastEdit: widget.lastEdited,
                    ),
                    const Expanded(child: SizedBox()),
                    _LastButtons(
                      taskId: widget.taskId,
                      comDate: widget.completionDate,
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
              // child: ListView(
              //   children: [
              //     widget.isPressed == true
              //         ? const SizedBox(height: 10)
              //         : SizedBox.shrink(),
              //     Row(
              //       mainAxisAlignment: .spaceBetween,
              //       children: [
              //         widget.isPressed == false
              //             ? const Text('Task Details', style: Style.black18)
              //             : const Text('Edit your Task', style: Style.black15),
              //         widget.isPressed == false
              //             ? IconButton(
              //                 onPressed: () {
              //                   setState(() {
              //                     widget.isPressed = true;
              //                   });
              //                   context
              //                       .read<StateManagementProvider>()
              //                       .puttingTextInTextFields(
              //                         widget.title,
              //                         widget.description,
              //                       );
              //                 },
              //                 padding: EdgeInsets.zero,
              //                 icon: Icon(
              //                   Icons.mode_edit_outline_outlined,
              //                   size: sz.height * 0.04,
              //                   color: const Color(0xFF000000),
              //                 ),
              //               )
              //             : SizedBox.shrink(),
              //       ],
              //     ),
              //     const SizedBox(height: 05),
              //     widget.isPressed == false
              //         ? _DetailsCard(
              //             title: widget.title,
              //             description: widget.description,
              //             date: widget.date,
              //             category: widget.category,
              //             completionDate: widget.completionDate,
              //           )
              //         :
              //     const SizedBox(height: 08),
              //     widget.isPressed == true
              //         ?
              //         : SizedBox.shrink(),
              //     const SizedBox(height: 05),
              //     widget.isPressed == true
              //         ? _EditDateSec(completionDate: widget.completionDate)
              //         : SizedBox.shrink(),
              //   ],
              // ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TopContainer extends StatelessWidget {
  final String title, category, desc, status;
  const _TopContainer({
    required this.title,
    required this.category,
    required this.desc,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    return Container(
      padding: const .symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: c.secondary,
        borderRadius: .circular(20),
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              IconButton(
                padding: .zero,
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(
                  Icons.keyboard_arrow_left,
                  color: c.onSecondary,
                  size: 40,
                ),
              ),
              Consumer<StateManagementProvider>(
                builder: (_, pro, _) {
                  if (!pro.editDetailsPage) {
                    return IconButton(
                      onPressed: () {
                        final p = context.read<StateManagementProvider>();
                        p.allowEditDetailsPg();
                        p.puttingTextInTextFields(title, desc);
                      },
                      padding: .zero,
                      icon: Icon(Icons.edit, color: c.onSecondary, size: 25),
                    );
                  }
                  if (pro.isSettingTask) {
                    return SizedBox(
                      height: 26,
                      width: 26,
                      child: Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 5,
                          color: c.onSecondary,
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Container(
                height: 28,
                padding: const .symmetric(vertical: 4, horizontal: 8),
                decoration: BoxDecoration(
                  color: c.primaryFixedDim,
                  borderRadius: .circular(10),
                ),
                child: Row(
                  mainAxisAlignment: .center,
                  children: [
                    Container(
                      height: 10,
                      width: 10,
                      decoration: BoxDecoration(
                        color: c.primary,
                        shape: .circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(category, style: Style.wht10),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Container(
                height: 28,
                padding: const .symmetric(vertical: 4, horizontal: 8),
                decoration: BoxDecoration(
                  color: c.primaryFixedDim,
                  borderRadius: .circular(10),
                ),
                child: Row(
                  mainAxisAlignment: .center,
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      color: status == 'Pending' ? c.primary : c.tertiary,
                      size: 20,
                    ),
                    const SizedBox(width: 5),
                    Text(status, style: Style.wht10),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Selector<StateManagementProvider, bool>(
            selector: (_, pro) => pro.editDetailsPage,
            builder: (_, allowed, _) {
              if (!allowed) {
                return Text(title, style: Style.wht18);
              }
              return TextField(
                style: Style.wht12,
                controller: context
                    .read<StateManagementProvider>()
                    .newTitleController,
                decoration: InputDecoration(
                  isDense: true,
                  visualDensity: const VisualDensity(vertical: 4),
                  hintText: 'Enter new title',
                  hintStyle: Style.wht12,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 05),
                  focusedBorder: focusB,
                  enabledBorder: enabledB,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _DescriptionBox extends StatelessWidget {
  final String description;
  const _DescriptionBox({required this.description});

  @override
  Widget build(BuildContext context) {
    final sz = MediaQuery.sizeOf(context);
    return Selector<StateManagementProvider, bool>(
      selector: (_, pro) => pro.editDetailsPage,
      builder: (_, allowed, _) {
        final p = context.read<StateManagementProvider>();
        if (!allowed) {
          return Container(
            width: double.maxFinite,
            padding: .all(6),
            clipBehavior: .antiAlias,
            height: sz.height * 0.2,
            decoration: BoxDecoration(
              color: const Color(0x00000000),
              borderRadius: .circular(15),
            ),
            child: Scrollbar(
              child: SingleChildScrollView(
                child: Text(description, style: Style.blc11),
              ),
            ),
          );
        }
        return TextField(
          minLines: 08,
          maxLines: 8,
          style: Style.blc11,
          controller: p.newDescritionController,
          decoration: InputDecoration(
            hintText: 'Enter New Description',
            hintStyle: Style.blc11,
            contentPadding: const EdgeInsets.all(08),
            focusedBorder: focusB,
            enabledBorder: enabledB,
          ),
        );
      },
    );
  }
}

class _DueDateButton extends StatelessWidget {
  final String date;
  const _DueDateButton({required this.date});

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    return Selector<StateManagementProvider, bool>(
      selector: (_, pro) => pro.editDetailsPage,
      builder: (_, allowed, _) {
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            side: BorderSide(color: allowed ? c.secondary : c.onPrimaryFixed),
            backgroundColor: c.onSecondary,
            shape: RoundedRectangleBorder(borderRadius: .circular(10)),
            disabledBackgroundColor: c.onSecondary,
            padding: const .symmetric(horizontal: 18, vertical: 15),
          ),
          onPressed: !allowed
              ? null
              : () async {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  });
                  final date = await showDatePicker(
                    context: (context),
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: ColorScheme.light(primary: c.primary),
                        ),
                        child: child!,
                      );
                    },
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2035),
                  );
                  if (date != null) {
                    // ignore: use_build_context_synchronously
                    context.read<StateManagementProvider>().assigningDate(date);
                  }
                },
          child: Row(
            children: [
              Icon(
                Icons.calendar_today_outlined,
                color: c.onSecondaryFixed,
                size: 25,
              ),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: .start,
                children: [
                  const Text('Due date', style: Style.gry10),
                  const SizedBox(height: 4),
                  Selector<StateManagementProvider, String>(
                    selector: (_, pro) => pro.taskCompletionDate,
                    builder: (context, comDate, child) {
                      if (comDate == '') {
                        return Text(
                          date != 'No completion date set'
                              ? date
                              : 'No date yet',
                          style: Style.blc11,
                        );
                      }
                      return Text('Change to: $comDate', style: Style.blc11);
                    },
                  ),
                ],
              ),
              const Expanded(child: SizedBox()),
              Icon(
                Icons.keyboard_arrow_right_outlined,
                color: c.onSurfaceVariant,
                size: 30,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TimeLineBox extends StatelessWidget {
  final String date;
  final String lastEdit;
  const _TimeLineBox({required this.date, required this.lastEdit});

  @override
  Widget build(BuildContext context) {
    return Selector<StateManagementProvider, bool>(
      selector: (_, pro) => pro.editDetailsPage,
      builder: (_, allowed, _) {
        if (!allowed) {
          return Column(
            crossAxisAlignment: .start,
            children: [
              const Text('Timeline', style: Style.gry12),
              Container(
                padding: const .symmetric(horizontal: 12, vertical: 6),
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    _TimeLineReused(title: 'Task created'),
                    Row(
                      children: [
                        SizedBox(height: 8, width: 8),
                        const SizedBox(width: 10),
                        Text(date, style: Style.gry10),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _TimeLineReused(title: 'Last edited'),
                    Row(
                      children: [
                        SizedBox(height: 8, width: 8),
                        const SizedBox(width: 10),
                        Text(lastEdit, style: Style.gry10),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        }
        return Column(
          children: [
            const SizedBox(height: 10),
            Container(
              padding: const .symmetric(horizontal: 15, vertical: 12),
              width: double.maxFinite,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF6EC),
                borderRadius: .circular(15),
                border: BoxBorder.all(color: const Color(0xFFF0D3A8)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    color: const Color(0xFF8A5A20),
                    size: 30,
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    maxLines: 2,
                    style: Style.deepOrg10,
                    'Tap Save to keep changes, or Cancel to \ndiscard them.',
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

// Making the Styling and the other Data for the Widgets
class _TimeLineReused extends StatelessWidget {
  final String title;
  const _TimeLineReused({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    return Row(
      children: [
        Container(
          height: 8,
          width: 8,
          decoration: BoxDecoration(color: c.onPrimary, shape: .circle),
        ),
        const SizedBox(width: 8),
        Text(title, style: Style.blc11),
      ],
    );
  }
}

class _LastButtons extends StatelessWidget {
  final String taskId;
  final String comDate;
  const _LastButtons({required this.taskId, required this.comDate});

  static ButtonStyle btnStl(Color bg, Color bor) {
    return ElevatedButton.styleFrom(
      backgroundColor: bg,
      elevation: 0,
      padding: const .symmetric(horizontal: 5, vertical: 15),
      shape: RoundedRectangleBorder(borderRadius: .circular(15)),
      side: BorderSide(color: bor, width: 1.5),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    return Selector<StateManagementProvider, bool>(
      selector: (_, pro) => pro.editDetailsPage,
      builder: (_, allowed, _) {
        final p = context.read<StateManagementProvider>();
        if (allowed) {
          return Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    p.disallowEditDetailsPg();
                    p.makingComDateEmpty();
                  },
                  style: btnStl(c.onSecondary, c.onPrimaryFixed),
                  child: const Text('Cancel', style: Style.blc11),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    await p.pushingUpdatedData(taskId, context, comDate);
                  },
                  style: btnStl(c.primary, c.primary),
                  child: const Text('Save changes', style: Style.blc11),
                ),
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
// ignore: must_be_immutable

class _EditDateSec extends StatelessWidget {
  final String completionDate;
  const _EditDateSec({required this.completionDate});

  @override
  Widget build(BuildContext context) {
    final sz = MediaQuery.sizeOf(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Change Completion Date:', style: Style.black11),
            ElevatedButton(
              onPressed: () async {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  FocusManager.instance.primaryFocus?.unfocus();
                });
                final date = await showDatePicker(
                  context: (context),
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: ColorScheme.light(primary: Colors.blue),
                      ),
                      child: child!,
                    );
                  },
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2035),
                );
                if (date != null) {
                  // ignore: use_build_context_synchronously
                  context.read<StateManagementProvider>().assigningDate(date);
                }
              },
              style: ElevatedButton.styleFrom(
                overlayColor: const Color(0xFF000000),
                fixedSize: Size(sz.width * 0.33, sz.height * 0.06),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                backgroundColor: Theme.of(context).colorScheme.onPrimaryFixed,
              ),
              child: const Text('Select', style: Style.black12),
            ),
          ],
        ),
        const SizedBox(height: 05),
        completionDate == 'No completion date set'
            ? const Text('Current Date: ...', style: Style.black11)
            : Text('Current Date: $completionDate', style: Style.black11),
        Selector<StateManagementProvider, String>(
          selector: (_, pro) => pro.taskCompletionDate,
          builder: (_, comDate, _) =>
              Text('Change to: $comDate', style: Style.black11),
        ),
      ],
    );
  }
}
