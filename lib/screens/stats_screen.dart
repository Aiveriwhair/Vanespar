import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:vanespar/logic/TimeUtils.dart';
import 'package:vanespar/logic/habit_manager.dart';

import '../main.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
            AppBar(title: const HeaderWidget(), backgroundColor: Colors.black),
        body: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(0.0),
          color: Colors.black,
          child: const Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              HabitFilterWidget(),
              CalendarWidget(),
            ],
          ),
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

class HabitFilterWidget extends StatefulWidget {
  const HabitFilterWidget({super.key});
  @override
  State<StatefulWidget> createState() => _HabitFilterWidgetState();
}

class _HabitFilterWidgetState extends State<HabitFilterWidget> {
  int selectedHabitIndex = 0;
  var habits = HabitManager.getHabits();
  var habitTitles = ["All", ...HabitManager.getHabits().map((e) => e.title)];

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
        child: DropdownButton<String>(
          hint: const Text("Select a habit"),
          value: habitTitles[selectedHabitIndex],
          style: TextStyle(color: Colors.black, fontSize: labelSize),
          dropdownColor: Colors.black,
          icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
          underline: Container(
            height: 2,
            color: Colors.white,
          ),
          onChanged: (value) => {
            setState(() {
              selectedHabitIndex = habitTitles.indexOf(value!);
            })
          },
          items: habitTitles.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: const TextStyle(color: Colors.white),
              ),
            );
          }).toList(),
        ));
  }

  final double labelSize = 16;
}

class CalendarWidget extends StatefulWidget {
  const CalendarWidget({super.key});
  @override
  State<StatefulWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  List<String> calendarView = [
    "Day",
    "Week",
    "Month",
  ];
  List<Widget> calendarWidgets = [
    DayCalendarWidget(),
    WeekCalendarWidget(),
    MonthCalendarWidget(),
  ];
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        height: 50,
        width: 225,
        padding: const EdgeInsets.all(5),
        alignment: Alignment.center,
        child: ListView.builder(
            itemCount: calendarView.length,
            scrollDirection: Axis.horizontal,
            itemExtent: 70,
            itemBuilder: (context, index) {
              return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                            width: 2,
                            color: (selectedIndex == index
                                ? Colors.white
                                : Colors.grey))),
                    child: Center(
                        child: Text(
                      calendarView[index],
                      style: TextStyle(
                          color: (selectedIndex == index
                              ? Colors.white
                              : Colors.grey)),
                    )),
                  ));
            }),
      ),
      calendarWidgets[selectedIndex]
    ]);
  }
}

class DayCalendarWidget extends StatefulWidget {
  const DayCalendarWidget({super.key});
  //final List<Habit> habits;
  @override
  DayCalendarWidgetState createState() => DayCalendarWidgetState();
}

class DayCalendarWidgetState extends State<DayCalendarWidget> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime firstDay = getFirstDayOfMonth(DateTime(1990, DateTime.november));
  DateTime lastDay = getLastDayOfMonth(DateTime.now());
  final StartingDayOfWeek _startDow =  StartingDayOfWeek.monday;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(child:
          TableCalendar(
              calendarFormat: _calendarFormat,
              focusedDay: _focusedDay,
              pageAnimationCurve: Curves.linear,
              onDaySelected: (selectedDay, focusedDay) {
                if (!isSameDay(_selectedDay, selectedDay)) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                }
              },
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
              onPageChanged: (focusedDay) {
                setState(() {
                  _focusedDay = focusedDay;
                });
              },
              startingDayOfWeek: _startDow,
              firstDay: firstDay,
              lastDay: lastDay,
              rowHeight: 60,
              calendarStyle: const CalendarStyle(
                outsideDaysVisible: false,
              ),
              daysOfWeekStyle : const DaysOfWeekStyle(
                  weekdayStyle: TextStyle(color: Colors.grey),
                  weekendStyle: TextStyle(color: Colors.grey),
              ),
              headerStyle: HeaderStyle(
                rightChevronVisible: ((DateTime.now().month == _focusedDay.month && DateTime.now().year == _focusedDay.year) ? false : true),
                formatButtonVisible: false,
                  formatButtonShowsNext: false,
                  titleCentered: false,
                  titleTextStyle: const TextStyle(color: Colors.white)),
              calendarBuilders:
                  CalendarBuilders(todayBuilder: (context, day, day2) {
                var habitsCompletable =
                    HabitManager.getCompletableHabitsOnDay(day);
                var habitsCompleted = HabitManager.getCompletedHabitsOnDay(day);
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
                          color: Color.lerp(
                              uncompleteColor, completeColor, lerpCoeff)!),
                    ));
              }, defaultBuilder: (context, day, day2) {
                var habitsCompletable =
                    HabitManager.getCompletableHabitsOnDay(day);
                var habitsCompleted = HabitManager.getCompletedHabitsOnDay(day);
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
                          color: Color.lerp(
                              uncompleteColor, completeColor, lerpCoeff)!),
                    ));
              })
          )
    );
  }
  final Color uncompleteColor = HexColor.fromHex("#353535");
  final Color completeColor = Colors.green;
}

class WeekCalendarWidget extends StatelessWidget {
  const WeekCalendarWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      color: Colors.blue,
    );
  }
}

class MonthCalendarWidget extends StatelessWidget {
  const MonthCalendarWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      color: Colors.yellow,
    );
  }
}
