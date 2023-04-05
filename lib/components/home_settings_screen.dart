import 'package:flutter/material.dart';
import 'rounded_button.dart';

class HomeSettingsScreen extends StatefulWidget {
  const HomeSettingsScreen({Key? key}) : super(key: key);

  @override
  State<HomeSettingsScreen> createState() => _HomeSettingsScreenState();
}

class _HomeSettingsScreenState extends State<HomeSettingsScreen> {
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
                Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      const ListTile(
                        leading: Icon(Icons.male),//Аватарка
                      )
                    ],
                  ),),
                RoundedButton(
                    colour: Colors.blueAccent,
                    title: '⚙️ Настройки',
                    onPressed: () {
                      Navigator.pushNamed(context, '');
                    }),
                RoundedButton(
                    colour: Colors.blueAccent,
                    title: '🤝 Друзья',
                    onPressed: () {
                      Navigator.pushNamed(context, '');
                    }),
                RoundedButton(
                    colour: Colors.blueAccent,
                    title: '✍️Сообщения',
                    onPressed: () {
                      Navigator.pushNamed(context, 'home_screen');
                    }),
                RoundedButton(
                    colour: Colors.blueAccent,

                    title: '⚒️Сообщить о проблеме',
                    onPressed: () {
                      Navigator.pushNamed(context, '');
                    }),
                RoundedButton(
                    colour: Colors.blueAccent,
                    title: '❗ Помощь',
                    onPressed: () {
                      Navigator.pushNamed(context, '');
                    }),
              ]),
        ));
  }
}
