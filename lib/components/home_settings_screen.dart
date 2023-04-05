import 'package:firebase_auth/firebase_auth.dart';
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
                  child: InkWell(
                    splashColor: Colors.blue.withAlpha(30),
                    onTap: (){
                      Navigator.pushNamed(context, 'profile');
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                          leading: const Icon(Icons.male),//Аватарка
                          title: Text(FirebaseAuth.instance.currentUser?.email == null ? FirebaseAuth.instance.currentUser.email : "Вы не залогинены")
                        )
                      ],
                    ),
                  ),),
                RoundedButton(
                    colour: Colors.blue.shade600,
                    title: '⚙️ Настройки',
                    onPressed: () {
                      Navigator.pushNamed(context, '');
                    }),
                RoundedButton(
                    colour: Colors.blue.shade600,
                    title: '🤝 Друзья',
                    onPressed: () {
                      Navigator.pushNamed(context, '');
                    }),
                RoundedButton(
                    colour: Colors.blue.shade600,
                    title: '✍️Сообщения',
                    onPressed: () {
                      Navigator.pushNamed(context, 'home_screen');
                    }),
                RoundedButton(
                    colour: Colors.blue.shade600,

                    title: '⚒️Сообщить о проблеме',
                    onPressed: () {
                      Navigator.pushNamed(context, '');
                    }),
                RoundedButton(
                    colour: Colors.blue.shade600,
                    title: '❗ Помощь',
                    onPressed: () {
                      Navigator.pushNamed(context, '');
                    }),
              ]),
        ));
  }
}
