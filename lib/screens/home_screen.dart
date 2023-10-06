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

  void onParameterPress() {}
  void onStatsPress() {}
  void onNewHabitPress() {}

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

  @override
  Widget build(BuildContext context) {
    IconData someIconData = Icons.house_rounded;

    List<Widget> items = [
      CustomListItem(
        title: "Title",
        description: "Description",
        isCompleted: false,
        iconData: someIconData,
        lastDaysCompletion: const [true, false, true, false, true, false],
        color: Colors.orange,
      ),
      CustomListItem(
        title: "Title",
        description: "Description",
        isCompleted: false,
        iconData: someIconData,
        lastDaysCompletion: const [true, false, true, false, true, false],
        color: Colors.blue,
      ),
      CustomListItem(
        title: "Title",
        description: "Description",
        isCompleted: false,
        iconData: someIconData,
        lastDaysCompletion: const [true, false, true, false, true, false],
        color: Colors.red,
      ),
    ];

    return Container(
      color: Colors.black, child: ListView(children: items)
    );
  }
}

class CustomListItem extends StatelessWidget {
  final Color color;
  final String title;
  final String description;
  final bool isCompleted;
  final IconData iconData;
  List<bool> lastDaysCompletion;

  CustomListItem({
    Key? key,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.iconData,
    required List<bool> lastDaysCompletion,
    required this.color,
  }) : lastDaysCompletion = [...lastDaysCompletion, isCompleted],
        super(key: key);

  void onItemTap() {}
  void onCompleteButtonPress() {}

  @override
  Widget build(BuildContext context) {

    double iconSize = 34;

    Color backGroundColor = HexColor.fromHex("#151515");
    Color unselectedColor = HexColor.fromHex("#353535");

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
                              color: color,
                            ),
                            width: iconSize,
                            height: iconSize,
                            child: Icon(
                              iconData,
                              color: Colors.white,
                            )),
                        const SizedBox(width: 5),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(title,
                                style: const TextStyle(color: Colors.white)),
                            Text(description,
                                style: const TextStyle(color: Colors.white))
                          ],
                        ),
                      ],
                    ),
                    Container(
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          color: color,
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
                        itemCount: lastDaysCompletion.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          Color squareColor = lastDaysCompletion[index]
                              ? color
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
}
