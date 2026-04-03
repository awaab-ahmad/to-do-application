import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_app/services/snack_bar.dart';
import 'package:to_do_app/taskPages/front_page.dart';
import 'package:to_do_app/taskPages/login.dart';

// Making the Class for the StateManagement

class StateManagementProvider extends ChangeNotifier {
  bool isSettingTask = false;
  DateTime completionDate = DateTime.now();
  String formattedCompletionDate = 'Not Set';
  String taskStatus = 'Not Set';
  String taskCategory = 'Not Set';
  String movingTo = 'Not Set';
  String category = 'Not Set';
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  int pendingTasks = 0;
  int completedTasks = 0;
  TextEditingController newTitleController = TextEditingController();
  TextEditingController newDescritionController = TextEditingController();
  String taskCompletionDate = '';
  TextEditingController loginEmail = TextEditingController();
  TextEditingController loginPassword = TextEditingController();
  TextEditingController signUpUserName = TextEditingController();
  TextEditingController signUpEmail = TextEditingController();
  TextEditingController signUpPassword = TextEditingController();

  Future<void> signUpFunction(BuildContext context) async {
    final bar = ScaffoldMessenger.of(context);
    try {
      isSettingTask = true;
      notifyListeners();
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: signUpEmail.text.trim(),
        password: signUpPassword.text.trim(),
      );
      await FirebaseAuth.instance.currentUser!.updateDisplayName(
        signUpUserName.text.trim(),
      );
      // now making the setup for storing the userName in the database
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({
            'User Name': signUpUserName.text.trim(),
            'User Email': signUpEmail.text.trim(),
          });
      if (!context.mounted) return;
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
      if (kDebugMode) print('User Created Successfully');
      if (kDebugMode) {
        print(
          'User details are: ${FirebaseAuth.instance.currentUser!.email}, ${FirebaseAuth.instance.currentUser!.displayName}',
        );
        bar.showSnackBar(globalBar('Login To Continue'));
      }
      isSettingTask = false;
    } on FirebaseAuthException catch (e) {
      isSettingTask = false;
      if (kDebugMode) print(e.code);
      switch (e.code) {
        case 'invalid-email':
          bar.showSnackBar(globalBar('Please enter valid email'));
          break;
        case 'weak-password':
          bar.showSnackBar(globalBar('Password must be strong'));
          break;
        case 'network-request-failed':
          bar.showSnackBar(globalBar('Server busy, try again later'));
          break;
        case 'email-already-in-use':
          bar.showSnackBar(globalBar('Email already used'));
          break;
        default:
          bar.showSnackBar(globalBar('Error, Try again later'));
      }
    }
    textEditingControllersCleaner();
    notifyListeners();
  }

  Future<void> loginFunction(BuildContext context) async {
    final bar = ScaffoldMessenger.of(context);
    try {
      isSettingTask = true;
      notifyListeners();
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: loginEmail.text.trim(),
        password: loginPassword.text.trim(),
      );
      // if (kDebugMode) print('Login Successful');
      bar.showSnackBar(globalBar('Logged in: ${auth.currentUser!.email}'));
      if (!context.mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => FrontPage()),
        (Route<dynamic> route) => false,
      );
      isSettingTask = false;
    } on FirebaseAuthException catch (e) {
      isSettingTask = false;
      if (kDebugMode) print(e.code);
      switch (e.code) {
        case 'invalid-credential':
          bar.showSnackBar(globalBar('Wrong Email or password'));
          break;
        case 'network-request-failed':
          bar.showSnackBar(globalBar('Network error'));
          break;
        case 'invalid-email':
          bar.showSnackBar(globalBar('Enter a valid email'));
          break;
      }
    }
    textEditingControllersCleaner();
    notifyListeners();
  }

  void textEditingControllersCleaner() {
    signUpUserName.clear();
    signUpEmail.clear();
    signUpPassword.clear();

    loginEmail.clear();
    loginPassword.clear();
  }

  void movingToANDcategoryCleaner() {
    movingTo = 'Not Set';
    category = 'Not Set';
  }

  void movingToWhichStatus(String value) {
    movingTo = value;
    notifyListeners();
  }

  void movingToWhichCategory(int index, String value) {
    category = value;
    notifyListeners();
  }

  void cancelButtonAction(
    TextEditingController titleController,
    TextEditingController descriptionController,
  ) {
    titleController.clear();
    descriptionController.clear();
    notifyListeners();
  }

  void creatingTaskOpeningFunc() {
    taskCategory = 'Not Set';
    taskStatus = 'Not Set';
  }

  // Continueing the New Phase of bringing the Firebase
  void selectedTaskStatus(String statusName) {
    taskStatus = statusName;
    notifyListeners();
  }

  void selectedCategoryStatus(String categoryName) {
    taskCategory = categoryName;
    notifyListeners();
  }

  void resetCategorySelected() {
    taskCategory = 'Not Set';
    notifyListeners();
  }

  void settingTheCompletionDate(DateTime dt) {
    completionDate = dt;
    formattedCompletionDate = DateFormat('MMMM dd, yyy').format(completionDate);
    notifyListeners();
  }

  Future<void> taskCreationFunction(
    TextEditingController title,
    TextEditingController desc,
    BuildContext context,
  ) async {
    final bar = ScaffoldMessenger.of(context);
    try {
      if (title.text.trim().isNotEmpty) {
        if (taskStatus != 'Not Set') {
          isSettingTask = true;
          notifyListeners();
          final now = DateTime.now();
          String exactDate = DateFormat('MMMM dd, yyy').format(now);
          await FirebaseFirestore.instance
              .collection('Users')
              .doc(auth.currentUser!.uid)
              .collection('Tasks')
              .doc()
              .set({
                'Task Status': taskStatus,
                'Category Name': taskCategory,
                'Task Title': title.text.trim(),
                'Task Description': (desc.text.trim().isEmpty)
                    ? 'No description Provided'
                    : desc.text.trim(),
                'Dated on': exactDate,
                'Completion Date': (formattedCompletionDate == 'Not Set')
                    ? 'No completion date set'
                    : formattedCompletionDate,
              })
              .timeout(Duration(seconds: 10));
          if (!context.mounted) return;
          bar.showSnackBar(globalBar('Task Created'));
          if (!context.mounted) return;
          Navigator.of(context).pop();
          title.clear();
          desc.clear();
          isSettingTask = false;
        } else {
          isSettingTask = false;
          if (kDebugMode) print('Task Status is not set Properly');
        }
      } else {
        if (kDebugMode) print('The Title is Empty');
        bar
          ..removeCurrentSnackBar()
          ..showSnackBar(globalBar('Title cannot be empty'));
      }
    } catch (e) {
      isSettingTask = false;
      if (kDebugMode) print(e);
    }
    notifyListeners();
  }

  // Making the function for the creation of the Category
  Future<void> categoryCreation(TextEditingController categoryName) async {
    try {
      if (categoryName.text.isNotEmpty && categoryName.text.length <= 11) {
        isSettingTask = true;
        notifyListeners();
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(auth.currentUser!.uid)
            .collection('Categories')
            .doc()
            .set({"Category Name": categoryName.text.trim()});
        isSettingTask = false;
      } else {
        if (kDebugMode) print('Lenght is greater than mentioned');
        isSettingTask = false;
      }
    } catch (e) {
      isSettingTask = false;
      if (kDebugMode) print(e);
    }
    notifyListeners();
  }

  Stream givingStreamOfCategoryPage(
    String categoryName,
    String taskStatusType,
  ) {
    return firestore
        .collection('Users')
        .doc(auth.currentUser!.uid)
        .collection('Tasks')
        .where('Task Status', isEqualTo: taskStatusType)
        .where('Category Name', isEqualTo: categoryName)
        .snapshots();
  }

  // Now making the function for the changing of the Stream based

  // Making the one function for the working of the deleting the Tasks
  Future<void> taskDeletion(String id) async {
    try {
      isSettingTask = true;
      notifyListeners();
      await firestore
          .collection('Users')
          .doc(auth.currentUser!.uid)
          .collection('Tasks')
          .doc(id)
          .delete()
          .timeout(Duration(seconds: 10));
      isSettingTask = false;
    } catch (e) {
      isSettingTask = false;
      if (kDebugMode) print(e);
    }
    notifyListeners();
  }

  Future<void> categoryDeletion(String id) async {
    try {
      isSettingTask = true;
      notifyListeners();
      await firestore
          .collection('Users')
          .doc(auth.currentUser!.uid)
          .collection('Categories')
          .doc(id)
          .delete();
      isSettingTask = false;
    } catch (e) {
      isSettingTask = false;
      if (kDebugMode) print(e);
    }
    notifyListeners();
  }

  // Making the Function for moving the tasks for one list to another
  Future<void> taskMovingBetweenLists(String id) async {
    if (movingTo != 'Not Set') {
      try {
        isSettingTask = true;
        notifyListeners();
        if (movingTo != 'Not Set') {
          await firestore
              .collection('Users')
              .doc(auth.currentUser!.uid)
              .collection('Tasks')
              .doc(id)
              .update({"Task Status": movingTo, "Category Name": category})
              .timeout(Duration(seconds: 10));
          movingToANDcategoryCleaner();
          isSettingTask = false;
        }
      } catch (e) {
        isSettingTask = false;
        if (kDebugMode) print(e);
      }
    }
    notifyListeners();
  }

  // Making the function that will calculate the amount of tasks

  // making the function for getting the length of the pending and completed
  Future<void> pendingCompletedLengthGetting() async {
    final snapshotsPending = await firestore
        .collection('Users')
        .doc(auth.currentUser!.uid)
        .collection('Tasks')
        .where('Task Status', isEqualTo: 'Pending')
        .get();
    final snapshotsCompleted = await firestore
        .collection('Users')
        .doc(auth.currentUser!.uid)
        .collection('Tasks')
        .where('Task Status', isEqualTo: 'Completed')
        .get();
    pendingTasks = snapshotsPending.size;
    completedTasks = snapshotsCompleted.size;
    notifyListeners();
  }

  // making the shared preferences function for saving the pending and completed length
  Future<void> puttingLength() async {
    final pref = await SharedPreferences.getInstance();
    await pref.setInt('Pending', pendingTasks);
    await pref.setInt('Completed', completedTasks);
  }

  Future<void> assigningLength() async {
    final pref = await SharedPreferences.getInstance();
    pendingTasks = pref.getInt('Pending') ?? 0;
    completedTasks = pref.getInt('Completed') ?? 0;
    notifyListeners();
  }

  // making the helper function for the above three
  Future<void> helperOfPendingCompletedLength() async {
    await pendingCompletedLengthGetting();
    await puttingLength();
  }

  // Now making the function for updation of the Tasks
  // This Portion is Relevant to the Editing of the texts...

  void puttingTextInTextFields(String title, String decription) {
    newTitleController = TextEditingController(text: title);
    newDescritionController = TextEditingController(text: decription);
  }

  // making function for the completion Date logic
  void assigningDate(DateTime dateToAssign) {
    taskCompletionDate = DateFormat('MMMM dd, yyy').format(dateToAssign);
    if(kDebugMode) print('Task date is: $taskCompletionDate');
    notifyListeners();
  }

  // // Now here making the function that will update and send data to firebase
  void assigningTaskCompletionDateOnPageAppearing(String date) {
    taskCompletionDate = date;
  }

  Future<void> pushingUpdatedData(String taskId, BuildContext context) async {
    final bar = ScaffoldMessenger.of(context);
    try {
      if (newTitleController.text.trim().isNotEmpty) {
        isSettingTask = true;
        notifyListeners();
        await firestore
            .collection('Users')
            .doc(auth.currentUser!.uid)
            .collection('Tasks')
            .doc(taskId)
            .update({
              "Task Title": newTitleController.text.trim(),
              "Task Description": newDescritionController.text.trim().isNotEmpty
                  ? newDescritionController.text.trim()
                  : 'No description Provided',
              "Completion Date": (taskCompletionDate == 'No completion date set')
                  ? 'No completion date set'
                  : taskCompletionDate,
            });
        isSettingTask = false;
        taskCompletionDate = '';
        if (!context.mounted) return;
        Navigator.of(context).pop();
      } else {
        bar
          ..removeCurrentSnackBar()
          ..showSnackBar(globalBar('Fields cannot be empty'));
      }
    } catch (e) {
      if (kDebugMode) print(e);
      isSettingTask = true;
    }
    notifyListeners();
  }

  // Making the function for changing the User's Name
  Future<void> nameUpdating(TextEditingController controller) async {
    try {
      isSettingTask = true;
      notifyListeners();
      if (controller.text.isNotEmpty) {
        await firestore.collection('Users').doc(auth.currentUser!.uid).update({
          "User Name": controller.text.trim(),
        });
        auth.currentUser!.updateDisplayName(controller.text.trim());
        auth.currentUser!.reload();
        isSettingTask = false;
      } else {
        if (kDebugMode) print('Controller is Empty');
        isSettingTask = false;
      }
    } catch (e) {
      isSettingTask = false;
      if (kDebugMode) print(e);
    }
    notifyListeners();
  }

  // Now making the function for the deletion page
  Future<void> movingTaskToDeletedCategory(String taskID) async {
    try {
      isSettingTask = true;
      notifyListeners();
      await firestore
          .collection('Users')
          .doc(auth.currentUser!.uid)
          .collection('Tasks')
          .doc(taskID)
          .update({"Task Status": 'Deleted'})
          .timeout(Duration(seconds: 10));
      await helperOfPendingCompletedLength();
      if (kDebugMode) print('The task is sent to deleted successfully');
      isSettingTask = false;
    } catch (e) {
      isSettingTask = false;
      if (kDebugMode) print(e);
    }
    notifyListeners();
  }

  // This below function is for resetting the password
  Future<void> resettingPasswordFunction(TextEditingController tc) async {
    try {
      if (tc.text.isNotEmpty) {
        await auth.sendPasswordResetEmail(email: tc.text.trim());
        if (kDebugMode) print('Reset Email is sent at the provided email');
      } else {
        if (kDebugMode) print('Enter Email please');
      }
    } catch (e) {
      if (kDebugMode) print(e);
    }
  }
}
