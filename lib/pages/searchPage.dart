import 'dart:ffi';

import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  SearchPage({Key? key});
  final _controller = TextEditingController();
  // String? text;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/sea.jpg'), fit: BoxFit.cover),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(25),
              child: TextFormField(
                onChanged: (value) {
                  _controller.text = value;
                },
                //controller: _controller,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withOpacity(0.5)),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 2, color: Colors.white),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 2, color: Colors.blue),
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
            ),
            TextButton(
              style: ButtonStyle(
                padding: MaterialStateProperty.all(
                    EdgeInsets.symmetric(vertical: 15)),
                backgroundColor: MaterialStatePropertyAll(Colors.blue),
              ),
              onPressed: () {
                FocusManager.instance.primaryFocus?.unfocus();
                if (_controller.text.isNotEmpty) {
                  Navigator.pop(context, _controller.text);
                } //isNotEmpty - если не свободно
              },
              child: Text(
                '          ' 'Input' '          ',
                style: TextStyle(fontSize: 25, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
