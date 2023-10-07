import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'habit.dart';

class HabitManager {
  static List<Habit> habits = [];
  late SharedPreferences _prefs;

  HabitManager(){
    _initSharedPreferences();
  }

  Future<void> _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    _loadHabitsFromPrefs();
  }

  void _loadHabitsFromPrefs() {
    String habitsJson = _prefs.getString('habits') ?? '[]';
    List<Map<String, dynamic>> habitsData =
        List<Map<String, dynamic>>.from(json.decode(habitsJson));
    habits = habitsData.map((habitData) => Habit.fromJson(habitData)).toList();
  }

  Future<void> _saveHabitsToPrefs() async {
    List<String> habitsJsonList =
        habits.map((habit) => json.encode(habit.toJson())).toList();
    await _prefs.setStringList('habits', habitsJsonList);
  }

  void addHabit(Habit habit) {
    habits.add(habit);
    _saveHabitsToPrefs();
  }

  List<Habit> getHabits() {
    return habits;
  }

  void reorderHabit(int oldIndex, int newIndex) {

  }
}
