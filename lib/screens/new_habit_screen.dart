import 'package:flutter/material.dart';
import 'package:vanespar/logic/habit.dart';
import 'package:vanespar/logic/habit_manager.dart';

import '../main.dart';

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
final TextEditingController _titleController = TextEditingController();
final TextEditingController _descriptionController = TextEditingController();
String _selectedFrequency = 'Daily';
int _selectedColor = HexColor.fromHex("#D3D5AE").value;
int _selectedIcon = Icons.bed_rounded.codePoint;
bool _isEdit = false;
String _oldHabitId = "";

void onCompleteButtonPress(BuildContext context) {
  if (_formKey.currentState!.validate()) {
    String title = _titleController.text;
    String description = _descriptionController.text;
    String frequency = _selectedFrequency;
    int iconPoint = _selectedIcon;
    int colorValue = _selectedColor;

    if(!_isEdit) {
      // Create new Habit
      var newHabit = Habit(title: title, description: description, frequency: frequency, color: colorValue, iconCodePoint: iconPoint);
      // Add habit to SharedPreferences using HabitManager
      HabitManager.addHabit(newHabit);
    } else {
      HabitManager.editHabit(_oldHabitId, title, description, frequency, colorValue, iconPoint);
    }
    _titleController.text = "";
    _descriptionController.text = "";
    Navigator.pop(context);
  }
}

class NewHabitScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Header(),
        backgroundColor: Colors.black,
      ),
      body: Form(
        key: _formKey,
        child: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(30.0),
            color: Colors.black,
            child: Column(
              children: <Widget>[
                InputWidget(
                  controller: _titleController,
                  name: 'Title',
                ),
                InputWidget(
                  controller: _descriptionController,
                  name: 'Description',
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: DropDownButton(),
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(padding: EdgeInsets.all(5),
                    child:Text("Icon", style: TextStyle(color: Colors.white))),
                ),
                const Expanded(child:IconGrid()),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(padding: EdgeInsets.all(5),
                      child:Text("Color", style: TextStyle(color: Colors.white))),
                ),
                const Expanded(child: ColorGrid()),
              ],
            )),
      ),
    );
  }
  NewHabitScreen({super.key}) {
    _isEdit = false;
    _oldHabitId = "";
    _titleController.text = "";
    _descriptionController.text = "";
    _selectedFrequency = 'Daily';
    _selectedIcon = Icons.bed_rounded.codePoint;
    _selectedColor = HexColor.fromHex("#D3D5AE").value;
  }

  NewHabitScreen.edit(Habit habit, {super.key}) {
    _isEdit = true;
    _oldHabitId = habit.id;
    _titleController.text = habit.title;
    _descriptionController.text = habit.description;
    _selectedFrequency = habit.frequency;
    _selectedIcon = habit.iconCodePoint;
    _selectedColor = habit.color;
  }
}


class Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 60,
        color: Colors.black,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    _isEdit ? 'Edit ' : 'New ',
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: HexColor.fromHex("#DC8BFC"),
                        fontSize: 29,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2),
                  ),
                  Text(
                    'Habit',
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: HexColor.fromHex("#84D4FF"),
                        fontSize: 29,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.check_circle_outline_rounded,
                        color: Colors.white, size: iconSize),
                    onPressed: () => onCompleteButtonPress(context),
                  ),
                  const SizedBox(width: 10),
                ],
              ),
            ]));
  }
  const Header({super.key});
  final double iconSize = 30.0;
}

class InputWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
          child: TextFormField(
            controller: controller,
            focusNode: focusNode,
            cursorColor: Colors.white,
            style: TextStyle(color: Colors.white, fontSize: inputLabelSize),
            decoration: InputDecoration(
              labelText: name,
              labelStyle: TextStyle(
                color: Colors.white,
                fontSize: inputLabelSize,
              ),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }

  InputWidget({super.key, required this.name, required this.controller});
  FocusNode focusNode = FocusNode();
  final TextEditingController controller;
  final String name;

  // Colors
  final Color nameColor = Colors.white;
  // Sizes
  final double inputLabelSize = 20;
  final double inputTextSize = 16;
}


class DropDownButton extends StatefulWidget {
  const DropDownButton({super.key});
  @override
  State<StatefulWidget> createState() => DropDownButtonState();
}
class DropDownButtonState extends State<DropDownButton> {
  var dropdownValue = _selectedFrequency;
  List<String> frequencyList = <String>[
    'Daily',
    'Weekly',
    'Monthly',
    'Yearly'
  ];

  void onChanged(String? value) {
    setState(() {
      dropdownValue = value!;
      _selectedFrequency = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
        child: DropdownButton<String>(
          value: dropdownValue,
          style: TextStyle(color: Colors.black, fontSize: labelSize),
          dropdownColor: Colors.black,
          icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
          underline: Container(
            height: 2,
            color: Colors.white,
          ),
          onChanged: (value) => onChanged(value),
          items: frequencyList.map<DropdownMenuItem<String>>((String value) {
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

class IconGrid extends StatefulWidget {
  const IconGrid({super.key});
  @override
  State<StatefulWidget> createState() => _IconGridState();
}

class _IconGridState extends State<IconGrid> {
  List<IconData> icons = [
    Icons.bed_rounded,
    Icons.shower_rounded,
    Icons.phone_enabled_rounded,
    Icons.lunch_dining_rounded,
    Icons.wallet_rounded,
    Icons.directions_run_rounded,
    Icons.weekend_rounded,

    Icons.access_alarm_rounded,
    Icons.menu_book,
    Icons.add_a_photo_rounded,
    Icons.access_time_filled_rounded,
    Icons.calendar_month_rounded,
    Icons.work,
    Icons.house_rounded,

    Icons.draw_rounded,
    Icons.code_rounded,
    Icons.coffee_outlined,
    Icons.attach_money_rounded,
    Icons.apple_rounded,
    Icons.monitor_heart_rounded,
    Icons.music_note_rounded,
  ];


  @override
  Widget build(BuildContext context) {
    int selectedIndex = icons.indexWhere((element) => element.codePoint == _selectedIcon);

    return GridView.builder(
        itemCount: icons.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7),
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
                border: Border.all(width:2,color:  (selectedIndex == index ? Colors.white : Colors.black)),
                borderRadius: BorderRadius.circular(25)),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    selectedIndex = index;
                  });
                  _selectedIcon = icons[index].codePoint;
                },
                  child: Icon(icons[index], color: Colors.white,size: 30))
              );
        }
    );
  }
}

class ColorGrid extends StatefulWidget {
  const ColorGrid({super.key});

  @override
  State<StatefulWidget> createState() => _ColorGridState();
}

class _ColorGridState extends State<ColorGrid> {
  List<String> colorsHexs = [
    "#D3D5AE",
    "#A6BA92",
    "#76A07B",
    "#43866A",
    "#006C5E",

    "#9AC0B7",
    "#79A1A0",
    "#5D8289",
    "#446571",
    "#2F4858",
    "#B9BDDF",

    "#ABA1C6",
    "#9E84AA",
    "#92688C",
    "#854C6B",
    "#FFCCB2",
    "#FFDE87",
  ];

  @override
  Widget build(BuildContext context) {
    int selectedIndex = colorsHexs.indexWhere((element) => HexColor.fromHex(element).value == _selectedColor);
    return GridView.builder(
        itemCount: colorsHexs.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7),
        itemBuilder: (context, index) {
          return Container(
            width: 20,
            height: 20,
              decoration: BoxDecoration(
                  color: HexColor.fromHex(colorsHexs[index]),
                  border: Border.all(width:2, color:  (selectedIndex == index ? Colors.white : Colors.black)),
                  borderRadius: BorderRadius.circular(25)),
              child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                    });
                    _selectedColor = HexColor.fromHex(colorsHexs[index]).value;
                  },
          ));
        }
    );
  }
}
