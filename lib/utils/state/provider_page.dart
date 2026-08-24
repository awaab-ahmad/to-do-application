import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_app/utils/reusables.dart/snack_bar.dart';
import 'package:to_do_app/screens/after_account_screens/front_page.dart';
import 'package:to_do_app/screens/before_account_screens/login.dart';

// Making the Class for the StateManagement

class StateManagementProvider extends ChangeNotifier {
  bool isSettingTask = false;
  bool inSheetLoading = false;
  DateTime completionDate = DateTime.now();
  String formattedCompletionDate = 'Not Set';
  String taskStatus = 'Not Set';
  String taskCategory = 'Not Set';
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
  TextEditingController categoryCon = TextEditingController();
  TextEditingController? taskTitleCont;
  TextEditingController? descCont;
  Stream? myCategoriesSteam;

  // all new made variables and their used function on top
  int indChange = 0;
  int categoryPgBtnInd = 0;
  int categoryInd = 0;
  bool toSelectMultiple = false;
  bool editDetailsPage = false;
  Set<String> toSelectMList = {};
  int colorInd = 0;

  void changeColorInd(int ind) {
    if (colorInd != ind) {
      colorInd = ind;
      notifyListeners();
    }
  }

  void changeInd(int ind) {
    if (indChange == ind) {
      if (kDebugMode) print('same index');
    } else {
      indChange = ind;
      notifyListeners();
    }
  }

  void changeCategoryInd(int ind) {
    if (categoryInd == ind) {
      if (kDebugMode) print('same index');
    } else {
      categoryInd = ind;
      notifyListeners();
    }
  }

  void newCateName(String cate) {
    taskCategory = cate;
  }

  void catePgBtnIndChg(int ind) {
    categoryPgBtnInd = ind;
    notifyListeners();
  }

  void resetCatePgBtnInd() {
    if (categoryPgBtnInd != 0) {
      categoryPgBtnInd = 0;
    }
  }

  void allowMutlipleSelect() {
    if (!toSelectMultiple) {
      toSelectMultiple = true;
      notifyListeners();
    }
  }

  void cancelMultipleAllow() {
    toSelectMultiple = false;
    toSelectMList.clear();
    notifyListeners();
  }

  void allowEditDetailsPg() {
    editDetailsPage = true;
    notifyListeners();
  }

  void disallowEditDetailsPg() {
    editDetailsPage = false;
    notifyListeners();
  }

  void addingMultipleItems(String taskId) {
    if (toSelectMList.contains(taskId)) {
      toSelectMList.remove(taskId);
    } else {
      toSelectMList.add(taskId);
    }
    if (kDebugMode) print(toSelectMList);
    notifyListeners();
  }

  Future<void> movingMultipleTasks(String moveTo) async {
    if (toSelectMList.isEmpty) return;
    isSettingTask = true;
    notifyListeners();
    try {
      final batch = FirebaseFirestore.instance.batch();
      for (int i = 0; i < toSelectMList.length; i++) {
        final id = toSelectMList.elementAt(i);
        final ref = FirebaseFirestore.instance
            .collection('Users')
            .doc(auth.currentUser!.uid)
            .collection('Tasks')
            .doc(id);
        batch.update(ref, {'Task Status': moveTo});
      }
      await batch.commit();
    } catch (e) {
      if (kDebugMode) print(e);
    } finally {
      isSettingTask = false;
      toSelectMultiple = false;
      toSelectMList.clear();
      notifyListeners();
    }
  }

  Future<void> deletingMultipleTasks() async {
    if (toSelectMList.isEmpty) return;
    isSettingTask = true;
    notifyListeners();
    try {
      final batch = FirebaseFirestore.instance.batch();
      for (int i = 0; i < toSelectMList.length; i++) {
        final id = toSelectMList.elementAt(i);
        final ref = FirebaseFirestore.instance
            .collection('Users')
            .doc(auth.currentUser!.uid)
            .collection('Tasks')
            .doc(id);
        batch.delete(ref);
      }
      await batch.commit();
    } catch (e) {
      if (kDebugMode) print(e);
    } finally {
      isSettingTask = false;
      toSelectMultiple = false;
      toSelectMList.clear();
      notifyListeners();
    }
  }

  void settingControllers() {
    taskTitleCont = TextEditingController();
    descCont = TextEditingController();
  }

  void disposingController() {
    taskTitleCont!.clear();
    descCont!.clear();
  }

  Stream streamFetching() {
    return firestore
        .collection('Users')
        .doc(auth.currentUser!.uid)
        .collection('Categories')
        .snapshots();
  }

  Stream taskStreamFetch(String statusNm) {
    return firestore
        .collection('Users')
        .doc(auth.currentUser!.uid)
        .collection('Tasks')
        .where('Task Status', isEqualTo: statusNm)
        .snapshots();
  }

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
    } on FirebaseAuthException catch (e) {
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
    } finally {
      isSettingTask = false;
      textEditingControllersCleaner();
      notifyListeners();
    }
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
    } on FirebaseAuthException catch (e) {
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
    } finally {
      isSettingTask = false;
      textEditingControllersCleaner();
      notifyListeners();
    }
  }

  void textEditingControllersCleaner() {
    signUpUserName.clear();
    signUpEmail.clear();
    signUpPassword.clear();

    loginEmail.clear();
    loginPassword.clear();
  }

  void creatingTaskOpeningFunc() {
    if (taskCategory != 'No category') taskCategory = 'No category';
    if (taskStatus != 'Pending') taskStatus = 'Pending';
    if (categoryInd != -1) categoryInd = -1;
    if (indChange != 0) indChange = 0;
  }

  void resetCategoryInd() {
    if (categoryInd != -1) categoryInd = -1;
  }

  // Continueing the New Phase of bringing the Firebase
  void selectedTaskStatus(String statusName) {
    if (taskStatus == statusName) {
      if (kDebugMode) print('same type');
    } else {
      taskStatus = statusName;
      notifyListeners();
    }
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
    if (kDebugMode) print(dt);
    completionDate = dt;
    formattedCompletionDate = DateFormat('MMMM dd, yyy').format(completionDate);
    notifyListeners();
  }

  Future<void> taskCreationFunction(BuildContext context) async {
    try {
      if (taskTitleCont!.text.trim().isNotEmpty) {
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
                'Category Name': taskCategory == 'No category'
                    ? 'Not Set'
                    : taskCategory,
                'Task Title': taskTitleCont!.text.trim(),
                'Task Description': (descCont!.text.trim().isEmpty)
                    ? 'No description Provided'
                    : descCont!.text.trim(),
                'Dated on': exactDate,
                'Completion Date': (formattedCompletionDate == 'Not Set')
                    ? 'No completion date set'
                    : formattedCompletionDate,
              })
              .timeout(Duration(seconds: 10));
        } else {
          if (kDebugMode) print('Task Status is not set Properly');
        }
      } else {
        if (kDebugMode) print('The Title is Empty');
      }
    } catch (e) {
      if (kDebugMode) print(e);
    } finally {
      isSettingTask = false;
      if (context.mounted) {
        Navigator.of(context).pop();
      }
      taskTitleCont!.clear();
      descCont!.clear();
      notifyListeners();
    }
  }

  // Making the function for the creation of the Category
  Future<void> categoryCreation(int color, BuildContext cnt) async {
    try {
      final String name = categoryCon.text.trim();
      if (name.isNotEmpty &&
          name != 'Pending' &&
          name != 'Completed' &&
          name != 'Deleted' &&
          name.length < 14) {
        isSettingTask = true;
        notifyListeners();
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(auth.currentUser!.uid)
            .collection('Categories')
            .doc()
            .set({"Category Name": name, "color": color});
      }
    } catch (e) {
      if (kDebugMode) print(e);
    } finally {
      isSettingTask = false;
      colorInd = 0;
      categoryCon.clear();
      if (cnt.mounted) {
        Navigator.pop(cnt);
      }
      notifyListeners();
    }
  }

  void givingStreamOfCategoryPage(String categoryName, String taskStatusType) {
    myCategoriesSteam = firestore
        .collection('Users')
        .doc(auth.currentUser!.uid)
        .collection('Tasks')
        .where('Task Status', isEqualTo: taskStatusType)
        .where('Category Name', isEqualTo: categoryName)
        .snapshots();
  }

  Future<void> categoryDeletion(String nm, String id, BuildContext cnt) async {
    try {
      isSettingTask = true;
      notifyListeners();
      await firestore
          .collection('Users')
          .doc(auth.currentUser!.uid)
          .collection('Categories')
          .doc(id)
          .delete()
          .timeout(Duration(seconds: 10));
      final btch = firestore.batch();
      // making the working if categor got deleted, set its tasks to Not set
      final query = await firestore
          .collection('Users')
          .doc(auth.currentUser!.uid)
          .collection('Tasks')
          .where('Category Name', isEqualTo: nm)
          .get();
      for (var doc in query.docs) {
        btch.update(doc.reference, {'Category Name': 'Not Set'});
      }
      btch.commit();
    } catch (e) {
      if (kDebugMode) print(e);
    } finally {
      isSettingTask = false;
      notifyListeners();
      if (cnt.mounted) {
        Navigator.pop(cnt);
      }
    }
  }

  void oldCateNameAssign(String oldName) {
    categoryCon = TextEditingController(text: oldName);
  }

  Future<void> editCategoryName(
    String oldNm,
    String id,
    int c,
    BuildContext cn,
  ) async {
    try {
      final name = categoryCon.text.trim();
      if (name.isNotEmpty &&
          name != 'Pending' &&
          name != 'Completed' &&
          name != 'Deleted' &&
          name.length < 14) {
        isSettingTask = true;
        notifyListeners();
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(auth.currentUser!.uid)
            .collection('Categories')
            .doc(id)
            .update({"Category Name": name, "color": c})
            .timeout(Duration(seconds: 10));
      }
      final batch = firestore.batch();
      final query = await firestore
          .collection('Users')
          .doc(auth.currentUser!.uid)
          .collection('Tasks')
          .where('Category Name', isEqualTo: oldNm)
          .get();
      for (var doc in query.docs) {
        batch.update(doc.reference, {'Category Name': name});
      }
      batch.commit();
    } catch (e) {
      if (kDebugMode) print(e);
    } finally {
      isSettingTask = false;
      categoryCon.clear();
      notifyListeners();
      if (cn.mounted) {
        Navigator.pop(cn);
      }
    }
  }

  // Making the Function for moving the tasks for one list to another
  Future<void> taskMovingBetweenLists(
    String id,
    String moveTo,
    String cate,
  ) async {
    try {
      isSettingTask = true;
      notifyListeners();
      await firestore
          .collection('Users')
          .doc(auth.currentUser!.uid)
          .collection('Tasks')
          .doc(id)
          .update({"Task Status": moveTo, "Category Name": cate})
          .timeout(Duration(seconds: 10));
    } catch (e) {
      if (kDebugMode) print(e);
    } finally {
      isSettingTask = false;
      notifyListeners();
    }
  }

  Future<void> changeTaskCategory(
    BuildContext cn,
    String taskId,
    String cate,
  ) async {
    try {
      inSheetLoading = true;
      notifyListeners();
      await firestore
          .collection('Users')
          .doc(auth.currentUser!.uid)
          .collection('Tasks')
          .doc(taskId)
          .update({'Category Name': cate});
    } catch (e) {
      if (kDebugMode) print(e);
    } finally {
      inSheetLoading = false;
      notifyListeners();
      if (cn.mounted) {
        Navigator.of(cn).pop();
      }
    }
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
    await puttingLength();
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

  Future<void> frontPgLengthHelper() async {
    await assigningLength();
    await pendingCompletedLengthGetting();
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
    if (kDebugMode) print('Task date is: $taskCompletionDate');
    notifyListeners();
  }

  void makingComDateEmpty() {
    taskCompletionDate = '';
    editDetailsPage = false;
  }

  // // Now here making the function that will update and send data to firebase
  void assigningTaskCompletionDateOnPageAppearing(String date) {
    taskCompletionDate = date;
  }

  Future<void> pushingUpdatedData(
    String taskId,
    BuildContext context,
    String dt,
  ) async {
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
            .set({
              "Task Title": newTitleController.text.trim(),
              "Task Description": newDescritionController.text.trim().isNotEmpty
                  ? newDescritionController.text.trim()
                  : 'No description Provided',
              "Completion Date": taskCompletionDate == ''
                  ? dt
                  : taskCompletionDate,
              "Last edited": Timestamp.fromDate(DateTime.now()),
            }, SetOptions(merge: true));
        isSettingTask = false;
        taskCompletionDate = '';
        editDetailsPage = false;
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
