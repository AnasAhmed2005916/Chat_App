import 'package:chat_app/firebase_options.dart';
import 'package:chat_app/pages/chat_page.dart';
import 'package:chat_app/pages/login_page.dart';
import 'package:chat_app/pages/register_page.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(DevicePreview(builder: (context) => ScholarChat(), enabled: true));
}

class ScholarChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        'LoginPage': (context) => LoginPage(),
        'RegisterPage': (context) => RegisterPage(),
        'Chat': (context) =>ChatPage(),
      },
      debugShowCheckedModeBanner: false, // home: loginPage();
      initialRoute: 'LoginPage',
    );
  }
}


/*

خطوات اضافة ال firebase for project

🔹 1. تعمل Project جديد على Firebase Console

🔹 2. توصل Project Flutter بالـ Firebase باستخدام FlutterFire CLI
====> flutterfire configure ==> by this command 

🔹 3. تعمل Initialize لـ Firebase في main.dart

 */