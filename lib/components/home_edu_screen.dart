import 'package:flutter/material.dart';
import 'rounded_button.dart';

class HomeEduScreen extends StatefulWidget {
  const HomeEduScreen({Key? key}) : super(key: key);

  @override
  State<HomeEduScreen> createState() => _HomeEduScreenState();
}

class _HomeEduScreenState extends State<HomeEduScreen> {
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
                  colour: Colors.blue.shade600,
                  title: ' 📚 Уроки',
                  onPressed: () {
                    Navigator.pushNamed(context, '');
                  },
                ),
                RoundedButton(
                    colour: Colors.blue.shade600,
                    title: '🏰 Дебюты',
                    onPressed: () {
                      Navigator.pushNamed(context, '');
                    }),
                RoundedButton(
                    colour: Colors.blue.shade600,
                    title: '♟️Эндшпиль',
                    onPressed: () {
                      Navigator.pushNamed(context, '');
                    }),
              ]),
        ));
  }
}
