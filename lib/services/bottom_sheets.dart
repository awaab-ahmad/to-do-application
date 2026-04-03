import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/services/global_items.dart';
import 'package:to_do_app/services/provider_page.dart';
import 'package:to_do_app/services/snack_bar.dart';

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
          globalText('Select Image', 20, FontWeight.w600),
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
              focusedBorder: focusedBorders,
              enabledBorder: enabledBorder,
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
                child: globalText('Cancel', 13, FontWeight.w600),
              ),
              const SizedBox(width: 08),
              context.watch<StateManagementProvider>().isSettingTask == true
                  ? SizedBox(
                      height: h * 0.05,
                      width: w * 0.33,
                      child: Center(child: globalProgressIndicator()),
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
                      child: globalText('Change', 13, FontWeight.w600),
                    ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    ),
  );
}

// This bottom sheet is used for Creating our own category
Container categoryCreatingBottomSheet(
  double w,
  double h,
  BuildContext context,
  TextEditingController controller,
  Future<void> Function() func,
) {
  final buttonStyle = ElevatedButton.styleFrom(
    overlayColor: const Color(0xff000000),
    shape: mainRadius,
    padding: const EdgeInsets.symmetric(vertical: 05),
    backgroundColor: const Color(0xFFFFB74D),
    fixedSize: Size(w * 0.3, h * 0.06),
  );
  return Container(
    height: h * 0.23,
    width: w * 1.0,
    decoration: BoxDecoration(
      color: const Color(0xFFFFF9F0),
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: .center,
        children: [
          const SizedBox(height: 05),
          SizedBox(
            height: 15,
            width: 70,
            child: Card(color: const Color(0xFF000000)),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: controller,
            autofocus: true,
            cursorColor: const Color(0xFF000000),
            style: styleOnly(Colors.black, 12, FontWeight.w600),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                vertical: 02,
                horizontal: 08,
              ),
              focusedBorder: focusedBorders,
              enabledBorder: enabledBorder,
              hintText: 'Enter Category Name',
              hintStyle: styleOnly(Colors.black, 12, FontWeight.w600),
            ),
          ),
          const Expanded(child: SizedBox()),
          Row(
            mainAxisAlignment: .end,
            children: [
              ElevatedButton(
                style: buttonStyle,
                onPressed: () {
                  controller.clear();
                  Navigator.of(context).pop();
                },
                child: globalText('Cancel', 13, FontWeight.w600),
              ),
              const SizedBox(width: 10),
              context.watch<StateManagementProvider>().isSettingTask == true
                  ? SizedBox(
                      height: h * 0.06,
                      width: w * 0.3,
                      child: Center(child: globalProgressIndicator()),
                    )
                  : ElevatedButton(
                      style: buttonStyle,
                      onPressed: () async {
                        await func();
                        controller.clear();
                        if (!context.mounted) return;
                        Navigator.of(context).pop();
                      },
                      child: globalText('Create', 13, FontWeight.w600),
                    ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    ),
  );
}

// This below bottom sheet for moving tasks from one section to others
Container movingTasksFromOneToOtherSheet(
  BuildContext context,
  Stream? streamData,
  String taskId,
  double w,
  double h,
) {
  final buttonStyleForLastButtons = ElevatedButton.styleFrom(
    overlayColor: const Color(0xff000000),
    padding: const EdgeInsets.symmetric(vertical: 08),
    shape: mainRadius,
    backgroundColor: const Color(0xFFFFB74D),
    fixedSize: Size(w * 0.35, h * 0.06),
  );
  ButtonStyle buttonStyle(Color c) {
    return ElevatedButton.styleFrom(
      overlayColor: const Color(0xFF000000),
      padding: const EdgeInsets.all(0),
      shape: mainRadius,
      backgroundColor: c,
      fixedSize: Size(w * 0.43, h * 0.05),
    );
  }

  return Container(
    clipBehavior: .antiAlias,
    height: h * 0.48,
    width: w * 1.0,
    decoration: BoxDecoration(
      color: const Color(0xFFFFF9F0),
      borderRadius: BorderRadius.circular(25),
    ),
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 08),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          const SizedBox(height: 05),
          Center(
            child: SizedBox(
              height: 15,
              width: 70,
              child: Card(color: const Color(0xFF000000)),
            ),
          ),
          const SizedBox(height: 05),
          globalText('Move your task to', 14, FontWeight.w600),
          Row(
            mainAxisAlignment: .center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  context.read<StateManagementProvider>().movingToWhichStatus(
                    'Pending',
                  );
                },
                style: buttonStyle(const Color(0xFF4FC3F7)),
                child: globalText('Pending', 12, FontWeight.w600),
              ),
              const SizedBox(width: 05),
              ElevatedButton(
                onPressed: () async {
                  context.read<StateManagementProvider>().movingToWhichStatus(
                    'Completed',
                  );
                },
                style: buttonStyle(const Color(0xFF81C784)),
                child: globalText('Completed', 12, FontWeight.w600),
              ),
            ],
          ),
          globalText('My Categories', 14, FontWeight.w600),
          Expanded(
            child: StreamBuilder(
              stream: streamData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: globalProgressIndicator());
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: globalText(
                      'No User Categories found',
                      10,
                      FontWeight.w600,
                    ),
                  );
                }
                final data = snapshot.data!.docs;
                return GridView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 02, vertical: 0),
                  itemCount: data.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 3.2,
                  ),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 04,
                        horizontal: 04,
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: mainRadius,
                          overlayColor: const Color(0xFF000000),
                          backgroundColor: const Color(0xFFFFE3D2),
                          side: BorderSide(
                            color: const Color(0xff000000),
                            width: 1.2,
                          ),
                        ),
                        onPressed: () async {
                          context
                              .read<StateManagementProvider>()
                              .movingToWhichCategory(
                                index,
                                data[index]['Category Name'],
                              );
                        },
                        child: globalText(
                          data[index]['Category Name'],
                          14,
                          FontWeight.w600,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          globalText(
            'Moving To: ${context.watch<StateManagementProvider>().movingTo}',
            11,
            FontWeight.w600,
          ),
          globalText(
            'Category: ${context.watch<StateManagementProvider>().category}',
            11,
            FontWeight.w600,
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: .end,
            children: [
              ElevatedButton(
                style: buttonStyleForLastButtons,
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: globalText('Cancel', 12, FontWeight.w600),
              ),
              const SizedBox(width: 08),
              context.read<StateManagementProvider>().isSettingTask == true
                  ? SizedBox(
                      height: h * 0.06,
                      width: w * 0.35,
                      child: Center(child: globalProgressIndicator()),
                    )
                  : ElevatedButton(
                      style: buttonStyleForLastButtons,
                      onPressed: () async {
                        await context
                            .read<StateManagementProvider>()
                            .taskMovingBetweenLists(taskId);
                        if (!context.mounted) return;
                        Navigator.of(context).pop();
                        await context
                            .read<StateManagementProvider>()
                            .helperOfPendingCompletedLength();
                      },
                      child: globalText('Move', 12, FontWeight.w600),
                    ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    ),
  );
}
