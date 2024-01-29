import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
        appBar: AppBar(
          backgroundColor: const Color(0xff9B69DA),
          elevation: 10,
          shadowColor: Colors.black.withOpacity(0.5),
          leading: IconButton(
            icon: const Icon(
              Icons.logout_outlined,
              color: Colors.white,
            ),
            onPressed: () async {
              _authentication.signOut();
              final prefs = await SharedPreferences.getInstance();
              prefs.remove("email");
              prefs.remove("password");
              if (!mounted) return;
              Navigator.pop(context);
            },
          ),
          title: SizedBox(
            height: 300,
            child: Image.asset("assets/lightforest_appbar_logo.png"),
          ),
        ),
        body: Column(
          children: [
            const SizedBox(
              height: 70,
            ),
            TableCalendar(
              firstDay: DateTime.utc(2021, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              focusedDay: DateTime.now(),
            ),
          ],
        ),
      ),
    );
  }
}
