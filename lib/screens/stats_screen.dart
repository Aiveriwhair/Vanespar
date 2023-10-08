import 'package:flutter/material.dart';

class StatsScreen extends StatelessWidget{
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const HeaderWidget(),
      backgroundColor: Colors.black),
      body: const Column(
        children: <Widget>[
          HabitFilterWidget(),
          CalendarWidget()
        ],
      )
    );
  }
}

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      color: Colors.black,
      child: const Align(alignment: Alignment.centerLeft,
      child: Text("Stats"),
      )
    );
  }
}

class HabitFilterWidget extends StatefulWidget {
  const HabitFilterWidget({super.key});
  @override
  State<StatefulWidget> createState() => _HabitFilterWidgetState();
}
class _HabitFilterWidgetState extends State<HabitFilterWidget>{
  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }

}

class CalendarWidget extends StatefulWidget {
  const CalendarWidget({super.key});
  @override
  State<StatefulWidget> createState() =>_CalendarWidgetState();
}
class _CalendarWidgetState extends State<CalendarWidget> {
  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}