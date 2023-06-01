import 'package:flutter/material.dart';
import '../widgets/reusable_widgets.dart';

class ProblemScreen extends StatefulWidget {
  const ProblemScreen({Key? key}) : super(key: key);

  @override
  State<ProblemScreen> createState() => _ProblemScreenState();
}

class _ProblemScreenState extends State<ProblemScreen> {

  final controllerTo = TextEditingController();
  final controllerSubject = TextEditingController();
  final controllerMessage = TextEditingController();

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
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              buildTextField(title: "To", controller: controllerTo),
              const SizedBox(height: 16),
              buildTextField(title: "Subject", controller: controllerSubject),
              const SizedBox(height: 16),
              buildTextField(title: "Message", controller: controllerMessage, maxLines: 8),
              const SizedBox(height: 32),
              // EmailButton(context, )

            ],
          ),
    ),
    );
  }
}
