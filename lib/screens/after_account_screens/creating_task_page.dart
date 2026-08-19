import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/utils/provider_page.dart';
import 'package:to_do_app/utils/global_items.dart';
import 'package:to_do_app/utils/reusables.dart/after_acc_topbar.dart';
import 'package:to_do_app/utils/reusables.dart/field_borders.dart';
import 'package:to_do_app/utils/textStyles/styles.dart';

class TaskCreationPage extends StatefulWidget {
  const TaskCreationPage({super.key});

  @override
  State<TaskCreationPage> createState() => _TaskCreationPageState();
}

class _TaskCreationPageState extends State<TaskCreationPage> {
  @override
  void initState() {
    super.initState();
    final p = context.read<StateManagementProvider>();
    p.creatingTaskOpeningFunc();
    p.settingControllers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: .start,
            children: [
              AfterAccTopBar(
                title: 'New Task',
                subTitle: 'Create a new task',
                extra: () {
                  context.read<StateManagementProvider>().disposingController();
                },
              ),
              const SizedBox(height: 10),
              const Text('Title', style: Style.gry14),
              const SizedBox(height: 5),
              const _TitleField(),
              const SizedBox(height: 5),
              const Text('Description', style: Style.gry14),
              const SizedBox(height: 5),
              const _DescriptionField(),
              const SizedBox(height: 5),
              const Text('Add To', style: Style.gry14),
              const SizedBox(height: 5),
              const _AddToButtons(),
              const SizedBox(height: 5),
              const Text('Category', style: Style.gry14),
              const SizedBox(height: 5),
              const _Categories(),
              const SizedBox(height: 05),
              const Text('Completion Date', style: Style.gry14),
              const SizedBox(height: 05),
              const _CompletionDateBtn(),
              const Expanded(child: SizedBox.shrink()),
              const _AddTaskBtn(),
                  //  p.cancelButtonAction();
              const SizedBox(height: 04),
            ],
          ),
        ),
      ),
    );
  }
}

class _TitleField extends StatelessWidget {
  const _TitleField();

  @override
  Widget build(BuildContext cnt) {
    final c = Theme.of(cnt).colorScheme;
    return TextField(
      controller: cnt.read<StateManagementProvider>().taskTitleCont,
      style: Style.gry13,
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: c.onSecondary,
        visualDensity: VisualDensity(vertical: 4),
        contentPadding: const EdgeInsets.symmetric(horizontal: 05, vertical: 2),
        hintText: 'e.g. First project proposal',
        hintStyle: Style.mutedGry13,
        focusedBorder: focusB,
        enabledBorder: enabledB,
      ),
    );
  }
}

class _DescriptionField extends StatelessWidget {
  const _DescriptionField();

  @override
  Widget build(BuildContext cnt) {
    final c = Theme.of(cnt).colorScheme;
    return TextField(
      cursorRadius: Radius.circular(50),
      controller: cnt.read<StateManagementProvider>().descCont,
      style: Style.gry13,
      minLines: 06,
      maxLines: 06,
      decoration: InputDecoration(
        filled: true,
        fillColor: c.onSecondary,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 05,
          vertical: 04,
        ),
        hintText: 'Add any notes or details for this task...',
        hintStyle: Style.mutedGry13,
        focusedBorder: focusB,
        enabledBorder: enabledB,
      ),
    );
  }
}

class _AddToButtons extends StatelessWidget {
  const _AddToButtons();

  static const List<String> tasksType = ['Pending', 'Completed'];
  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    final sz = MediaQuery.sizeOf(context);
    return SizedBox(
      width: double.maxFinite,
      height: sz.height * 0.06,
      child: ListView.builder(
        scrollDirection: .horizontal,
        itemCount: tasksType.length,
        itemBuilder: (context, index) {
          final p = context.read<StateManagementProvider>();
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Selector<StateManagementProvider, int>(
              selector: (_, pro) => pro.indChange,
              builder: (context, ind, child) {
                final selected = ind == index;
                return ElevatedButton(
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    p.changeInd(index);
                    p.selectedTaskStatus(tasksType[index]);
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    fixedSize: Size(sz.width * 0.43, 60),
                    side: BorderSide(
                      color: selected ? c.secondary : c.onPrimaryFixed,
                    ),
                    backgroundColor: selected ? c.secondary : c.onSecondary,
                  ),
                  child: Text(
                    tasksType[index],
                    style: selected ? Style.wht14 : Style.blc14,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _Categories extends StatelessWidget {
  const _Categories();

  @override
  Widget build(BuildContext cnt) {
    final c = Theme.of(cnt).colorScheme;
    final sz = MediaQuery.sizeOf(cnt);
    return StreamBuilder(
      stream: cnt.read<StateManagementProvider>().streamFetching(),
      builder: (context, snaps) {
        if (snaps.connectionState == ConnectionState.waiting) {
          return Center(child: const GlobalIndicator());
        } else if (!snaps.hasData || snaps.data!.docs.isEmpty) {
          return SizedBox.shrink();
        }
        final data = snaps.data!.docs;
        return SizedBox(
          height: sz.height * 0.055,
          width: double.maxFinite,
          child: Card(
            color: const Color(0x00000000),
            shadowColor: const Color(0x00000000),
            clipBehavior: .antiAlias,
            margin: const EdgeInsets.symmetric(horizontal: 0),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: data.length,
              itemBuilder: (context, index) {
                final indData = data[index];
                final hasColor = indData.data().containsKey('color');
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 03),
                  child: Selector<StateManagementProvider, int>(
                    selector: (_, p) => p.categoryInd,
                    builder: (context, cateInd, child) {
                      final selected = cateInd == index;
                      final pro = context.read<StateManagementProvider>();
                      return ElevatedButton(
                        onLongPress: () => pro.resetCategorySelected(),
                        onPressed: () async {
                          pro.changeCategoryInd(index);
                          pro.selectedCategoryStatus(indData['Category Name']);
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          side: BorderSide(
                            color: selected ? c.secondary : c.onPrimaryFixed,
                            width: 1.5,
                          ),
                          backgroundColor: selected
                              ? c.secondary
                              : c.onSecondary,
                          shape: mainRadius,
                        ),
                        child: Row(
                          children: [
                            Container(
                              height: 10,
                              width: 10,
                              decoration: BoxDecoration(
                                shape: .circle,
                                color: hasColor ? c.tertiaryFixed : c.primary,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              data[index]['Category Name'],
                              style: selected ? Style.wht14 : Style.blc14,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class _CompletionDateBtn extends StatelessWidget {
  const _CompletionDateBtn();

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    return ElevatedButton(
      onPressed: () async {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          FocusManager.instance.primaryFocus?.unfocus();
        });
        final date = await showDatePicker(
          builder: (context, child) {
            return Theme(
              data: Theme.of(
                context,
              ).copyWith(colorScheme: ColorScheme.light(primary: Colors.amber)),
              child: child!,
            );
          },
          context: (context),
          firstDate: DateTime.now(),
          lastDate: DateTime(2030),
        );
        if (date != null) {
          // ignore: use_build_context_synchronously
          context.read<StateManagementProvider>().settingTheCompletionDate(
            date,
          );
          WidgetsBinding.instance.addPostFrameCallback((_) {
            FocusScope.of(context).unfocus();
          });
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: c.onSecondary,
        padding: const .symmetric(vertical: 12, horizontal: 12),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: .circular(15)),
        side: BorderSide(color: c.onPrimaryFixed, width: 1.6),
      ),
      child: Row(
        children: [
          Icon(
            size: 25,
            Icons.calendar_today_outlined,
            color: c.onSecondaryFixed,
          ),
          const SizedBox(width: 10),
          Selector<StateManagementProvider, String>(
            selector: (_, pro) => pro.formattedCompletionDate,
            builder: (_, date, _) => Text(
              date != 'Not Set' ? date : 'Select date (optional)',
              style: Style.blc13,
            ),
          ),
          const Expanded(child: SizedBox()),
          Icon(
            Icons.keyboard_arrow_right_outlined,
            color: c.onSurface,
            size: 25,
          ),
        ],
      ),
    );
  }
}

class _AddTaskBtn extends StatelessWidget {
  const _AddTaskBtn();

  @override
  Widget build(BuildContext context) {
    final c = Theme.of(context).colorScheme;
    return Selector<StateManagementProvider, bool>(
      selector: (_, pro) => pro.isSettingTask,
      builder: (_, isTrue, _) {
        if (isTrue) {
          return const GlobalIndicator();
        }
        return ElevatedButton(
          onPressed: () async {
            final p = context.read<StateManagementProvider>();
            p.taskCreationFunction(context);
            await p.helperOfPendingCompletedLength();
          },
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: .circular(15)),
            backgroundColor: c.primary, fixedSize: Size(double.maxFinite, 50)),
          child: const Text('Add task', style: Style.blc14),
        );
      },
    );
  }
}
