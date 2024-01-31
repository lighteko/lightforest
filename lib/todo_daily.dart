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
  CalendarFormat _calendarFormat = CalendarFormat.week;
  late Future<LinkedHashMap> events;
  User? loggedUser;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
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
                        return TableCalendar(
                          locale: "ko_KR",
                          daysOfWeekHeight: 30,
                          rowHeight: 60,
                          calendarStyle:
                              const CalendarStyle(outsideDaysVisible: false),
                          firstDay: DateTime.utc(2021, 10, 16),
                          lastDay: DateTime.utc(2030, 3, 14),
                          focusedDay: DateTime.now(),
                          calendarFormat: _calendarFormat,
                          calendarBuilders: CalendarBuilders(
                            defaultBuilder: (context, day, focusedDay) {
                              return Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 20),
                                    child: Text(
                                      "${day.day}",
                                      style: const TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                            todayBuilder: (context, day, focusedDay) {
                              return Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: const Color(0xff7D4598), width: 2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 21),
                                    child: Text(
                                      "${day.day}",
                                      style: const TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
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
                      }
                      final doc = snapshot.data!.docs[0].data();
                      final completed = doc["tasks"]["required"];
                      List<DateTime> days = [];
                      for (var task in completed) {
                        if (task["bible"] == true &&
                            task["pray"] == true &&
                            task["exercise"] == true) {
                          final date = task["date"];
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
                        rowHeight: 60,
                        eventLoader: (day) {
                          return events[
                                  DateTime(day.year, day.month, day.day)] ??
                              [];
                        },
                        calendarStyle:
                            const CalendarStyle(outsideDaysVisible: false),
                        firstDay: DateTime.utc(2021, 10, 16),
                        lastDay: DateTime.utc(2030, 3, 14),
                        focusedDay: DateTime.now(),
                        calendarFormat: _calendarFormat,
                        calendarBuilders: CalendarBuilders(
                          defaultBuilder: (context, day, focusedDay) {
                            return Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: Text(
                                    "${day.day}",
                                    style: const TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                          todayBuilder: (context, day, focusedDay) {
                            return Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: const Color(0xff7D4598), width: 2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 21),
                                  child: Text(
                                    "${day.day}",
                                    style: const TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                          markerBuilder: (context, day, events) {
                            if (events.isNotEmpty) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: const Color(0xff9E3B35),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(
                                    Icons.local_fire_department_rounded,
                                    size: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              );
                            } else {
                              return null;
                            }
                          },
                        ),
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
                      final date =
                          "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}";
                      bool isBibleEnabled = true;
                      bool isPrayEnabled = true;
                      bool isExerciseEnabled = true;
                      for (var task in completed) {
                        if (task["date"] == date) {
                          task["bible"] != null ? isBibleEnabled = false : null;
                          task["pray"] != null ? isPrayEnabled = false : null;
                          task["exercise"] != null
                              ? isExerciseEnabled = false
                              : null;
                        }
                      }
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
