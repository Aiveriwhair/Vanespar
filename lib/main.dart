import 'package:flutter/material.dart';
import 'package:vanespar/logic/habit_manager.dart';
import 'package:vanespar/screens/home_screen.dart';

void main() => runApp(const SafeArea(child: MyApp()));

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    HabitManager.load();
    return const MaterialApp(
        debugShowCheckedModeBanner: false,
      home: HomeScreen()
    );
  }
}

