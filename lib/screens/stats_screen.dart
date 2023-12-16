import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:vanespar/logic/TimeUtils.dart';
import 'package:vanespar/logic/habit_manager.dart';

import '../logic/habit.dart';
import 'package:vanespar/assets/colors.dart' as app_colors;

//////////////////////////////////////////////////////////////////////// CONSTANTS
final Color uncompleteColor = app_colors.HexColor.fromHex("#353535");
const Color completeColor = Colors.yellow;
const double labelSize = 16.0;

////////////////////////////////////////////////////////////////////////

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});
  @override
  State<StatefulWidget> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  void refresh() {
    setState(() {});
  }

  ////////////////// HABIT SELECTION STATES
  int habitSelectedIndex = 0;
  List<String> habitTitles = [
    "All",
    ...HabitManager.getHabits().map((e) => e.title)
  ];

  ////////////////// CALENDAR STATES
  List<Habit> calendarHabits = HabitManager.getHabits();
  DateTime selectedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
            AppBar(title: const HeaderWidget(), backgroundColor: Colors.black),
        body: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(0.0),
          color: Colors.black,
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                    child: DropdownButton<String>(
                      hint: const Text("Select a habit"),
                      value: habitTitles[habitSelectedIndex],
                      style: const TextStyle(
                          color: Colors.black, fontSize: labelSize),
                      dropdownColor: Colors.black,
                      icon: const Icon(Icons.arrow_drop_down,
                          color: Colors.white),
                      underline: Container(
                        height: 2,
                        color: Colors.white,
                      ),
                      onChanged: (value) => {
                        setState(() {
                          habitSelectedIndex = habitTitles.indexOf(value!);
                          if (habitSelectedIndex == 0) {
                            calendarHabits = HabitManager.getHabits();
                          } else {
                            calendarHabits = [
                              HabitManager.getHabits()[habitSelectedIndex - 1]
                            ];
                          }
                        })
                      },
                      items: habitTitles
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value.length >= 10
                                ? "${value.substring(0, 9)}..."
                                : value,
                            style: const TextStyle(color: Colors.white),
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                    )),
              ],
            ),
            DayCalendarWidget(
                habits: calendarHabits,
                updateSelectedDay: (DateTime newSelectedDay) {
                  setState(() {
                    selectedDay = newSelectedDay;
                  });
                }),
            Expanded(
                child: HabitListWidget(
              selectedDay: selectedDay,
              refresh: refresh,
            ))
          ]),
        ));
  }
}

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 60,
        color: Colors.black,
        child: const Align(
          alignment: Alignment.centerLeft,
          child: Text("Stats"),
        ));
  }
}

class DayCalendarWidget extends StatefulWidget {
  final List<Habit> habits;
  final Function(DateTime) updateSelectedDay;
  const DayCalendarWidget(
      {super.key, required this.habits, required this.updateSelectedDay});
  @override
  State<StatefulWidget> createState() => _DayCalendarWidgetState();
}

class _DayCalendarWidgetState extends State<DayCalendarWidget> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime firstDay = getFirstDayOfMonth(
      HabitManager.getFirstCreatedHabitDay() ?? DateTime.now());
  DateTime lastDay = getLastDayOfMonth(DateTime.now());

  @override
  Widget build(BuildContext context) {
    bool isLeftChevronVisible() {
      DateTime firstDayOfNextMonth =
          DateTime(firstDay.year, firstDay.month + 1, 1);
      return _focusedDay.isAfter(firstDayOfNextMonth) ||
          _focusedDay.isAtSameMomentAs(firstDayOfNextMonth);
    }

    bool isRightChevronVisible() {
      return _focusedDay.month < DateTime.now().month ||
          _focusedDay.year < DateTime.now().year;
    }

    return SingleChildScrollView(
        child: TableCalendar(
            focusedDay: _focusedDay,
            pageAnimationCurve: Curves.linear,
            onDaySelected: (selectedDay, focusedDay) {
              if (!isSameDay(_selectedDay, selectedDay)) {
                setState(() {
                  widget.updateSelectedDay(selectedDay);
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              }
            },
            onPageChanged: (focusedDay) {
              setState(() {
                _focusedDay = focusedDay;
              });
            },
            startingDayOfWeek: StartingDayOfWeek.monday,
            firstDay: firstDay,
            lastDay: lastDay,
            calendarStyle: const CalendarStyle(
              outsideDaysVisible: false,
            ),
            daysOfWeekStyle: const DaysOfWeekStyle(
              weekdayStyle: TextStyle(color: Colors.grey),
              weekendStyle: TextStyle(color: Colors.grey),
            ),
            rowHeight: 60,
            headerStyle: HeaderStyle(
                leftChevronVisible: true,
                rightChevronVisible: true,
                leftChevronIcon: Icon(Icons.chevron_left,
                    color: isLeftChevronVisible() ? Colors.white : Colors.grey,
                    size: 30),
                rightChevronIcon: Icon(Icons.chevron_right,
                    color: isRightChevronVisible() ? Colors.white : Colors.grey,
                    size: 30),
                formatButtonVisible: false,
                formatButtonShowsNext: false,
                titleCentered: false,
                titleTextStyle: const TextStyle(color: Colors.white)),
            calendarBuilders:
                CalendarBuilders(todayBuilder: (context, day, day2) {
              Color fullColor = Color(widget.habits[0].color);
              var habitsCompletable =
                  widget.habits.where((e) => e.isCompletableOnDay(day));
              var habitsCompleted =
                  widget.habits.where((e) => e.isCompletedOnDay(day));
              double lerpCoeff = 0;
              if (habitsCompletable.isNotEmpty) {
                lerpCoeff = habitsCompleted.length.toDouble() /
                    habitsCompletable.length.toDouble();
              }
              return Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(width: 2, color: Colors.grey),
                        color:
                            Color.lerp(uncompleteColor, fullColor, lerpCoeff)!),
                  ));
            }, defaultBuilder: (context, day, day2) {
              Color fullColor = Color(widget.habits[0].color);
              var habitsCompletable =
                  widget.habits.where((e) => e.isCompletableOnDay(day));
              var habitsCompleted =
                  widget.habits.where((e) => e.isCompletedOnDay(day));
              double lerpCoeff = 0;
              if (habitsCompletable.isNotEmpty) {
                lerpCoeff = habitsCompleted.length.toDouble() /
                    habitsCompletable.length.toDouble();
              }
              return Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color:
                            Color.lerp(uncompleteColor, fullColor, lerpCoeff)!),
                  ));
            })));
  }
}

class HabitListWidget extends StatefulWidget {
  DateTime selectedDay;
  final Function refresh;
  HabitListWidget(
      {super.key, required this.selectedDay, required this.refresh});
  @override
  State<StatefulWidget> createState() => _HabitListWidgetState();
}

class _HabitListWidgetState extends State<HabitListWidget> {
  @override
  Widget build(BuildContext context) {
    var notCompletedHabits =
        HabitManager.getNotCompletedHabitsOnDay(widget.selectedDay);
    var completedHabits =
        HabitManager.getCompletedHabitsOnDay(widget.selectedDay);
    return Row(children: [
      Expanded(
          child: ListView.builder(
        itemCount: completedHabits.length,
        itemBuilder: (BuildContext context, int index) {
          Habit habit = completedHabits[index];
          return ListTile(
            onTap: () {
              HabitManager.setHabitCompletion(
                  habit.id,
                  !habit.isCompletedOnDay(widget.selectedDay),
                  widget.selectedDay);
              widget.refresh();
            },
            leading: Icon(
              IconData(habit.iconCodePoint, fontFamily: 'MaterialIcons'),
              color: Colors.white,
            ),
            title: Container(
                alignment: Alignment.centerLeft,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Text(
                  habit.title,
                  style: const TextStyle(color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                )),
          );
        },
      )),
      Container(
        width: 1,
        color: Colors.grey,
      ),
      Expanded(
          child: ListView.builder(
        itemCount: notCompletedHabits.length,
        itemBuilder: (BuildContext context, int index) {
          Habit habit = notCompletedHabits[index];
          return ListTile(
            onTap: () {
              HabitManager.setHabitCompletion(
                  habit.id,
                  !habit.isCompletedOnDay(widget.selectedDay),
                  widget.selectedDay);
              widget.refresh();
            },
            leading: Icon(
              IconData(habit.iconCodePoint, fontFamily: 'MaterialIcons'),
              color: Colors.red,
            ),
            title: Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Text(
                  habit.title,
                  style: const TextStyle(color: Colors.red),
                  overflow: TextOverflow.ellipsis,
                )),
          );
        },
      )),
    ]);
  }
}
