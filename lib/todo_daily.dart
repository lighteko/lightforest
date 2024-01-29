import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class ToDoDaily extends StatefulWidget {
  const ToDoDaily({super.key});

  @override
  State<ToDoDaily> createState() => _ToDoDailyState();
}

class _ToDoDailyState extends State<ToDoDaily> {
  final _authentication = FirebaseAuth.instance;
  User? loggedUser;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    try {
      final user = _authentication.currentUser;
      if (user != null) print((loggedUser = user).email);
    } catch (e) {
      print(e);
    }
  }

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
                _authentication.signOut();
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
