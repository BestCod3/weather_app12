import 'package:flutter/material.dart';

class FutureTestPage extends StatefulWidget {
  const FutureTestPage({Key? key});

  @override
  State<FutureTestPage> createState() => _FutureTestPageState();
}

class _FutureTestPageState extends State<FutureTestPage> {
  String text = 'Texti alyp kel';
  String? textAsync;
  void initState() {
    getText();
    super.initState();
  }

  Future<String> getText() async {
    return await Future.delayed(Duration(seconds: 3), () {
      setState(() {});
      return textAsync = 'text Async keldi';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: TextStyle(fontSize: 25),
            ),
            SizedBox(
              height: 30,
            ),
            Text(
              textAsync ?? '...',
              style: TextStyle(fontSize: 25),
            ),
            Text(
              "Salam",
              style: TextStyle(fontSize: 25),
            )
          ],
        ),
      ),
    );
  }
}
