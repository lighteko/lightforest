import 'package:flutter/material.dart';

class ToDoDaily extends StatelessWidget {
  const ToDoDaily({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          actions: [
            ColorFiltered(
              colorFilter:
                  const ColorFilter.mode(Colors.black, BlendMode.srcIn),
              child: Image.asset('assets/lightforest_appbar_logo.png'),
            ),
          ],
        ),
        body: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("PREV"),
        ),
      ),
    );
  }
}
