import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Habit {
  String id;
  String title;
  String description;
  String color;
  List<DateTime> completionDates;
  int iconCodePoint;

  Habit({
    String? id,
    required this.title,
    required this.color,
    required this.iconCodePoint,
    this.description = "",
    List<DateTime>? completionDates,
  }) : id = id ?? generateUniqueId(),
        completionDates = completionDates ?? [];

  bool isCompletedToday(){
    DateTime today = DateTime.now();
    return completionDates.any((date) => date.year == today.year && date.month == today.month && date.day == today.day);
  }

  IconData getIconData(){
    return IconData(iconCodePoint, fontFamily: "MaterialICons");
  }

  List<bool> getLastDaysCompletion(int numDays){
    DateTime today = DateTime.now();
    DateTime lastDaysStart = today.subtract(Duration(days: numDays));

    List<bool> completions = [];

    for (int i = 0; i < numDays; i++) {
      DateTime currentDate = lastDaysStart.add(Duration(days: i));
      bool isCompletedOnDate = completionDates.any((date) =>
      date.year == currentDate.year &&
          date.month == currentDate.month &&
          date.day == currentDate.day);
      completions.add(isCompletedOnDate);
    }

    return completions;
  }

  static String generateUniqueId() {
    Random random = Random();
    int randomNumber = random.nextInt(1000000);
    String uniqueId = "habit_$randomNumber";
    return uniqueId;
  }

  Map<String, dynamic> toJson() {
    return {
      'id' : id,
      'name': title,
      'description': description,
      'color': color,
      'iconCodePoint': iconCodePoint,
      'completionDates': completionDates.map((date) => date.toIso8601String()).toList(),
    };
  }

  factory Habit.fromJson(Map<String, dynamic> json) {
    var completionDatesList = json['completionDates']?.map<DateTime>((date) => DateTime.parse(date)).toList() ?? [];

    return Habit(
      id: json['id'],
      title: json['name'],
      description: json['description'],
      color: json['color'],
      iconCodePoint: json['iconCodePoint'],
      completionDates: completionDatesList,
    );
  }
}