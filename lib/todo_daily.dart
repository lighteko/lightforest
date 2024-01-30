import 'package:cloud_firestore/cloud_firestore.dart';
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
  final _database = FirebaseFirestore.instance;
  final _taskController = TextEditingController();
  User? loggedUser;
  bool isBibleEnabled = true;
  bool isPrayEnabled = true;
  bool isExerciseEnabled = true;
  List<Map<String, bool>> requiredTasks = [];

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    _database
        .collection("users")
        .where("email", isEqualTo: loggedUser!.email)
        .snapshots()
        .listen((event) {
      print(event.docs[0].data()["tasks"]);
    });
  }

  void getCurrentUser() {
    try {
      final user = _authentication.currentUser;
      if (user != null) print((loggedUser = user).email);
    } catch (e) {
      print(e);
    }
  }

  void _onBiblePressed() {
    setState(() {
      isBibleEnabled = false;
    });
  }

  void _onPrayPressed() {
    setState(() {
      isPrayEnabled = false;
    });
  }

  void _onExercisePressed() {
    setState(() {
      isExerciseEnabled = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
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
          resizeToAvoidBottomInset: true,
          body: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 40,
                ),
                TableCalendar(
                  firstDay: DateTime.utc(2021, 10, 16),
                  lastDay: DateTime.utc(2030, 3, 14),
                  focusedDay: DateTime.now(),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed:
                          isBibleEnabled ? () => _onBiblePressed() : null,
                      style: ElevatedButton.styleFrom(
                        disabledBackgroundColor: const Color(0xff8C7B99),
                        foregroundColor:
                            const Color.fromARGB(255, 255, 255, 255),
                        backgroundColor: const Color(0xff7D4598),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        minimumSize: const Size(100, 100),
                      ),
                      child: Image.asset("assets/bible_icon.png"),
                    ),
                    const SizedBox(
                      width: 50,
                    ),
                    ElevatedButton(
                      onPressed: isPrayEnabled ? () => _onPrayPressed() : null,
                      style: ElevatedButton.styleFrom(
                        disabledBackgroundColor: const Color(0xff8C7B99),
                        foregroundColor:
                            const Color.fromARGB(255, 255, 255, 255),
                        backgroundColor: const Color(0xff7D4598),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        minimumSize: const Size(100, 100),
                      ),
                      child: Image.asset("assets/praying_hand_icon.png"),
                    ),
                    const SizedBox(
                      width: 50,
                    ),
                    ElevatedButton(
                      onPressed:
                          isExerciseEnabled ? () => _onExercisePressed() : null,
                      style: ElevatedButton.styleFrom(
                        disabledBackgroundColor: const Color(0xff8C7B99),
                        foregroundColor:
                            const Color.fromARGB(255, 255, 255, 255),
                        backgroundColor: const Color(0xff7D4598),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        minimumSize: const Size(100, 100),
                      ),
                      child: Image.asset("assets/exercise_icon.png"),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.25),
                                spreadRadius: 5,
                                blurRadius: 18.7,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          width: 380,
                          height: 200,
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        Row(
                          children: [
                            Container(
                              width: 300,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xff818181)
                                        .withOpacity(0.25),
                                    spreadRadius: 0,
                                    blurRadius: 35,
                                    offset: const Offset(
                                        0, 4), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: TextField(
                                  controller: _taskController,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: '할 일 입력',
                                    hintStyle: TextStyle(
                                      color: const Color(0xff620090)
                                          .withOpacity(0.8),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                foregroundColor:
                                    const Color.fromARGB(255, 255, 255, 255),
                                backgroundColor: const Color(0xff7D4598),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                minimumSize: const Size(50, 50),
                              ),
                              child: const Icon(Icons.add),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
