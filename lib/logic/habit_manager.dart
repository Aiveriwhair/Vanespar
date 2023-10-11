import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'habit.dart';

class HabitManager {
  static List<Habit> habits = [];
  static late SharedPreferences _prefs;
  static final _habitsStreamController =
      StreamController<List<Habit>>.broadcast();
  static Stream<List<Habit>> get habitsStream => _habitsStreamController.stream;

  static void load() {
    _initSharedPreferences();
  }

  static Future<void> _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    _loadHabitsFromPrefs();
  }

  static void _loadHabitsFromPrefs() {
    List<String> habitsJson = _prefs.getStringList('habits') ?? [];
    List<Map<String, dynamic>> habitsData = List<Map<String, dynamic>>.from(
        habitsJson.map((habit) => json.decode(habit)).toList());
    habits = habitsData.map((habitData) => Habit.fromJson(habitData)).toList();
    _habitsStreamController.add(habits);
  }

  static Future<void> _saveHabitsToPrefs() async {
    List<String> habitsJsonList =
        habits.map((habit) => json.encode(habit.toJson())).toList();
    await _prefs.setStringList('habits', habitsJsonList);
    _habitsStreamController.add(habits);
  }

  static void addHabit(Habit habit) {
    habits.add(habit);
    _saveHabitsToPrefs();
  }

  static List<Habit> getHabits() {
    return habits;
  }

  static DateTime? getFirstCreatedHabitDay() {
    if (habits.isNotEmpty) {
      Habit? firstHabit = habits.reduce((current, next) {
        return current.creationDate.isBefore(next.creationDate) ? current : next;
      });

      return DateTime(
          firstHabit.creationDate.year,
          firstHabit.creationDate.month,
          firstHabit.creationDate.day);
    } else {
      return null;
    }
  }

  static List<Habit> getCompletableHabitsOnDay(DateTime day) {
    return habits.where((element) => element.isCompletableOnDay(day)).toList();
  }

  static List<Habit> getCompletedHabitsOnDay(DateTime day) {
    return habits.where((element) => element.completedOnDay(day)).toList();
  }
  static List<Habit> getNotCompletedHabitsOnDay(DateTime day) {
    return habits.where((element) => (!element.completedOnDay(day) && element.isCompletableOnDay(day))).toList();
  }

  static Habit getHabitById(String id) {
    return habits.firstWhere((habit) => habit.id == id);
  }

  static void reorderHabit(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    Habit habit = habits.removeAt(oldIndex);
    habits.insert(newIndex, habit);
    _habitsStreamController.add(habits);
    _saveHabitsToPrefs();
  }

  static void setHabitLastDayCompletion(String habitId, bool completed) {
    int index = habits.indexWhere((element) => element.id == habitId);
    if (habits[index].isCompletedToday() && !completed) {
      habits[index].completionDates.removeLast();
    } else if (!habits[index].isCompletedToday() && completed) {
      habits[index].completionDates.add(DateTime.now());
    }
    _saveHabitsToPrefs();
  }

  // Edit habit based on id
  static void editHabit(String id, String title, String description,
      String frequency, int colorValue, int iconPoint) {
    int index = habits.indexWhere((element) => element.id == id);
    habits[index].title = title;
    habits[index].description = description;
    habits[index].frequency = frequency;
    habits[index].color = colorValue;
    habits[index].iconCodePoint = iconPoint;
    _saveHabitsToPrefs();
  }

  static void deleteHabit(String id) {
    habits.removeWhere((habit) => habit.id == id);
    _saveHabitsToPrefs();
  }
}
