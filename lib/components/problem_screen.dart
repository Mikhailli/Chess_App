import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../widgets/reusable_widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class ProblemScreen extends StatefulWidget {
  const ProblemScreen({Key? key}) : super(key: key);

  @override
  State<ProblemScreen> createState() => _ProblemScreenState();
}

class _ProblemScreenState extends State<ProblemScreen> {

  final controllerTo = TextEditingController();
  final controllerSubject = TextEditingController();
  final controllerMessage = TextEditingController();

  void _createEmailAsync(String to, String subject, String message) async{
    final Uri params = Uri(
        scheme: 'mailto',
        path: "univernik20@yandex.ru",
        queryParameters: {
          'subject': subject,
          'body': message
        }
    );
    if(await canLaunchUrl(params)){
      await launchUrl(params);
    } else {if (kDebugMode) {
      print("Could not launc");
    }}

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.greenAccent,
          title: const Text('♜EazyChess♜',style: TextStyle(fontSize: 24, color: Colors.black)),
          elevation: 0,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              buildTextField(title: "Кому", controller: controllerTo, text: "univernik20@yandex.ru", enabled: false),
              const SizedBox(height: 16),
              buildTextField(title: "Причина", controller: controllerSubject, text: ""),
              const SizedBox(height: 16),
              buildTextField(title: "Сообщение", controller: controllerMessage, maxLines: 8, readonly: true, text: ""),
              const SizedBox(height: 32),
              emailButton(context, () => _createEmailAsync(controllerTo.text, controllerSubject.text, controllerMessage.text))
            ],
          ),
    ),
    );

  }
}
