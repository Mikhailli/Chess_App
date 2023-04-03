import 'package:chess/components/home_screen.dart';
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
    const HomeScreen(),
    const HomeScreen(),
    const HomeScreen(),
    const HomeScreen(),
  ];
  Widget build(BuildContext context) {

    final items = <Widget>[
      Icon(Icons.ice_skating, size: 30,),
      Icon(Icons.ice_skating, size: 30,),
      Icon(Icons.ice_skating, size: 30,),
      Icon(Icons.ice_skating, size: 30,)
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        title: const Text('♜EazyChess♜'),
        elevation: 0,
        centerTitle: true,

      ),
      body: screens[index],
      bottomNavigationBar: CurvedNavigationBar (
        backgroundColor: Colors.transparent,
        buttonBackgroundColor: Colors.white,
        items: items,
        color: Colors.greenAccent,
        height: 60,
        index: index,
        onTap: (index) => setState (() => this.index = index),
      ),
    );
  }

}
