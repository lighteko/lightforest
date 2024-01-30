import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

class Event {
  String title;
  int amount;
  Event(this.title, this.amount);

  @override
  String toString() => title;
}

class ToDoDaily extends StatefulWidget {
  const ToDoDaily({super.key});

  @override
  State<ToDoDaily> createState() => _ToDoDailyState();
}

class _ToDoDailyState extends State<ToDoDaily> {
  final _authentication = FirebaseAuth.instance;
  final _database = FirebaseFirestore.instance;
  final _taskController = TextEditingController();
  CalendarFormat _calendarFormat = CalendarFormat.month;
  late Future<LinkedHashMap> events;
  User? loggedUser;

  bool isBibleEnabled = true;
  bool isPrayEnabled = true;
  bool isExerciseEnabled = true;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    _database
        .collection("users")
        .where("email", isEqualTo: loggedUser!.email)
        .snapshots()
        .listen((event) {
      final date =
          "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}";
      var data = event.docs[0].data()["tasks"]["required"];
      for (var d in data) {
        if (d["date"] == date) {
          if (d["bible"] == true) isBibleEnabled = false;
          if (d["pray"] == true) isPrayEnabled = false;
          if (d["exercise"] == true) isExerciseEnabled = false;
          break;
        }
      }
    });
  }

  void getCurrentUser() {
    try {
      final user = _authentication.currentUser;
      if (user != null) loggedUser = user;
    } catch (e) {
      //
    }
  }

  void _onBiblePressed() {
    final date =
        "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}";
    Map<String, dynamic> taskData = {};
    _database
        .collection("users")
        .where("email", isEqualTo: loggedUser!.email)
        .snapshots()
        .listen((event) {
      var data = event.docs[0].data();
      final reqs = data["tasks"]["required"];
      int index = -1;
      for (int i = 0; i < reqs.length; i++) {
        index = i;
        if (reqs[0]["date"] == date) {
          taskData = reqs[i];
          break;
        }
      }
      taskData["bible"] = true;
      if (index >= 0) {
        reqs[index] = taskData;
      } else {
        taskData["date"] = date;
        reqs.add(taskData);
      }
      data["tasks"]["required"] = reqs;
      _database
          .collection("users")
          .doc(event.docs[0].id)
          .set(data, SetOptions(merge: true));
    });
    setState(() {
      isBibleEnabled = false;
    });
  }

  void _onPrayPressed() {
    final date =
        "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}";
    Map<String, dynamic> taskData = {};
    _database
        .collection("users")
        .where("email", isEqualTo: loggedUser!.email)
        .snapshots()
        .listen((event) {
      var data = event.docs[0].data();
      final reqs = data["tasks"]["required"];
      int index = -1;
      for (int i = 0; i < reqs.length; i++) {
        index = i;
        if (reqs[0]["date"] == date) {
          taskData = reqs[i];
          break;
        }
      }
      taskData["pray"] = true;
      if (index >= 0) {
        reqs[index] = taskData;
      } else {
        taskData["date"] = date;
        reqs.add(taskData);
      }
      data["tasks"]["required"] = reqs;
      _database
          .collection("users")
          .doc(event.docs[0].id)
          .set(data, SetOptions(merge: true));
    });
    setState(() {
      isPrayEnabled = false;
    });
  }

  void _onExercisePressed() {
    final date =
        "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}";
    Map<String, dynamic> taskData = {};
    _database
        .collection("users")
        .where("email", isEqualTo: loggedUser!.email)
        .snapshots()
        .listen((event) {
      var data = event.docs[0].data();
      final reqs = data["tasks"]["required"];
      int index = -1;
      for (int i = 0; i < reqs.length; i++) {
        index = i;
        if (reqs[0]["date"] == date) {
          taskData = reqs[i];
          break;
        }
      }
      taskData["exercise"] = true;
      if (index >= 0) {
        reqs[index] = taskData;
      } else {
        taskData["date"] = date;
        reqs.add(taskData);
      }
      data["tasks"]["required"] = reqs;
      _database
          .collection("users")
          .doc(event.docs[0].id)
          .set(data, SetOptions(merge: true));
    });
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
                StreamBuilder(
                    stream: _database
                        .collection("users")
                        .where("email", isEqualTo: loggedUser!.email)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      final doc = snapshot.data!.docs[0].data();
                      final completed = doc["tasks"]["required"];
                      List<DateTime> days = [];
                      for (var day in completed) {
                        if (day["bible"] == true &&
                            day["pray"] == true &&
                            day["exercise"] == true) {
                          final date = day["date"];
                          final dayTemp = date.split("-");
                          days.add(DateTime(int.parse(dayTemp[0]),
                              int.parse(dayTemp[1]), int.parse(dayTemp[2])));
                        }
                      }

                      final Map<DateTime, dynamic> source = {};

                      for (DateTime day in days) {
                        source[day] = ["s"];
                      }
                      final events = LinkedHashMap(
                        equals: isSameDay,
                      )..addAll(source);

                      return TableCalendar(
                        locale: "ko_KR",
                        daysOfWeekHeight: 30,
                        eventLoader: (day) {
                          return events[
                                  DateTime(day.year, day.month, day.day)] ??
                              [];
                        },
                        firstDay: DateTime.utc(2021, 10, 16),
                        lastDay: DateTime.utc(2030, 3, 14),
                        focusedDay: DateTime.now(),
                        calendarFormat: _calendarFormat,
                        availableCalendarFormats: const {
                          CalendarFormat.month: '한 달 단위로',
                          CalendarFormat.week: '1주 단위로',
                        },
                        onFormatChanged: (format) {
                          setState(() {
                            _calendarFormat = format;
                          });
                        },
                      );
                    }),
                const SizedBox(
                  height: 20,
                ),
                StreamBuilder(
                    stream: null,
                    builder: (context, snapshot) {
                      return Row(
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
                            onPressed:
                                isPrayEnabled ? () => _onPrayPressed() : null,
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
                            onPressed: isExerciseEnabled
                                ? () => _onExercisePressed()
                                : null,
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
                      );
                    }),
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
