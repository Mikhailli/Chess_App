import 'package:chess/components/home_edu_screen.dart';
import 'package:chess/components/home_game_screen.dart';
import 'package:chess/components/home_main_screen.dart';
import 'home_settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<StatefulWidget> createState() => HomeScr();

}
class HomeScr extends State<Home>{
  int index = 0;
  final screens = [
    const HomeMainScreen(),
    const HomeGameScreen(),
    const HomeEduScreen(),
    const HomeSettingsScreen(),
  ];
  @override
  Widget build(BuildContext context) {

    final items = <Widget>[
      const Icon(Icons.home_filled, size: 30,),
      const Icon(Icons.gamepad_rounded, size: 30,),
      const Icon(Icons.book, size: 30,),
      const Icon(Icons.settings, size: 30,)
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.greenAccent,
        title: const Text('♜EazyChess♜',style: TextStyle(fontSize: 24, color: Colors.black)),
        elevation: 0,
        centerTitle: true
      ),
      body: screens[index],
      bottomNavigationBar: CurvedNavigationBar (
        backgroundColor: Colors.transparent,
        buttonBackgroundColor: Colors.white,
        animationDuration: const Duration(milliseconds: 300),
        items: items,
        color: Colors.greenAccent,
        height: 60,
        index: index,
        onTap: (index) => setState (() => this.index = index),
      ),
    );
  }

}
