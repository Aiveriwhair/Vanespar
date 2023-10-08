import 'package:flutter/material.dart';
import 'package:vanespar/logic/habit.dart';
import 'package:vanespar/logic/habit_manager.dart';
import 'package:vanespar/screens/new_habit_screen.dart';
import 'package:vanespar/screens/parameters_screen.dart';
import 'package:vanespar/screens/stats_screen.dart';

import 'dart:ui';

import '../main.dart';


void onNewHabitPress(BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => const NewHabitScreen(),
    ),
  );
}

void onStatsPress(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const StatsScreen()),
  );
}
void onParameterPress(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const ParametersScreen()),
  );
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: CustomHeader(
          onNewHabitPress: () => onNewHabitPress(context),
          onStatsPress: () => onStatsPress(context),
          onParameterPress: () => onParameterPress(context),
        ),
      ),
      body: const MyStatefulListWidget(),
    );
  }
}

class CustomHeader extends StatelessWidget {
  final VoidCallback onNewHabitPress;
  final VoidCallback onStatsPress;
  final VoidCallback onParameterPress;

  const CustomHeader({
    super.key,
    required this.onNewHabitPress,
    required this.onStatsPress,
    required this.onParameterPress
  });

  @override
  Widget build(BuildContext context) {
    double iconSize = 25.0;

    return Container(
        height: 60,
        color: Colors.black,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(width: 10),
                  ShaderMask(
                    blendMode: BlendMode.srcIn,
                    shaderCallback: (Rect bounds) => LinearGradient(
                      stops: const [.3, .7],
                      colors: [
                        HexColor.fromHex("#DC8BFC"),
                        HexColor.fromHex("#84D4FF"),
                      ],
                    ).createShader(bounds),
                    child: IconButton(
                      icon: Icon(Icons.settings,
                          color: Colors.white, size: iconSize),
                      onPressed: onParameterPress,
                    ),
                  ),
                ],
              ),
              ShaderMask(
                blendMode: BlendMode.srcIn,
                shaderCallback: (Rect bounds) => LinearGradient(
                  stops: const [.3, .7],
                  colors: [
                    HexColor.fromHex("#84D4FF"),
                    HexColor.fromHex("#DC8BFC"),
                  ],
                ).createShader(bounds),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Vane',
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 29,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2),
                    ),
                    Text(
                      'spår',
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 29,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.leaderboard,
                        color: Colors.white, size: iconSize),
                    onPressed: onStatsPress,
                  ),
                  IconButton(
                    icon: Icon(Icons.add, color: Colors.white, size: iconSize),
                    onPressed: onNewHabitPress,
                  ),
                  const SizedBox(width: 10),
                ],
              ),
            ]));
  }
}

class MyListWidget extends StatelessWidget {
  const MyListWidget({super.key});

  Widget scaleUpDecorator(Widget child, int index, Animation<double> animation) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        final double animValue = Curves.easeInOut.transform(animation.value);
        final double elevation = lerpDouble(1, 6, animValue)!;
        final double scale = lerpDouble(1, 1.05, animValue)!;
        return Transform.scale(
          scale: scale,
          child: Card(
            margin: EdgeInsets.zero,
            elevation: elevation,
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {

    HabitManager habitManager = HabitManager();

    List<Widget> items = [];
    for(var habit in habitManager.getHabits()){
      items.add(
        CustomListItem(
          id: habit.id,
          title: habit.title,
          description: habit.description,
          isCompleted: habit.isCompletedToday(),
          iconData: habit.getIconData(),
          lastDaysCompletion: habit.getLastDaysCompletion(6),
          color: Color(habit.color),
        )
      );
    }
/*
    List<Widget> items = [
      CustomListItem(
        title: "Title",
        description: "Description",
        isCompleted: true,
        iconData: Icons.house,
        lastDaysCompletion: const [true, false, true, false, true, false],
        color: Colors.orange,
      ),
      CustomListItem(
        title: "Title",
        description: "Description",
        isCompleted: false,
        iconData: Icons.shower,
        lastDaysCompletion: const [true, false, false, false, true, true],
        color: Colors.blue,
      ),
      CustomListItem(
        title: "Title",
        description: "Description",
        isCompleted: true,
        iconData: Icons.bed,
        lastDaysCompletion: const [true, true, true, true, true, false],
        color: Colors.red,
      ),
    ];*/

    return Container(
        color: Colors.black,
        child: ReorderableListView(
          onReorder: (oldIndex, newIndex) => HabitManager.reorderHabit(oldIndex, newIndex),
          proxyDecorator: scaleUpDecorator,
          children: items,
        )
    );
  }
}

class CustomListItem extends StatefulWidget {
  String id;
  Color color;
  String title;
  String description;
  bool isCompleted;
  IconData iconData;
  List<bool> lastDaysCompletion;

  CustomListItem({
    super.key,
    required this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.iconData,
    required List<bool> lastDaysCompletion,
    required this.color,
  }) : lastDaysCompletion = [...lastDaysCompletion, isCompleted];

  @override
  State<CustomListItem> createState() => _CustomListItemState();
}

class _CustomListItemState extends State<CustomListItem> {

  void onItemTap(){}

  void onCompleteButtonPress(){
    setState(() {
      widget.isCompleted = !widget.isCompleted;
      widget.lastDaysCompletion.removeLast();
      widget.lastDaysCompletion.add(widget.isCompleted);
      HabitManager.setHabitLastDayCompletion(widget.id, widget.isCompleted);
    });
  }

  @override
  Widget build(BuildContext context) {

    return Container(
        color: Colors.black,
        padding: const EdgeInsets.fromLTRB(10, 2, 10, 2),
        child: Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                color: backGroundColor),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                            decoration: BoxDecoration(
                              borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                              color: widget.color,
                            ),
                            width: iconSize,
                            height: iconSize,
                            child: Icon(
                              widget.iconData,
                              color: Colors.white,
                            )),
                        const SizedBox(width: 5),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.title,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: titleSize
                                )),
                            Text(widget.description,
                                style: TextStyle(
                                    color: Colors.white,
                                  fontSize: descriptionSize
                                ))
                          ],
                        ),
                      ],
                    ),
                    Container(
                        decoration: BoxDecoration(
                          borderRadius:
                          const BorderRadius.all(Radius.circular(10)),
                          color: (widget.isCompleted ? widget.color : unselectedColor),
                        ),
                        width: iconSize,
                        height: iconSize,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          iconSize: 25,
                          icon: const Icon(Icons.check, color: Colors.white),
                          onPressed: onCompleteButtonPress,
                          style: const ButtonStyle(),
                        ))
                  ],
                ),
                Container(
                    width: 200,
                    height: 20,
                    padding: const EdgeInsets.all(5.0),
                    child: ListView.builder(
                      itemCount: widget.lastDaysCompletion.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        Color squareColor = widget.lastDaysCompletion[index]
                            ? widget.color
                            : unselectedColor;
                        return Container(
                          width: 10,
                          height: 10,
                          margin: const EdgeInsets.fromLTRB(5,0,5,0),
                          decoration: BoxDecoration(
                            borderRadius:
                            const BorderRadius.all(Radius.circular(3)),
                            color: squareColor,
                          ),
                        );
                      },
                    )
                )
              ],
            )));
  }

  // Colors
  final Color backGroundColor = HexColor.fromHex("#151515");
  final Color unselectedColor = HexColor.fromHex("#353535");

  // Sizes
  final double iconSize = 34;

  // Fonts
  final double titleSize = 24;
  final double descriptionSize = 12;
}

class MyStatefulListWidget extends StatefulWidget {
  const MyStatefulListWidget({ super.key });

  Widget scaleUpDecorator(Widget child, int index, Animation<double> animation) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        final double animValue = Curves.easeInOut.transform(animation.value);
        final double elevation = lerpDouble(1, 6, animValue)!;
        final double scale = lerpDouble(1, 1.05, animValue)!;
        return Transform.scale(
          scale: scale,
          child: Card(
            margin: EdgeInsets.zero,
            elevation: elevation,
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  @override
  State<MyStatefulListWidget> createState() => _MyStatefulListWidgetState();
}

class _MyStatefulListWidgetState extends State<MyStatefulListWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Column(children: [
        Expanded(
          child: StreamBuilder<List<Habit>>(
            stream: HabitManager.habitsStream, // Stream of habits
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // ReorderableListView with CustomListItem widgets
                return ReorderableListView(
                  onReorder: (oldIndex, newIndex) => HabitManager.reorderHabit(oldIndex, newIndex),
                  proxyDecorator: widget.scaleUpDecorator,
                  children: snapshot.data!.map((habit) => CustomListItem(
                    id: habit.id,
                    title: habit.title,
                    description: habit.description,
                    isCompleted: habit.isCompletedToday(),
                    iconData: habit.getIconData(),
                    lastDaysCompletion: habit.getLastDaysCompletion(6),
                    color: Color(habit.color),
                    key: ValueKey<String>(habit.id),
                  )).toList(),
                );
              } else if (snapshot.hasError) {
                // Handle error
                return Text('Error: ${snapshot.error}');
              } else {
                // Show loading indicator
                return const Center(child: CircularProgressIndicator());
              }
            },
          )
        ),
        IconButton(onPressed: addHabit, icon: const Icon(Icons.add, color: Colors.white, size: 50)),
      ])
    );
  }

  void addHabit() {
    HabitManager.addHabit(Habit(title: "Title2", color: Colors.orange.value, iconCodePoint: Icons.house.codePoint));
  }
  
}