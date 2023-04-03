import 'package:flutter/material.dart';
import 'rounded_button.dart';

class HomeMainScreen extends StatefulWidget {
  const HomeMainScreen({Key? key}) : super(key: key);

  @override
  State<HomeMainScreen> createState() => _HomeMainScreenState();
}

class _HomeMainScreenState extends State<HomeMainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                RoundedButton(
                  colour: Colors.lightBlueAccent,
                  title: '📖 Обучение',
                  onPressed: () {
                    Navigator.pushNamed(context, '');
                  },
                ),
                RoundedButton(
                    colour: Colors.blueAccent,
                    title: '🤖 Игра с ботом',
                    onPressed: () {
                      Navigator.pushNamed(context, '');
                    }),
                RoundedButton(
                    colour: Colors.blueAccent,
                    title: '🏆 Рейтинговая таблица',
                    onPressed: () {
                      Navigator.pushNamed(context, '');
                    }),
              ]),
        ));
  }
}
