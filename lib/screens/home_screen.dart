import 'package:flutter/material.dart';
import 'package:vanespar/logic/habit.dart';
import 'package:vanespar/logic/habit_manager.dart';
import 'package:vanespar/screens/new_habit_screen.dart';
import 'package:vanespar/screens/stats_screen.dart';
import 'package:vanespar/screens/details_screen.dart';

import 'dart:ui';

import '../main.dart';

final Color appBlue = HexColor.fromHex("#84D4FF");
final Color appPink = HexColor.fromHex("#DC8BFC");


class HomeScreen extends StatefulWidget{
  const HomeScreen({super.key});
  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  bool seeAllHabits = false;

  void onNewHabitPress(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => NewHabitScreen(),
      ),
    );
  }

  void onStatsPress(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const StatsScreen()),
    );
  }

  void onCheckPress() {
    setState(() {
      seeAllHabits = !seeAllHabits;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: CustomHeader(
          onNewHabitPress: () => onNewHabitPress(context),
          onStatsPress: () => onStatsPress(context),
          onCheckPress: () => onCheckPress(),
        ),
      ),

      /// !!! Needs to take seeAllHabits as parameter !!!
      body: const MyStatefulListWidget(),
    );
  }
}

class CustomHeader extends StatefulWidget{
  const CustomHeader({super.key, required this.onNewHabitPress, required this.onStatsPress, required this.onCheckPress});
  final VoidCallback onNewHabitPress;
  final VoidCallback onStatsPress;
  final VoidCallback onCheckPress;
  @override
  State<StatefulWidget> createState() => _CustomHeaderState();
}
class _CustomHeaderState extends State<CustomHeader> {
  bool isChecked = false;

  Color getCheckboxColor(Set<MaterialState> states) {
    return isChecked ? appPink : appBlue;
  }

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
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: getCheckboxColor(<MaterialState>{}),
                    ),

                    child: Checkbox(
                      side: BorderSide(
                        color:  getCheckboxColor(<MaterialState>{}),
                        style: BorderStyle.none
                      ),
                      value: isChecked,
                      fillColor: MaterialStateProperty.resolveWith(getCheckboxColor),
                      checkColor: Colors.white,
                      onChanged: (bool? value) {
                        widget.onCheckPress();
                        setState(() {
                          isChecked = value ?? false;
                        });
                      },
                    ),
                  )
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
                    onPressed: widget.onStatsPress,
                  ),
                  IconButton(
                    icon: Icon(Icons.add, color: Colors.white, size: iconSize),
                    onPressed: widget.onNewHabitPress,
                  ),
                  const SizedBox(width: 10),
                ],
              ),
            ]));
  }
}

class MyListWidget extends StatelessWidget {
  const MyListWidget({super.key});

  Widget scaleUpDecorator(
      Widget child, int index, Animation<double> animation) {
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

    List<Widget> items = [];
    for (var habit in HabitManager.getHabits()) {
      items.add(CustomListItem(
        id: habit.id,
        title: habit.title,
        description: habit.description,
        isCompleted: habit.isCompletedToday(),
        iconData: habit.getIconData(),
        frequency: habit.frequency,
        lastDaysCompletion: habit.getLastDaysCompletion(6),
        color: Color(habit.color),
      ));
    }

    return Container(
        color: Colors.black,
        child: ReorderableListView(
          onReorder: (oldIndex, newIndex) =>
              HabitManager.reorderHabit(oldIndex, newIndex),
          proxyDecorator: scaleUpDecorator,
          children: items,
        ));
  }
}

class CustomListItem extends StatefulWidget {
  String id;
  Color color;
  String title;
  String description;
  bool isCompleted;
  String frequency;
  IconData iconData;
  List<bool> lastDaysCompletion;

  CustomListItem({
    super.key,
    required this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.iconData,
    required this.frequency,
    required List<bool> lastDaysCompletion,
    required this.color,
  }) : lastDaysCompletion = [...lastDaysCompletion, isCompleted];

  @override
  State<CustomListItem> createState() => _CustomListItemState();
}

class _CustomListItemState extends State<CustomListItem> {
  void onItemTap() {}

  void onCompleteButtonPress() {
    setState(() {
      widget.isCompleted = !widget.isCompleted;
      widget.lastDaysCompletion.removeLast();
      widget.lastDaysCompletion.add(widget.isCompleted);
      HabitManager.setHabitLastDayCompletion(widget.id, widget.isCompleted);
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showDetailsDialog(context, widget.id);
      },
      child: Container(
        color: Colors.black,
        padding: const EdgeInsets.fromLTRB(10, 4, 10, 4),
        child: Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                color: backGroundColor),
            child: Column(children: <Widget>[
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
                        )
                      ),
                      const SizedBox(width: 5),
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 150),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.title,
                                style: TextStyle(
                                    color: Colors.white, fontSize: titleSize)),
                            Text(widget.description,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: descriptionSize))
                          ],
                        ),
                      )
                    ],
                  ),
                  Container(
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        color: (widget.isCompleted
                            ? widget.color
                            : unselectedColor),
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
                height: 20,
                padding: const EdgeInsets.all(5.0),
                margin: const EdgeInsets.only(top: 10),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.lastDaysCompletion.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    Color squareColor = widget.lastDaysCompletion[index]
                        ? widget.color
                        : unselectedColor;
                    return Container(
                      width: 10,
                      height: 10,
                      margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(3)),
                        color: squareColor,
                      ),
                    );
                  },
                ),
              )
            ]
          )
        )
      )
    );
  }

  // Colors
  final Color backGroundColor = HexColor.fromHex("#151515");
  final Color unselectedColor = HexColor.fromHex("#353535");

  // Sizes
  final double iconSize = 40;

  // Fonts
  final double titleSize = 24;
  final double descriptionSize = 12;
}

class MyStatefulListWidget extends StatefulWidget {
  const MyStatefulListWidget({super.key});

  Widget scaleUpDecorator(
      Widget child, int index, Animation<double> animation) {
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
      child: StreamBuilder<List<Habit>>(
        stream: HabitManager.habitsStream, // Stream of habits
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // ReorderableListView with CustomListItem widgets
            return ReorderableListView(
              onReorder: (oldIndex, newIndex) =>
                  HabitManager.reorderHabit(oldIndex, newIndex),
              proxyDecorator: widget.scaleUpDecorator,
              children: snapshot.data!
                  .map((habit) => CustomListItem(
                        id: habit.id,
                        title: habit.title,
                        description: habit.description,
                        isCompleted: habit.isCompletedToday(),
                        iconData: habit.getIconData(),
                        lastDaysCompletion: habit.getLastDaysCompletion(6),
                        color: Color(habit.color),
                        frequency: habit.frequency,
                        key: ValueKey<String>(habit.id),
                      ))
                  .toList(),
            );
          } else if (snapshot.hasError) {
            // Handle error
            return Text('Error: ${snapshot.error}');
          } else {
            // Show loading indicator
            return const Center(child: CircularProgressIndicator());
          }
        }
      )
    );
  }

  void addHabit() {
    HabitManager.addHabit(Habit(
        title: "Title2",
        color: Colors.orange.value,
        iconCodePoint: Icons.house.codePoint));
  }
}
