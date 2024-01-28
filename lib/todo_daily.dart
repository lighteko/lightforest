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
              colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
              child: Image.asset(
                'lightforest_appbar_logo.png', // Replace with the path to your image asset
                width: 40.0,
                height: 40.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
