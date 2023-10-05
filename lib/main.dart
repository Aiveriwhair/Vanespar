import 'package:flutter/material.dart';
import 'package:habkit/screens/home_screen.dart';
import 'package:habkit/screens/stats_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(MyApp(prefs: prefs));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required SharedPreferences prefs});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vanespår',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
      },
    );
  }
}