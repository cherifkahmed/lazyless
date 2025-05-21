import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lazyless/database/models/habit_model.dart';
import 'package:lazyless/database/sqflite.dart';
import 'package:lazyless/screens/user/daily_habit/habit_picker.dart';

class HabitScreen extends StatefulWidget {
  const HabitScreen({super.key});

  @override
  State<HabitScreen> createState() => _HabitScreenState();
}

class _HabitScreenState extends State<HabitScreen> {
  final db = DatabaseHelper();

  List<HabitModel> habitList = [];
  void _updateMyItems(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) newIndex -= 1;
      final item = habitList.removeAt(oldIndex);
      habitList.insert(newIndex, item);
    });
  }

  @override
  void initState() {
    super.initState();
    _refresh();
    db.initDB().whenComplete(() async {
      final data = await db.readHabit();
      setState(() {
        habitList = data;
      });
    });
  }

  //Refresh method
  Future<void> _refresh() async {
    final data = await db.readHabit();
    setState(() {
      habitList = data;
    });
  }

  Color _dependOnType(String type) {
    if (type == "Bad") {
      return Colors.red[200]!;
    }
    if (type == "Good") {
      return Colors.green[200]!;
    }
    return Colors.grey[200]!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        onPressed: () {
          
          Navigator.push(context, MaterialPageRoute(builder:(context)=> HabitPicker())).then((result){
            if (result == true) {
              setState(() {
                _refresh();
              });
            }
          });
        },
        child: Icon(Icons.add),
      ),
      body: ReorderableListView(
        children: [
          for (final item in habitList)
            ListTile(
              key: ValueKey(item.habitId),
              title: Text(item.habitName),
              subtitle: Text(item.habitType),
              tileColor: _dependOnType(item.habitType),
              leading: IconButton(
                onPressed: () {
                  setState(() {
                    item.done = !item.done;
                  });
                  db.updateHabit(item.done, item.habitId);
                },
                icon: Icon(
                  item.done ? Icons.check_box : Icons.check_box_outline_blank,
                  color: item.done ? Colors.green : Colors.grey,
                ),
              ),
              trailing: IconButton(
                onPressed: () {
                  db.deleteHabit(item.habitId).whenComplete(() {
                    _refresh();
                  });
                  db.deleteAlarm(item.habitId);
                },
                icon: Icon(Icons.delete_forever),
              ),
            ),
        ],
        onReorder: (oldIndex, newIndex) {
          setState(() {
            _updateMyItems(oldIndex, newIndex);
          });
        },
      ),
    );
  }
}
