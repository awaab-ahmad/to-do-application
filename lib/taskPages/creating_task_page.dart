import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/services/provider_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:to_do_app/services/global_items.dart';

// Making the Required FormState of our Form
Icon closingIcon = Icon(Icons.close);

class TaskCreationPage extends StatefulWidget {
  const TaskCreationPage({super.key});

  @override
  State<TaskCreationPage> createState() => _TaskCreationPageState();
}

class _TaskCreationPageState extends State<TaskCreationPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  Stream? myCategoriesStream;

  @override
  void initState() {
    super.initState();
    myCategoriesStream = myCategoriesStream = context
        .read<StateManagementProvider>()
        .firestore
        .collection('Users')
        .doc(context.read<StateManagementProvider>().auth.currentUser!.uid)
        .collection('Categories')
        .snapshots();
    context.read<StateManagementProvider>().creatingTaskOpeningFunc();
    titleController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          systemOverlayStyle: systemOverlay,
          scrolledUnderElevation: 0,
          toolbarHeight: height * 0.06,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
          ),
          backgroundColor: Theme.of(context).colorScheme.onSecondary,
          title: globalText('Create Task', 18, FontWeight.w600),
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              context.read<StateManagementProvider>().cancelButtonAction(
                titleController,
                descriptionController,
              );
              FocusScope.of(context).unfocus();
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (context.mounted) Navigator.pop(context);
              });
            },
            padding: EdgeInsets.zero,
            icon: Icon(Icons.arrow_back, size: height * 0.04),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              const SizedBox(height: 05),
              TextField(
                controller: titleController,
                style: style,
                onChanged: (value) {
                  if (titleController.text.trim().isNotEmpty) {
                    setState(() {
                      closingIcon = Icon(Icons.close);
                    });
                  }
                },
                decoration: InputDecoration(
                  isDense: true,
                  visualDensity: VisualDensity(vertical: -2),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 05,
                    vertical: 0,
                  ),
                  labelText: 'Enter Title',
                  labelStyle: style,
                  hintText: 'e.g. complete assignment',
                  hintStyle: style,
                  focusedBorder: focusedBorder,
                  enabledBorder: enabledBorder,
                  suffixIcon: titleController.text.trim().isNotEmpty
                      ? GestureDetector(
                          onTap: () => titleController.clear(),
                          child: closingIcon,
                        )
                      : SizedBox.shrink(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                cursorRadius: Radius.circular(50),
                controller: descriptionController,
                style: style,
                minLines: 06,
                maxLines: 07,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 05,
                    vertical: 04,
                  ),
                  labelStyle: style,
                  hintText: 'Enter Description (Optional)',
                  hintStyle: style,
                  focusedBorder: focusedBorder,
                  enabledBorder: enabledBorder,
                ),
              ),
              globalText('Add To', 17, FontWeight.w600),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      context
                          .read<StateManagementProvider>()
                          .selectedTaskStatus('Pending');
                    },
                    style: taskStatusElevatedButtonStyle(
                      Theme.of(context).colorScheme.primary,
                    ),
                    child: globalText('Pending', 14, FontWeight.w600),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      context
                          .read<StateManagementProvider>()
                          .selectedTaskStatus('Completed');
                    },
                    style: taskStatusElevatedButtonStyle(
                      Theme.of(context).colorScheme.secondary,
                    ),
                    child: globalText('Completed', 14, FontWeight.w600),
                  ),
                ],
              ),
              globalText('Add to My Categories', 14, FontWeight.w600),
              StreamBuilder(
                stream: myCategoriesStream,
                builder: (context, snaps) {
                  if (snaps.connectionState == ConnectionState.waiting) {
                    return Center(child: globalProgressIndicator());
                  } else if (!snaps.hasData || snaps.data!.docs.isEmpty) {
                    return SizedBox.shrink();
                  }
                  final data = snaps.data!.docs;
                  return SizedBox(
                    height: height * 0.05,
                    width: width * 1.0,
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
                                    .selectedCategoryStatus(
                                      data[index]['Category Name'],
                                    );
                              },
                              style: ElevatedButton.styleFrom(
                                overlayColor: const Color(0xFF000000),
                                side: BorderSide(
                                  color: const Color(0xFF000000),
                                  width: 1.5,
                                ),
                                backgroundColor: Theme.of(
                                  context,
                                ).colorScheme.onPrimary,
                                shape: mainRadius,
                                fixedSize: Size(width * 0.43, height * 0.045),
                              ),
                              child: globalText(
                                data[index]['Category Name'],
                                13,
                                FontWeight.w600,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 05),
              globalText(
                'Selected Status: ${context.watch<StateManagementProvider>().taskStatus}',
                12,
                FontWeight.w600,
              ),
              globalText(
                'Selected Category: ${context.watch<StateManagementProvider>().taskCategory}',
                12,
                FontWeight.w600,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  globalText('Completion Time', 13, FontWeight.w600),
                  ElevatedButton(
                    onPressed: () async {
                      WidgetsBinding.instance.addPostFrameCallback((_){
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
                    style: timeButtonStyle(),
                    child: globalText('Select', 12, FontWeight.w600),
                  ),
                ],
              ),
              globalText(
                'Time Set: ${context.read<StateManagementProvider>().formattedCompletionDate} ',
                12,
                FontWeight.w600,
              ),
              const Expanded(child: SizedBox.shrink()),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      context
                          .read<StateManagementProvider>()
                          .cancelButtonAction(
                            titleController,
                            descriptionController,
                          );
                      FocusScope.of(context).unfocus();
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (context.mounted) Navigator.pop(context);
                      });
                    },
                    style: savingElevatedButtonStyle(
                      Theme.of(context).colorScheme.onPrimaryFixed,
                    ),
                    child: globalText('Cancel', 15, FontWeight.w600),
                  ),
                  const SizedBox(width: 08),
                  context.read<StateManagementProvider>().isSettingTask == true
                      ? SizedBox(
                          height: height * 0.063,
                          width: width * 0.35,
                          child: Center(child: globalProgressIndicator()),
                        )
                      : ElevatedButton(
                          onPressed: () async {
                            final p = context.read<StateManagementProvider>();
                            p.taskCreationFunction(
                              titleController,
                              descriptionController,
                              context,
                            );
                            await p.helperOfPendingCompletedLength();
                          },
                          style: savingElevatedButtonStyle(
                            Theme.of(context).colorScheme.onPrimaryFixed,
                          ),
                          child: globalText('Save', 15, FontWeight.w600),
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

  // Making the Focused and the Enabled Border
  late final focusedBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(15),
    borderSide: BorderSide(color: const Color(0xFFFFD83B), width: 1.2),
  );
  late final enabledBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(15),
    borderSide: BorderSide(color: const Color(0xFF000000), width: 1.2),
  );

  final style = GoogleFonts.poppins(
    color: const Color(0xFF000000),
    fontSize: 12,
    fontWeight: FontWeight.w600,
  );

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

  ButtonStyle savingElevatedButtonStyle(Color c) {
    return ElevatedButton.styleFrom(
      backgroundColor: c,
      overlayColor: const Color(0xFF000000),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      fixedSize: Size(
        MediaQuery.of(context).size.width * 0.35,
        MediaQuery.of(context).size.height * 0.063,
      ),
    );
  }

  ButtonStyle timeButtonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: Theme.of(context).colorScheme.onPrimaryFixed,
      overlayColor: Colors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      padding: EdgeInsets.symmetric(horizontal: 05, vertical: 05),
      fixedSize: Size(
        MediaQuery.of(context).size.width * 0.34,
        MediaQuery.of(context).size.height * 0.05,
      ),
    );
  }
}
