import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'habit.dart';

class HabitManager {
  SharedPreferences _prefs;
  List<Habit> _habits = [];

  HabitManager() {
    _initSharedPreferences();
  }

  Future<void> _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    _loadHabitsFromPrefs();
  }

  // Charger les habitudes depuis les SharedPreferences
  void _loadHabitsFromPrefs() {
    String habitsJson = _prefs.getString('habits') ?? '[]';
    List<Map<String, dynamic>> habitsData =
        List<Map<String, dynamic>>.from(json.decode(habitsJson));
    _habits = habitsData.map((habitData) => Habit.fromJson(habitData)).toList();
  }

  // Enregistrer les habitudes dans les SharedPreferences
  Future<void> _saveHabitsToPrefs() async {
    List<String> habitsJsonList =
        _habits.map((habit) => json.encode(habit.toJson())).toList();
    await _prefs.setStringList('habits', habitsJsonList);
  }

  // Méthode pour ajouter une habitude
  void addHabit(Habit habit) {
    _habits.add(habit);
    _saveHabitsToPrefs();
  }

  // Méthode pour obtenir la liste actuelle des habitudes en mémoire
  List<Habit> getHabits() {
    return _habits;
  }
}
