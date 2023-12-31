import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Habit {
  String id;
  String title;
  String description;
  String frequency;
  int color;
  List<DateTime> completionDates;
  int iconCodePoint;
  late DateTime creationDate;

  Habit({
    String? id,
    required this.title,
    required this.color,
    required this.iconCodePoint,
    this.frequency = "Daily",
    this.description = "",
    DateTime? creationDate,
    List<DateTime>? completionDates,
  })  : id = id ?? generateUniqueId(),
        completionDates = completionDates ?? [],
        creationDate = creationDate ?? DateTime.now();

  bool isCompletedToday() {
    DateTime today = DateTime.now();
    return completionDates.any((date) =>
        date.year == today.year &&
        date.month == today.month &&
        date.day == today.day);
  }
  bool isCompletedOnDay(DateTime day){
    return completionDates.any((element) => element.year == day.year &&
        element.month == day.month &&
        element.day == day.day);
  }

  IconData getIconData() {
    return IconData(iconCodePoint, fontFamily: "MaterialICons");
  }

  List<bool> getLastCompletions(int numDays) {
    DateTime today = DateTime.now();
    List<DateTime> completableDates = [];

    switch (frequency) {
      case "Daily":
        for (int i = 0; i < numDays; i++) {
          completableDates.add(today.subtract(Duration(days: i)));
        }
        break;
      case "Weekly":
        for (int i = 0; i < numDays; i++) {
          DateTime day = today.subtract(Duration(days: i));
          if (day.weekday == creationDate.weekday) {
            completableDates.add(day);
          }
        }
        break;
      case "Monthly":
        for (int i = 0; i < numDays; i++) {
          DateTime day = DateTime(today.year, today.month - i, today.day);
          if (day.day == creationDate.day) {
            completableDates.add(day);
          }
        }
        break;
      default:
        throw Exception("Invalid frequency");
    }

    List<bool> completions = completableDates.map((date) => isCompletedOnDay(date)).toList();
    return completions.reversed.toList();
  }

  bool completedOnDay(DateTime day) {
    return completionDates.any((element) =>
        element.year == day.year &&
        element.month == day.month &&
        element.day == day.day);
  }
  bool isCompletableOnDay(DateTime day) {
    if (day.isBefore(DateTime(creationDate.year, creationDate.month, creationDate.day))) {
      return false;
    }
    switch (frequency) {
      case "Daily":
        return true;
      case "Weekly":
        return day.weekday == creationDate.weekday;
      case "Monthly":
        return day.day == creationDate.day;
      default:
        return false;
    }
  }


  static String generateUniqueId() {
    Random random = Random();
    int randomNumber = random.nextInt(1000000);
    String uniqueId = "habit_$randomNumber";
    return uniqueId;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': title,
      'description': description,
      'color': color,
      'iconCodePoint': iconCodePoint,
      'creationDate' : creationDate.toIso8601String(),
      'completionDates':
          completionDates.map((date) => date.toIso8601String()).toList(),
    };
  }

  factory Habit.fromJson(Map<String, dynamic> json) {
    var completionDatesList = json['completionDates']
            ?.map<DateTime>((date) => DateTime.parse(date))
            .toList() ??
        [];
    var creationDate = DateTime.parse(json['creationDate']);

    return Habit(
      id: json['id'],
      title: json['name'],
      description: json['description'],
      color: json['color'],
      iconCodePoint: json['iconCodePoint'],
      creationDate: creationDate,
      completionDates: completionDatesList,
    );
  }
}