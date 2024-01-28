import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

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
                Image.asset('lightforest_main.png'),
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
                      height: 150,
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
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            TextField(
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  labelText: 'Nickname',
                                  labelStyle: TextStyle(
                                    color: Color(0xff620090),
                                  ),
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 15.0)),
                            ),
                            SizedBox(
                                width: 500,
                                child: Divider(
                                    color: Color(0xff620090), thickness: 1.1)),
                            TextField(
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  labelText: 'Password',
                                  labelStyle: TextStyle(
                                    color: Color(0xff620090),
                                  ),
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 15.0)),
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
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(
                            0xffA781E5), // background onPrimary: Colors.white, // foreground )
                      ),
                      child: const SizedBox(
                        width: 250,
                        height: 60,
                        child: Center(
                          child: Text(
                            "LOG IN / SIGN IN",
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
