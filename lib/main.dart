import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:timepunchtimesheet/screens/WelcomeScreen.dart';

import 'notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/':  (context) => WelcomeScreen(),
      }
    );
  }
}




