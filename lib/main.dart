// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:hotels/controllers/auth_controllers.dart';
// import 'package:hotels/view/home_screen.dart';
// import 'package:hotels/view/login.dart';
// import 'package:hotels/view/splash.dart';
// import 'package:firebase_core/firebase_core.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   Get.put(AuthenticationController());
//   runApp(const MyApp());
// }

// class MyApp extends StatefulWidget {
//   const MyApp({Key? key});

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   var auth = FirebaseAuth.instance;
//   var _isLogin = false;

//   checkIfLogin() async {
//     auth.authStateChanges().listen((User? user) {
//       if (user != null && mounted) {
//         setState(() {
//           _isLogin = true;
//         });
//       }
//     });
//   }

//   @override
//   void initState() {
//     // TODO: implement initState
//     checkIfLogin();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Apna PG',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       initialRoute: '/', // Specify the initial route
//       routes: {
//         '/': (context) => const SplashScreen(),
//         '/login': (context) =>
//             _isLogin ? const HomeScreen() : const LoginScreen(),
//       },
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotels/controllers/auth_controllers.dart';
import 'package:hotels/view/home_screen.dart';
import 'package:hotels/view/login.dart';
import 'package:hotels/view/splash.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Get.put(AuthenticationController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Apna PG',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/', // Specify the initial route
      getPages: [
        GetPage(
          name: '/',
          page: () => const SplashScreen(),
        ),
        GetPage(
          name: '/login',
          page: () {
            var user = FirebaseAuth.instance.currentUser;
            return user != null ? HomeScreen() : const LoginScreen();
          },
        ),
      ],
    );
  }
}
