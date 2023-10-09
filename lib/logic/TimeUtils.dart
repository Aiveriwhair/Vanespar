import 'dart:ui';

import 'package:table_calendar/table_calendar.dart';
import 'package:vanespar/logic/habit_manager.dart';

/*
Color getHabitColorOnDayUsingLerp(String habitID, Color uncompleteColor, DateTime day){
  var habit = HabitManager.getHabits().where((element) => element.id == habitID);
}
*/

int getNumberLastDayOfMonth(DateTime month) {
  DateTime firstDayOfNextMonth = DateTime(month.year, month.month + 1, 1);
  DateTime lastDayOfMonth = firstDayOfNextMonth.subtract(const Duration(days: 1));
  return lastDayOfMonth.day;
}

DateTime getFirstDayOfMonth(DateTime month) {
  return DateTime(month.year, month.month);
}

DateTime getLastDayOfMonth(DateTime month){
  DateTime firstDayOfNextMonth = DateTime(month.year, month.month + 1, 1);
  DateTime lastDayOfMonth = firstDayOfNextMonth.subtract(const Duration(days: 1));
  return lastDayOfMonth;
}

StartingDayOfWeek getStartingDayOfMonth(DateTime month) {
  DateTime firstDayOfMonth = DateTime(month.year, month.month, 1);
  int startingDayOfWeek = firstDayOfMonth.weekday;

  switch (startingDayOfWeek) {
    case 1:
      return StartingDayOfWeek.monday;
    case 2:
      return StartingDayOfWeek.tuesday;
    case 3:
      return StartingDayOfWeek.wednesday;
    case 4:
      return StartingDayOfWeek.thursday;
    case 5:
      return StartingDayOfWeek.friday;
    case 6:
      return StartingDayOfWeek.saturday;
    case 7:
      return StartingDayOfWeek.sunday;
    default:
      throw Exception('Invalid');
  }
}