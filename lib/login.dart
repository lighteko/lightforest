import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lightforest/todo_daily.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _nicknameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  final _authentication = FirebaseAuth.instance;
  final _database = FirebaseFirestore.instance;

  void autoLogin() async {
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
    DocumentReference user = await _database.collection("users").add({
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
    autoLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [
            const SizedBox(
              width: double.infinity,
              height: double.infinity, // Set your desired color
            ),
            Positioned(
              left: (MediaQuery.of(context).size.width - 1000) /
                  2, // Center horizontally
              top: -400,
              child: Container(
                width: 1000, // Set a constant width
                height: 1000, // Set a constant height
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
              children: [
                const SizedBox(height: 100),
                Image.asset('assets/lightforest_main.png'),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 300),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 300,
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xff818181).withOpacity(0.25),
                            spreadRadius: 0,
                            blurRadius: 35,
                            offset: const Offset(
                                0, 4), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            TextField(
                              controller: _nicknameController,
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  labelText: 'Nickname',
                                  labelStyle: TextStyle(
                                    color: Color(0xff620090),
                                  ),
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 10.0)),
                            ),
                            const SizedBox(
                                width: 500,
                                child: Divider(
                                    color: Color(0xff620090), thickness: 1.1)),
                            TextField(
                              keyboardType: TextInputType.emailAddress,
                              controller: _emailController,
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  labelText: 'Email',
                                  labelStyle: TextStyle(
                                    color: Color(0xff620090),
                                  ),
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 10.0)),
                            ),
                            const SizedBox(
                                width: 500,
                                child: Divider(
                                    color: Color(0xff620090), thickness: 1.1)),
                            TextField(
                              controller: _passwordController,
                              obscureText: true,
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  labelText: 'Password',
                                  labelStyle: TextStyle(
                                    color: Color(0xff620090),
                                  ),
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 10.0)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
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
                            await _authentication
                                .createUserWithEmailAndPassword(
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
                                content: const Text(
                                    "이메일과 비밀번호를 다시 한번 확인해 주세요\n비밀번호는 6자 이상 입니다"),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(); // Close the dialog
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          }
                        }
                      },
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
                const SizedBox(height: 100)
              ],
            )
          ],
        ),
      ),
    );
  }
}
