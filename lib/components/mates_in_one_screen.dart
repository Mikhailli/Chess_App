import 'package:flutter/material.dart';
import 'home_edu_screen.dart';
import 'home_game_screen.dart';
import 'home_main_screen.dart';
import 'home_settings_screen.dart';
import 'rounded_button.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class MatesInOneScreen extends StatefulWidget {
  const MatesInOneScreen({super.key});

  @override
  State<MatesInOneScreen> createState() => _MatesInOneScreenState();
}

class _MatesInOneScreenState extends State<MatesInOneScreen> {
  int check = -1;
  int index = 2;
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

    if (check == -1) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.greenAccent,
          title: const Text('♜EazyChess♜',style: TextStyle(fontSize: 24, color: Colors.black)),
          elevation: 0,
          leading: const BackButton(),
          centerTitle: true
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              RoundedButton(
                colour: Colors.blue.shade600,
                title: 'Задача №1',
                onPressed: () {
                  Navigator.pushNamed(context, 'chess_puzzles', arguments: 1);
                },
              ),
              RoundedButton(
                  colour: Colors.blue.shade600,
                  title: 'Задача №2',
                  onPressed: () {
                    Navigator.pushNamed(context, '');
                  }),
              RoundedButton(
                  colour: Colors.blue.shade600,
                  title: 'Задача №3',
                  onPressed: () {
                    Navigator.pushNamed(context, '');
                  }),
            ]),
      ),
      bottomNavigationBar: CurvedNavigationBar (
        backgroundColor: Colors.transparent,
        buttonBackgroundColor: Colors.white,
        animationDuration: const Duration(milliseconds: 300),
        items: items,
        color: Colors.greenAccent,
        height: 60,
        index: index,
        onTap: (index) => setState (() => {
          this.index = index,
          check = 0
        }),
      ),);
    }
    else {
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
        ),);
    }
  }
}
