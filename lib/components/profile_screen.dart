import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        title: const Text('♜EazyChess♜',style: TextStyle(fontSize: 24, color: Colors.black)),
        elevation: 0,
        centerTitle: true,
        actions: [
          TextButton(onPressed: () async {
            await FirebaseAuth.instance.signOut();
            await Navigator.pushNamed(context, 'auth');
            }, // TextButton
          child: const Icon(Icons.keyboard_backspace))],
    ));
  }
}

