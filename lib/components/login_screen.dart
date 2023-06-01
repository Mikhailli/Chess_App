import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../utils/color_utils.dart';
import '../widgets/reusable_widgets.dart';
import 'package:flutter/material.dart';

//code for designing the UI of our text field where the user writes his email id or password

// const kTextFieldDecoration = InputDecoration(
//     hintText: 'Enter a value',
//     hintStyle: TextStyle(color: Colors.grey),
//     contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
//     border: OutlineInputBorder(
//       borderRadius: BorderRadius.all(Radius.circular(32.0)),
//     ),
//     enabledBorder: OutlineInputBorder(
//       borderSide: BorderSide(color: Colors.lightBlueAccent, width: 1.0),
//       borderRadius: BorderRadius.all(Radius.circular(32.0)),
//     ),
//     focusedBorder: OutlineInputBorder(
//       borderSide: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
//       borderRadius: BorderRadius.all(Radius.circular(32.0)),
//     ));

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? email;
  String? password;
  bool showSpinner = false;
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _emailTextController = TextEditingController();

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors:
            [
              hexStringToColor("CB2B93"),
              hexStringToColor("9546C4"),
              hexStringToColor("5E61F4")
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).size.height * 0.2, 20, 0),
              child: Column(
                children: <Widget>[
                  logoWidget(imagePath: "assets/icon/icon.png"),
                  const SizedBox(
                    height: 30,
                  ),
                  reusableTextField("Введите электронную почту", Icons.person_outline, false, _emailTextController),
                  const SizedBox(
                      height: 30),
                  reusableTextField("Введите пароль", Icons.lock_outline, true, _passwordTextController),
                  const SizedBox(
                    height: 30,
                  ),
                  forgetPassword(context),
                  firebaseUIButton(context, "Войти", () {
                    FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                        email: _emailTextController.text,
                        password: _passwordTextController.text)
                        .then((value) {
                      Navigator.pushNamed(context, 'home');
                    }).onError((error, stackTrace) {
                      if (kDebugMode) {
                        print("Ошибка  ${error.toString()}");
                      }
                    });
                  }),
                  signUpOption(context)
                ],
              ),
            ),
          ),
        ),
      );
    }
  }
