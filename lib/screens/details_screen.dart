import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:vanespar/logic/habit.dart';
import 'package:vanespar/logic/habit_manager.dart';
import 'package:vanespar/screens/new_habit_screen.dart';

void onEditHabitPress(BuildContext context, Habit habit) {
  Navigator.pop(context);
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => NewHabitScreen.edit(habit)),
  );
}

void showDetailsDialog(BuildContext context, String habitId) {
  Habit habit = HabitManager.getHabitById(habitId);
  showDialog(
    context: context,
    builder: (context) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                width: 2,
                color: Color(habit.color)
              ),
              color: Colors.black
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        color: Color(habit.color)
                      ),
                      width: 40,
                      height: 40,
                      child: Icon(
                        habit.getIconData(),
                        color: Colors.white,
                      )
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        habit.title,
                        maxLines: 2,
                        style: const TextStyle(
                          overflow: TextOverflow.ellipsis,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: (){
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.close_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 10),
                  child: Text(
                    habit.description,
                    maxLines: 5,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      overflow: TextOverflow.ellipsis
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: (){ onEditHabitPress(context, habit); },
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                    )
                  ],
                )
              ],
            )
          ),
        )
      );
    },
  );
}