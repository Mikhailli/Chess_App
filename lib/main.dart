import 'package:chess/components/auth_screen.dart';
import 'package:chess/components/home_screen.dart';
import 'package:chess/components/home.dart';
import 'package:chess/components/registration_screen.dart';
import 'package:chess/components/login_screen.dart';
import 'package:chess/components/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future getCurrentUser() async {
    User user = await FirebaseAuth.instance.currentUser;
    if (kDebugMode) {
      print("User: ${user.email ?? "None"}");
    }
    if (kDebugMode) {
      print(user);
    }
    return user;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,

      ),

      initialRoute: 'auth',
      routes: {
        'welcome_screen': (context) => WelcomeScreen(),
        'registration_screen': (context) => RegistrationScreen(),
        'login_screen': (context) => LoginScreen(),
        'home_screen': (context) => HomeScreen(),
        'home': (context) => Home(),
        'auth': (context) => auth_screen()
      },

    );
    // final items = <Widget>[
    //   Icon(Icons.ice_skating, size: 30,),
    //   Icon(Icons.ice_skating, size: 30,),
    //   Icon(Icons.ice_skating, size: 30,),
    //   Icon(Icons.ice_skating, size: 30,)
    // ];
    // return Scaffold(
    //   backgroundColor: Colors.white,
    //   appBar: AppBar(
    //     title: const Text('chess'),
    //     elevation: 0,
    //     centerTitle: true,
    //
    //   ),
    //   bottomNavigationBar: CurvedNavigationBar (
    //     items: items,
    //   ),
    // );
  }
}