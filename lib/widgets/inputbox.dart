import 'package:flutter/material.dart';

class InputBox extends StatelessWidget {
  const InputBox({
    super.key,
    required TextEditingController nicknameController,
    required TextEditingController emailController,
    required TextEditingController passwordController,
  })  : _nicknameController = nicknameController,
        _emailController = emailController,
        _passwordController = passwordController;

  final TextEditingController _nicknameController;
  final TextEditingController _emailController;
  final TextEditingController _passwordController;

  @override
  Widget build(BuildContext context) {
    return Container(
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
            offset: const Offset(0, 4), // changes position of shadow
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
                  contentPadding: EdgeInsets.symmetric(vertical: 10.0)),
            ),
            const SizedBox(
                width: 500,
                child: Divider(color: Color(0xff620090), thickness: 1.1)),
            TextField(
              keyboardType: TextInputType.emailAddress,
              controller: _emailController,
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  labelText: 'Email',
                  labelStyle: TextStyle(
                    color: Color(0xff620090),
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 10.0)),
            ),
            const SizedBox(
                width: 500,
                child: Divider(color: Color(0xff620090), thickness: 1.1)),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  labelText: 'Password',
                  labelStyle: TextStyle(
                    color: Color(0xff620090),
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 10.0)),
            ),
          ],
        ),
      ),
    );
  }
}
