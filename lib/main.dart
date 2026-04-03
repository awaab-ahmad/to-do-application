import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/services/global_items.dart';
import 'package:to_do_app/services/provider_page.dart';
import 'package:to_do_app/taskPages/front_page.dart';
import 'package:to_do_app/taskPages/intro_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MainClass());
}

class MainClass extends StatelessWidget {
  const MainClass({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => StateManagementProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: const Color(0xFFFFF9F0),
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF7DD2A3),
            onPrimary: const Color(0xFFF3DEBC),
            primary: const Color(0xFFF97F7F),
            onPrimaryFixed: const Color(0xFFFFB74D),
            secondary: const Color(0xFF81C784),
            onSecondary: const Color(0xFFFFF9F0),
          ),
        ),
        home: StateManager(),
      ),
    );
  }
}

class StateManager extends StatelessWidget {
  const StateManager({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: globalProgressIndicator());
        } else if (snapshot.hasData && snapshot.data != null) {
          return FrontPage();
        }
        return StartUpPage();
      },
    );
  }
}
