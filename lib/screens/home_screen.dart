import 'package:flutter/material.dart';

import '../main.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        children: <Widget>[
          CustomHeader(),
          Expanded(
            child: MyListWidget(),
          ),
        ],
      ),
    );
  }
}

class CustomHeader extends StatelessWidget {
  const CustomHeader({super.key});

  void onParameterPress(){
  }
  void onStatsPress(){
  }
  void onNewHabitPress(){

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
                      icon: Icon(Icons.settings, color: Colors.white, size: iconSize),
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
                    icon: Icon(Icons.leaderboard, color: Colors.white, size: iconSize),
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

  @override
  Widget build(BuildContext context) {
    List<Widget> items = [
    ];

    return ListView(
      children: items,
    );
  }
}

class CustomListItem extends StatelessWidget {
  final String title;
  final String description;
  final bool isCompleted;
  final Icon icon;
  final List<bool> lastDaysCompletion;

  const CustomListItem({super.key, required this.title, required this.description, required this.isCompleted, required this.icon, required this.lastDaysCompletion});

  void onItemTap(){
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      onTap: onItemTap,
    );
  }
}
