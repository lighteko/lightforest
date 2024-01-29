import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lightforest/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// ...

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
      apiKey: dotenv.get("APIKEY"),
      appId: dotenv.get("APPID"),
      messagingSenderId: dotenv.get("MESSAGINGSENDERID"),
      projectId: dotenv.get("PROJECTID"),
    ));
  }
  await Firebase.initializeApp();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: LoginPage(),
    );
  }
}
