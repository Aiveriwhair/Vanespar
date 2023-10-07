import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'habit.dart';

class HabitManager {
  static List<Habit> habits = [];
  late SharedPreferences _prefs;
  final _habitsStreamController = StreamController<List<Habit>>.broadcast();
  Stream<List<Habit>> get habitsStream => _habitsStreamController.stream;

  HabitManager(){
    _initSharedPreferences();
  }

  Future<void> _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    _loadHabitsFromPrefs();
  }

  void _loadHabitsFromPrefs() {
    List<String> habitsJson = _prefs.getStringList('habits') ?? [];
    List<Map<String, dynamic>> habitsData = List<Map<String, dynamic>>.from(habitsJson.map((habit) => json.decode(habit)).toList());
    habits = habitsData.map((habitData) => Habit.fromJson(habitData)).toList();
    _habitsStreamController.add(habits);
  }

  Future<void> _saveHabitsToPrefs() async {
    List<String> habitsJsonList =
        habits.map((habit) => json.encode(habit.toJson())).toList();
    await _prefs.setStringList('habits', habitsJsonList);
    _habitsStreamController.add(habits);
  }

  void addHabit(Habit habit) {
    habits.add(habit);
    _saveHabitsToPrefs();
  }

  List<Habit> getHabits() {
    return habits;
  }

  void reorderHabit(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    Habit habit = habits.removeAt(oldIndex);
    habits.insert(newIndex, habit);
    _saveHabitsToPrefs();
  }
}
