import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/services/provider_page.dart';
import 'package:to_do_app/services/global_items.dart';
import 'package:to_do_app/services/styles.dart';

// Making the Required FormState of our Form
Icon closingIcon = const Icon(Icons.close);

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
    final sz = MediaQuery.sizeOf(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          systemOverlayStyle: systemOverlay,
          scrolledUnderElevation: 0,
          toolbarHeight: sz.height * 0.06,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
          ),
          backgroundColor: Theme.of(context).colorScheme.onSecondary,
          title: const Text('Create Task', style: Style.black18),
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              FocusManager.instance.primaryFocus?.unfocus();
              Future.delayed(Duration(milliseconds: 200), () {
                // ignore: use_build_context_synchronously
                Navigator.of(context).pop();
              });
              context.read<StateManagementProvider>().disposingController();
            },
            padding: EdgeInsets.zero,
            icon: Icon(Icons.arrow_back, size: sz.height * 0.04),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              const SizedBox(height: 05),
              const _TitleField(),
              const SizedBox(height: 10),
              const _DescriptionField(),
              const Text('Add To', style: Style.black15),
              const _AddToButtons(),
              const Text('Add to My Categories', style: Style.black14),
              const _Categories(),
              const SizedBox(height: 05),
              Selector<StateManagementProvider, String>(
                selector: (_, pro) => pro.taskStatus,
                builder: (_, status, _) =>
                    Text('Selected Status: $status', style: Style.black11),
              ),
              Selector<StateManagementProvider, String>(
                selector: (_, pro) => pro.taskCategory,
                builder: (_, category, _) =>
                    Text('Selected Category: $category', style: Style.black11),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Completion Time', style: Style.black13),
                  ElevatedButton(
                    onPressed: () async {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        FocusManager.instance.primaryFocus?.unfocus();
                      });
                      final date = await showDatePicker(
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: ColorScheme.light(
                                primary: Colors.amber,
                              ),
                            ),
                            child: child!,
                          );
                        },
                        context: (context),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2030),
                      );
                      if (date != null) {
                        // ignore: use_build_context_synchronously
                        context
                            .read<StateManagementProvider>()
                            .settingTheCompletionDate(date);
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          FocusScope.of(context).unfocus();
                        });
                      }
                    },
                    style: savingElevatedButtonStyle(),
                    child: const Text('Select', style: Style.black13),
                  ),
                ],
              ),
              Selector<StateManagementProvider, String>(
                selector: (_, pro) => pro.formattedCompletionDate,
                builder: (_, date, _) =>
                    Text('Time Set: $date ', style: Style.black13),
              ),
              const Expanded(child: SizedBox.shrink()),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      final p = context.read<StateManagementProvider>();
                      p.cancelButtonAction();
                      FocusScope.of(context).unfocus();
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (context.mounted) Navigator.pop(context);
                      });
                    },
                    style: savingElevatedButtonStyle(),
                    child: const Text('Cancel', style: Style.black14),
                  ),
                  const SizedBox(width: 08),
                  Selector<StateManagementProvider, bool>(
                    selector: (_, pro) => pro.isSettingTask,
                    builder: (_, isTrue, _) {
                      if (isTrue) {
                        return SizedBox(
                          height: sz.height * 0.063,
                          width: sz.width * 0.35,
                          child: const GlobalIndicator(),
                        );
                      }
                      return ElevatedButton(
                        onPressed: () async {
                          final p = context.read<StateManagementProvider>();
                          p.taskCreationFunction(context);
                          await p.helperOfPendingCompletedLength();
                        },
                        style: savingElevatedButtonStyle(),
                        child: const Text('Save', style: Style.black14),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 04),
            ],
          ),
        ),
      ),
    );
  }

  ButtonStyle savingElevatedButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: Theme.of(context).colorScheme.onPrimaryFixed,
      overlayColor: const Color(0xFF000000),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      fixedSize: Size(
        MediaQuery.of(context).size.width * 0.35,
        MediaQuery.of(context).size.height * 0.063,
      ),
    );
  }
}

class _TitleField extends StatelessWidget {
  const _TitleField();

  @override
  Widget build(BuildContext cnt) {
    return TextField(
      controller: cnt.read<StateManagementProvider>().taskTitleCont,
      style: Style.black12,
      onChanged: (value) {
        final p = cnt.read<StateManagementProvider>();
        if (p.taskTitleCont!.text.trim().isNotEmpty) {
          // setState(() {
          //   closingIcon = Icon(Icons.close);
          // });
        }
      },
      decoration: InputDecoration(
        isDense: true,
        visualDensity: VisualDensity(vertical: -2),
        contentPadding: const EdgeInsets.symmetric(horizontal: 05, vertical: 0),
        labelText: 'Enter Title',
        labelStyle: Style.black12,
        hintText: 'e.g. complete assignment',
        hintStyle: Style.black12,
        focusedBorder: focusedBorder,
        enabledBorder: enabledBorder,
        suffixIcon:
            cnt
                .read<StateManagementProvider>()
                .taskTitleCont!
                .text
                .trim()
                .isNotEmpty
            ? GestureDetector(onTap: () {}, child: closingIcon)
            : SizedBox.shrink(),
      ),
    );
  }
}

class _DescriptionField extends StatelessWidget {
  const _DescriptionField();

  @override
  Widget build(BuildContext cnt) {
    return TextField(
      cursorRadius: Radius.circular(50),
      controller: cnt.read<StateManagementProvider>().descCont,
      style: Style.black12,
      minLines: 06,
      maxLines: 07,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 05,
          vertical: 04,
        ),
        labelStyle: Style.black12,
        hintText: 'Enter Description (Optional)',
        hintStyle: Style.black12,
        focusedBorder: focusedBorder,
        enabledBorder: enabledBorder,
      ),
    );
  }
}

class _AddToButtons extends StatefulWidget {
  const _AddToButtons();

  @override
  State<_AddToButtons> createState() => _AddToButtonsState();
}

class _AddToButtonsState extends State<_AddToButtons> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
          onPressed: () {
            FocusScope.of(context).unfocus();
            context.read<StateManagementProvider>().selectedTaskStatus(
              'Pending',
            );
          },
          style: taskStatusElevatedButtonStyle(
            Theme.of(context).colorScheme.primary,
          ),
          child: globalText('Pending', 14, FontWeight.w600),
        ),
        ElevatedButton(
          onPressed: () {
            FocusScope.of(context).unfocus();
            context.read<StateManagementProvider>().selectedTaskStatus(
              'Completed',
            );
          },
          style: taskStatusElevatedButtonStyle(
            Theme.of(context).colorScheme.secondary,
          ),
          child: const Text('Completed', style: Style.black14),
        ),
      ],
    );
  }

  ButtonStyle taskStatusElevatedButtonStyle(Color c) {
    return ElevatedButton.styleFrom(
      padding: EdgeInsets.all(0),
      backgroundColor: c,
      overlayColor: const Color(0xFF000000),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      fixedSize: Size(
        MediaQuery.of(context).size.width * 0.45,
        MediaQuery.of(context).size.height * 0.054,
      ),
    );
  }
}

class _Categories extends StatelessWidget {
  const _Categories();

  @override
  Widget build(BuildContext cnt) {
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
          height: sz.height * 0.05,
          width: sz.width * 1.0,
          child: Card(
            color: const Color(0x00000000),
            shadowColor: const Color(0x00000000),
            clipBehavior: .antiAlias,
            margin: const EdgeInsets.symmetric(horizontal: 0),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: data.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 03),
                  child: ElevatedButton(
                    onLongPress: () => context
                        .read<StateManagementProvider>()
                        .resetCategorySelected(),
                    onPressed: () async {
                      context
                          .read<StateManagementProvider>()
                          .selectedCategoryStatus(data[index]['Category Name']);
                    },
                    style: ElevatedButton.styleFrom(
                      overlayColor: const Color(0xFF000000),
                      side: BorderSide(
                        color: const Color(0xFF000000),
                        width: 1.5,
                      ),
                      backgroundColor: Theme.of(context).colorScheme.onPrimary,
                      shape: mainRadius,
                      fixedSize: Size(sz.width * 0.43, sz.height * 0.045),
                    ),
                    child: Text(
                      data[index]['Category Name'],
                      style: Style.black13,
                    ),
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
