import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'habit.dart';
import 'package:logger/logger.dart';

class HabitManager {
  static final Logger _logger = Logger();
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

    _logger.i('Shared Preferences initialized');
  }

  static void _loadHabitsFromPrefs() {
    List<String> habitsJson = _prefs.getStringList('habits') ?? [];
    List<Map<String, dynamic>> habitsData = List<Map<String, dynamic>>.from(
        habitsJson.map((habit) => json.decode(habit)).toList());
    habits = habitsData.map((habitData) => Habit.fromJson(habitData)).toList();
    _habitsStreamController.add(habits);

    _logger.i('Habits loaded from prefs: $habits');
  }

  static Future<void> _saveHabitsToPrefs() async {
    List<String> habitsJsonList =
        habits.map((habit) => json.encode(habit.toJson())).toList();
    await _prefs.setStringList('habits', habitsJsonList);
    _habitsStreamController.add(habits);

    _logger.i('Habits saved to prefs: $habits');
  }

  static void addHabit(Habit habit) {
    habits.add(habit);
    _saveHabitsToPrefs();

    _logger.i('Habit added: $habit');
  }

  static List<Habit> getHabits() {
    return habits;
  }

  static (List<Habit>, List<Habit>) getHabitsOnDay(DateTime day) {
    return (getCompletableHabitsOnDay(day), getNotCompletableHabitsOnDay(day));
  }

  static DateTime? getFirstCreatedHabitDay() {
    if (habits.isNotEmpty) {
      Habit? firstHabit = habits.reduce((current, next) {
        return current.creationDate.isBefore(next.creationDate)
            ? current
            : next;
      });

      return DateTime(firstHabit.creationDate.year,
          firstHabit.creationDate.month, firstHabit.creationDate.day);
    } else {
      return null;
    }
  }

  static List<Habit> getNotCompletableHabitsOnDay(DateTime day) {
    return habits.where((element) => !element.isCompletableOnDay(day)).toList();
  }

  static List<Habit> getCompletableHabitsOnDay(DateTime day) {
    return habits.where((element) => element.isCompletableOnDay(day)).toList();
  }

  static List<Habit> getCompletedHabitsOnDay(DateTime day) {
    return habits.where((element) => element.completedOnDay(day)).toList();
  }

  static List<Habit> getNotCompletedHabitsOnDay(DateTime day) {
    return habits
        .where((element) =>
            (!element.completedOnDay(day) && element.isCompletableOnDay(day)))
        .toList();
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

    _logger.i('Habit reordered: ${habits[newIndex]}');
  }

  static void setHabitLastDayCompletion(String habitId, bool completed) {
    int index = habits.indexWhere((element) => element.id == habitId);
    if (habits[index].isCompletedToday() && !completed) {
      habits[index].completionDates.removeLast();
    } else if (!habits[index].isCompletedToday() && completed) {
      habits[index].completionDates.add(DateTime.now());
    }
    _saveHabitsToPrefs();

    _logger.i('Habit last day completion set: ${habits[index]}');
  }

  static void setHabitCompletion(String habitId, bool completed, DateTime day) {
    int index = habits.indexWhere((element) => element.id == habitId);
    if (habits[index].isCompletedOnDay(day) && !completed) {
      habits[index].completionDates.removeWhere((element) =>
          element.year == day.year &&
          element.month == day.month &&
          element.day == day.day);
    } else if (!habits[index].isCompletedToday() && completed) {
      habits[index].completionDates.add(day);
    }
    _saveHabitsToPrefs();

    _logger.i('Habit completion set: ${habits[index]}');
  }

  // Edit habit based on id
  static void editHabit(String id, String title, String description,
      String frequency, int colorValue, int iconPoint, DateTime creationDate) {
    int index = habits.indexWhere((element) => element.id == id);
    habits[index].title = title;
    habits[index].description = description;
    habits[index].frequency = frequency;
    habits[index].color = colorValue;
    habits[index].iconCodePoint = iconPoint;
    habits[index].creationDate = creationDate;
    _saveHabitsToPrefs();
    _logger.i('Habit edited: ${habits[index]}');
  }

  static void deleteHabit(String id) {
    habits.removeWhere((habit) => habit.id == id);
    _saveHabitsToPrefs();
  }

  void logHabitManagerState() {
    _logger.i('HabitManager State: $habits');
  }
}
