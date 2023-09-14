import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toni_case_study/services/notification_service.dart';
import 'package:toni_case_study/view/main_page.dart';
import 'package:toni_case_study/view/login_page.dart';
import 'package:toni_case_study/view_model/change_screen.dart';
import 'package:toni_case_study/view_model/firebase_auth_service.dart';
import 'package:toni_case_study/view_model/notification_view_model.dart';
import 'package:toni_case_study/view_model/user_profile_view_model.dart';
import 'package:toni_case_study/view_model/user_search_view_model.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  NotificationService();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => FirebaseAuthServices()),
        ChangeNotifierProvider(create: (context) => UserProfileViewModel()),
        ChangeNotifierProvider(create: (context) => ChangeScreens()),
        ChangeNotifierProvider(create: (context) => UserSearchViewModel()),
        ChangeNotifierProvider(create: (context) => NotificationViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          scaffoldBackgroundColor: const Color.fromARGB(255, 216, 216, 216),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              backgroundColor: Color.fromARGB(255, 228, 226, 226),
              selectedItemColor: Colors.teal),
          appBarTheme: const AppBarTheme(
              color: Colors.teal,
              iconTheme: IconThemeData(color: Colors.white)),
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: FirebaseAuth.instance.currentUser == null
            ? const LoginPage()
            : MainPage(),
      ),
    );
  }
}
