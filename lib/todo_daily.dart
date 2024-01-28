import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class ToDoDaily extends StatelessWidget {
  const ToDoDaily({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            TableCalendar(
              firstDay: DateTime.utc(2021, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              focusedDay: DateTime.now(),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("PREV"),
            ),
          ],
        ),
      ),
    );
  }
}
