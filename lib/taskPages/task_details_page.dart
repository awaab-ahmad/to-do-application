import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/services/global_items.dart';
import 'package:to_do_app/services/provider_page.dart';

// ignore: must_be_immutable
class TaskDetailsPage extends StatefulWidget {
  final String taskId;
  final String title;
  final String description;
  final String date;
  final String category;
  String completionDate;
  bool isPressed;

  TaskDetailsPage({
    super.key,
    required this.taskId,
    required this.title,
    required this.description,
    required this.date,    
    required this.category,
    required this.completionDate,
    required this.isPressed,
  });

  @override
  State<TaskDetailsPage> createState() => _TaskDetailsPageState();
}

class _TaskDetailsPageState extends State<TaskDetailsPage> {
  @override
  void initState() {    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          systemOverlayStyle: systemOverlay,
          toolbarHeight: height * 0.06,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
          ),
          backgroundColor: Theme.of(context).colorScheme.onSecondary,
          title: widget.isPressed == false
              ? globalText(widget.title, 18, FontWeight.w600)
              : globalText('Make Changes', 18, FontWeight.w600),
          actions: [
            widget.isPressed == false
                ? const SizedBox(width: 60)
                : context.read<StateManagementProvider>().isSettingTask == true
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: SizedBox(
                      height: 25,
                      width: 25,
                      child: globalProgressIndicator(),
                    ),
                  )
                : IconButton(
                    onPressed: () async {
                      FocusScope.of(context).unfocus();                   
                      await context
                          .read<StateManagementProvider>()
                          .pushingUpdatedData(widget.taskId, context);
                      setState(() {
                        widget.isPressed = false;
                      });
                    },
                    icon: Icon(
                      Icons.check,
                      size: 35,
                      color: const Color(0xFF000000),
                    ),
                  ),
          ],
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              FocusScope.of(context).unfocus();
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (context.mounted) Navigator.pop(context);
              });
              setState(() {
                context
                        .read<StateManagementProvider>()
                        .formattedCompletionDate =
                    'Not Set';
              });
            },
            padding: EdgeInsets.zero,
            icon: Icon(Icons.arrow_back, size: height * 0.04),
          ),
        ),
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
              key: ValueKey(widget.isPressed),
              padding: const EdgeInsets.symmetric(horizontal: 08),
              child: ListView(
                children: [
                  widget.isPressed == true
                      ? const SizedBox(height: 10)
                      : SizedBox.shrink(),
                  Row(
                    mainAxisAlignment: .spaceBetween,
                    children: [
                      widget.isPressed == false
                          ? globalText('Task Details', 18, FontWeight.w600)
                          : globalText('Edit your Task', 16, FontWeight.w600),
                      widget.isPressed == false
                          ? IconButton(
                              onPressed: () {
                                setState(() {
                                  widget.isPressed = true;
                                });                            
                                context
                                    .read<StateManagementProvider>()
                                    .puttingTextInTextFields(
                                      widget.title,
                                      widget.description,
                                    );
                              },
                              padding: EdgeInsets.zero,
                              icon: Icon(
                                Icons.mode_edit_outline_outlined,
                                size: height * 0.04,
                                color: const Color(0xFF000000),
                              ),
                            )
                          : SizedBox.shrink(),
                    ],
                  ),
                  const SizedBox(height: 05),
                  widget.isPressed == false
                      ? SizedBox(
                          child: Card(
                            elevation: 0,
                            color: Theme.of(context).colorScheme.onPrimary,
                            clipBehavior: Clip.antiAlias,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 04),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 10),
                                  globalText('Title: ', 13, FontWeight.w600),
                                  globalText(widget.title, 11, FontWeight.w500),
                                  const SizedBox(height: 10),
                                  globalText(
                                    'Description:',
                                    13,
                                    FontWeight.w600,
                                  ),
                                  globalText(
                                    widget.description,
                                    11,
                                    FontWeight.w500,
                                  ),
                                  const SizedBox(height: 10),
                                  globalText(
                                    'Created On: ',
                                    13,
                                    FontWeight.w600,
                                  ),
                                  globalText(widget.date, 11, FontWeight.w500),
                                  const SizedBox(height: 10),
                                  globalText('Category:', 13, FontWeight.w600),
                                  globalText(
                                    widget.category,
                                    11,
                                    FontWeight.w500,
                                  ),
                                  const SizedBox(height: 10),
                                  globalText(
                                    'To Complete Before: ',
                                    13,
                                    FontWeight.w600,
                                  ),
                                  globalText(
                                    widget.completionDate,
                                    11,
                                    FontWeight.w500,
                                  ),
                                  const SizedBox(height: 10),
                                ],
                              ),
                            ),
                          ),
                        )
                      : TextField(
                          style: hintStyle,
                          controller: context
                              .read<StateManagementProvider>()
                              .newTitleController,
                          decoration: InputDecoration(
                            isDense: true,
                            visualDensity: const VisualDensity(vertical: 4),
                            hintText: 'Enter New Title',
                            hintStyle: hintStyle,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 05,
                            ),
                            focusedBorder: focusedBorder,
                            enabledBorder: enabledBorder,
                          ),
                        ),
                  const SizedBox(height: 08),
                  widget.isPressed == true
                      ? TextField(
                          minLines: 08,
                          maxLines: 10,
                          style: hintStyle,
                          controller: context
                              .read<StateManagementProvider>()
                              .newDescritionController,
                          decoration: InputDecoration(
                            hintText: 'Enter New Description',
                            hintStyle: hintStyle,
                            contentPadding: EdgeInsets.all(08),
                            focusedBorder: focusedBorder,
                            enabledBorder: enabledBorder,
                          ),
                        )
                      : SizedBox.shrink(),
                  const SizedBox(height: 05),
                  widget.isPressed == true
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                globalText(
                                  'Change Completion Date:',
                                  11,
                                  FontWeight.w600,
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    WidgetsBinding.instance.addPostFrameCallback((_){
                                      FocusManager.instance.primaryFocus?.unfocus();
                                    });
                                    final date = await showDatePicker(
                                      context: (context),
                                      builder: (context, child) {
                                        return Theme(
                                          data: Theme.of(context).copyWith(
                                            colorScheme: ColorScheme.light(
                                              primary: Colors.blue,
                                            ),
                                          ),
                                          child: child!,
                                        );
                                      },
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime(2035),
                                    );
                                    if (date != null) {
                                      // ignore: use_build_context_synchronously
                                      context
                                          .read<StateManagementProvider>()
                                          .assigningDate(date);
                                    }                                    
                                  },
                                  style: ElevatedButton.styleFrom(
                                    overlayColor: const Color(0xFF000000),
                                    fixedSize: Size(
                                      MediaQuery.of(context).size.width * 0.33,
                                      height * 0.06,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    backgroundColor: Theme.of(
                                      context,
                                    ).colorScheme.onPrimaryFixed,
                                  ),
                                  child: globalText(
                                    'Select',
                                    12,
                                    FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 05),
                            widget.completionDate == 'No completion date set'
                                ? globalText(
                                    'Current Date: ...',
                                    11,
                                    FontWeight.w600,
                                  )
                                : globalText(
                                    'Current Date: ${widget.completionDate}',
                                    11,
                                    FontWeight.w600,
                                  ),
                            globalText(
                              'Change to: ${context.watch<StateManagementProvider>().taskCompletionDate}',
                              11,
                              FontWeight.w600,
                            ),
                          ],
                        )
                      : SizedBox.shrink(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Making the Styling and the other Data for the Widgets
final focusedBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(15),
  borderSide: BorderSide(color: const Color(0xFFFFD83B), width: 2.0),
);
final enabledBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(15),
  borderSide: BorderSide(color: const Color(0xFF000000), width: 1.5),
);

TextStyle hintStyle = GoogleFonts.poppins(
  color: const Color(0xFF000000),
  fontSize: 13,
  fontWeight: FontWeight.w600,
);
