import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:lazyless/database/models/alarm_model.dart';
import 'package:lazyless/database/models/habit_model.dart';
import 'package:lazyless/database/sqflite.dart';
import 'package:lazyless/services/noti_service.dart';

class HabitPicker extends StatefulWidget {
  const HabitPicker({super.key});

  @override
  State<HabitPicker> createState() => _HabitPickerState();
}

class _HabitPickerState extends State<HabitPicker> {
  final TextEditingController _controllerHabit = TextEditingController();
  final TextEditingController _controllerHours = TextEditingController();
  final TextEditingController _controllerMinuts = TextEditingController();
  bool isAm = true;
  String habitType = '';
  final db = DatabaseHelper();
  bool didPop = false;

  //initial state of the page
  @override
  void initState() {
    super.initState();

    _controllerHours.addListener(() {
      final text = _controllerHours.text;

      if (text.isNotEmpty) {
        final value = int.tryParse(text);
        if (value != null && value > 12) {
          // Truncate the input if it exceeds 12
          _controllerHours.text = '12';
          _controllerHours.selection = TextSelection.fromPosition(
            TextPosition(offset: _controllerHours.text.length),
          );
        }
      }
    });
    _controllerMinuts.addListener(() {
      final text = _controllerMinuts.text;

      if (text.isNotEmpty) {
        final value = int.tryParse(text);
        if (value != null && value > 59) {
          // Truncate the input if it exceeds 59
          _controllerMinuts.text = '59';
          _controllerMinuts.selection = TextSelection.fromPosition(
            TextPosition(offset: _controllerMinuts.text.length),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Stack(
                children: [
                  //image
                  Container(
                    width: screenWidth,
                    height: screenHeight * .35,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('lib/assets/images/habit-loop.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: screenHeight * .01),
              // ignore: sized_box_for_whitespace
              //create habit textfield
              Container(
                width: screenWidth * 0.9,
                child: TextField(
                  controller: _controllerHabit,
                  decoration: InputDecoration(
                    labelText: 'Create Custom Habit',
                    hintText: 'What habit you want to track',
                    prefixIcon: Icon(Icons.push_pin),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),

                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                ),
              ),
              SizedBox(height: screenHeight * .01),
              // habit type
              Row(
                children: [
                  SizedBox(width: screenWidth * 0.1),
                  // * for good habit
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        habitType = 'Good';
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          habitType == 'Good' ? Colors.deepOrange : null,
                    ),
                    label: Text('Good'),
                    icon: Icon(Icons.eco),
                  ),
                  SizedBox(width: screenWidth * 0.01),
                  //* for natural habit
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        habitType = 'Natural';
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          habitType == 'Natural' ? Colors.deepOrange : null,
                    ),
                    label: Text('Natural'),
                    icon: Icon(Icons.autorenew),
                  ),
                  SizedBox(width: screenWidth * 0.01),
                  //* for bad habit
                  ElevatedButton.icon(
                    /*  */
                    onPressed: () {
                      setState(() {
                        habitType = 'Bad';
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          habitType == 'Bad' ? Colors.deepOrange : null,
                    ),
                    label: Text('Bad'),
                    icon: Icon(Icons.sentiment_dissatisfied),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.01),
              Text(
                'Create a remainder for this habit?',
                style: TextStyle(fontSize: screenHeight * 0.02),
              ),

              // days of the week
              SizedBox(height: screenHeight * 0.01),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: screenWidth * .05),
                  //hour textfield
                  Container(
                    width: screenWidth * .15,
                    height: screenHeight * .07,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: TextField(
                      controller: _controllerHours,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: '   hh',
                        border: InputBorder.none,
                      ),
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  Text(':', style: TextStyle(fontSize: 40)),
                  //minute textfield
                  Container(
                    width: screenWidth * .15,
                    height: screenHeight * .07,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: TextField(
                      controller: _controllerMinuts,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: '   mm',
                        border: InputBorder.none,
                      ),
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  SizedBox(width: screenWidth * .05),
                  Column(
                    children: [
                      // AM button
                      Container(
                        decoration: BoxDecoration(
                          color: isAm ? Colors.blue : null,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              isAm = true;
                            });
                          },
                          child: Text('AM', style: TextStyle(fontSize: 25)),
                        ),
                      ),
                      // PM button
                      Container(
                        decoration: BoxDecoration(
                          color: isAm == false ? Colors.orange : null,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              isAm = false;
                            });
                          },
                          child: Text('PM', style: TextStyle(fontSize: 25)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              //add habit button
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    colors: [Colors.deepOrange, Colors.blue],
                  ),
                ),

                child: ElevatedButton(
                  onPressed: () async {
                    final habitId = await db.createHabit(
                      HabitModel(
                        habitName: _controllerHabit.text,
                        habitType: habitType,
                        done: false,
                      ),
                    );
                    final alarm = await db.createAlarm(
                      AlarmModel(
                        habitId: habitId,
                        alarmHour: _controllerHours.text,
                        alarmMinute: _controllerMinuts.text,
                      ),
                    );
                    print('${habitId}+${alarm}');
                    print("Navigating to /habit_screen");
                    //Navigator.pushNamed(context, '/habit_screen');
                    Navigator.pop(context, true);
                    final now = DateTime.now();
                    AndroidAlarmManager.periodic(
                      Duration(days: 1),
                      alarm,
                      fireAlarm,
                      startAt: DateTime(
                        now.year,
                        now.month,
                        now.day,
                        int.parse(_controllerHours.text),
                        int.parse(_controllerMinuts.text),
                      ),
                      allowWhileIdle: true,
                      exact: true,
                      wakeup: true,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                  ),
                  child: Text(
                    'Add habit',
                    style: TextStyle(
                      fontSize: screenHeight * .02,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

@pragma('vm:entry-point')
void fireAlarm() {
  print('Alarm Fired at ${DateTime.now()}');
  NotiService.showNotification(
    title: "Lazyless",
    body: "Check your Daily Routine",
    payload: "payload",
  );
}
