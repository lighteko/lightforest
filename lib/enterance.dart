import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lightforest/todo_daily.dart';
import 'package:lightforest/widgets/inputbox.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Enterance extends StatefulWidget {
  const Enterance({super.key});

  @override
  State<Enterance> createState() => _EnteranceState();
}

class _EnteranceState extends State<Enterance> {
  final _nicknameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  final _authentication = FirebaseAuth.instance;
  final _database = FirebaseFirestore.instance;

  _onPressed() async {
    String nickname = _nicknameController.text;
    String password = _passwordController.text;
    String email = _emailController.text;

    try {
      final prefs = await SharedPreferences.getInstance();
      await _authentication.signInWithEmailAndPassword(
          email: email, password: password);
      _nicknameController.text = "";
      _passwordController.text = "";
      _emailController.text = "";

      await prefs.setString("email", email);
      await prefs.setString("password", password);

      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ToDoDaily(),
        ),
      );
    } catch (e) {
      try {
        await _authentication.createUserWithEmailAndPassword(
            email: email, password: password);
        _nicknameController.text = "";
        _passwordController.text = "";
        _emailController.text = "";
        _addUser(nickname, email);
        if (!mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ToDoDaily(),
          ),
        );
      } catch (e) {
        if (!mounted) return;
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("인증 실패"),
            content: const Text("이메일과 비밀번호를 다시 한번 확인해 주세요\n비밀번호는 6자 이상 입니다"),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  void _autoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString("email") != null) {
      await _authentication.signInWithEmailAndPassword(
        email: prefs.getString("email")!,
        password: prefs.getString("password")!,
      );
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ToDoDaily(),
        ),
      );
    }
  }

  Future<void> _addUser(String nickname, String email) async {
    await _database.collection("users").add({
      "nickname": nickname,
      "email": email,
      "tasks": {
        "required": [],
        "additional": [],
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _autoLogin();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [
            Positioned(
              left: -screenWidth / 2,
              top: -screenWidth * 1.4 / 2,
              child: Container(
                clipBehavior: Clip.hardEdge,
                width: screenWidth * 2,
                height: screenWidth * 2,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xff9B69DA),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xff1D0092).withOpacity(0.35),
                      spreadRadius: 20,
                      blurRadius: 75,
                      offset: const Offset(0, 15), // changes position of shadow
                    ),
                  ],
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/lightforest_main.png",
                ),
                const SizedBox(
                  height: 250,
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 200,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InputBox(
                      nicknameController: _nicknameController,
                      emailController: _emailController,
                      passwordController: _passwordController,
                    ),
                  ],
                )
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 60),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () => _onPressed(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(
                              0xffA781E5), // background onPrimary: Colors.white, // foreground )
                        ),
                        child: const SizedBox(
                          width: 250,
                          height: 60,
                          child: Center(
                            child: Text(
                              "LOG IN / SIGN UP",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
