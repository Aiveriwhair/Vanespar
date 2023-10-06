import 'dart:math';

class Habit {
  String id;
  String name;
  String description;
  String color;
  List<DateTime> completionDates;
  String icon;

  Habit({
    String? id,
    required this.name,
    required this.color,
    required this.icon,
    this.description = "",
    this.completionDates = const [],
  }) : id = id ?? generateUniqueId();

  static String generateUniqueId() {
    Random random = Random();
    int randomNumber = random.nextInt(1000000);
    String uniqueId = "habit_$randomNumber";
    return uniqueId;
  }

  Map<String, dynamic> toJson() {
    return {
      'id' : id,
      'name': name,
      'description': description,
      'color': color,
      'icon': icon,
      'completionDates': completionDates.map((date) => date.toIso8601String()).toList(),
    };
  }

  factory Habit.fromJson(Map<String, dynamic> json) {
    var completionDatesList = json['completionDates']?.map<DateTime>((date) => DateTime.parse(date)).toList() ?? [];

    return Habit(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      color: json['color'],
      icon: json['icon'],
      completionDates: completionDatesList,
    );
  }
}