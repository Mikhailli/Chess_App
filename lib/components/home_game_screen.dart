import 'package:flutter/material.dart';
import 'rounded_button.dart';

class HomeGameScreen extends StatefulWidget {
  const HomeGameScreen({Key? key}) : super(key: key);

  @override
  State<HomeGameScreen> createState() => _HomeGameScreenState();
}

class _HomeGameScreenState extends State<HomeGameScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                RoundedButton(
                    colour: Colors.blueAccent,
                    title: '🤖 Игра с ботом',
                    onPressed: () {
                      Navigator.pushNamed(context, '');
                    }),
                RoundedButton(
                    colour: Colors.blueAccent,
                    title: '👱‍♂️ Игра с человеком',
                    onPressed: () {
                      Navigator.pushNamed(context, '');
                    }),
                RoundedButton(
                    colour: Colors.blueAccent,
                    title: '🧑‍🤝‍🧑 Игра с самим собой',
                    onPressed: () {
                      Navigator.pushNamed(context, 'home_screen');
                    }),
              ]),
        ));
  }
}
