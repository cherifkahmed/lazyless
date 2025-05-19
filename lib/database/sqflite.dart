import 'dart:async';



import 'package:lazyless/database/models/alarm_model.dart';
import 'package:lazyless/database/models/app_model.dart';
import 'package:lazyless/database/models/focus_model.dart';
import 'package:lazyless/database/models/habit_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper{
  final String databaseName = 'wisdom.db';
  String eventTable =
  "CREATE TABLE events(eventId INTEGER PRIMARY KEY AUTOINCREMENT, eventName TEXT , eventRemainder TEXT, createdAt TEXT DEFAULT CURRENT_TIMESTAMP)";
  String focusTable=
  "CREATE TABLE focus(focusId INTEGER PRIMARY KEY AUTOINCREMENT, pickedTime TEXT , focusTime TEXT , breakNumber INTEGER, createdAt TEXT DEFAULT CURRENT_TIMESTAMP)";
  String habitTable = 
  "CREATE TABLE habits(habitId INTEGER PRIMARY KEY AUTOINCREMENT, habitName TEXT,habitType TEXT, done INTEGER,createdAt TEXT DEFAULT CURRENT_TIMESTAMP)";
  String appInfoTable =
  "CREATE TABLE appinfo(appInfoId INTEGER PRIMARY KEY AUTOINCREMENT, appName TEXT, appPackageName TEXT, appIcon BLOB, timeSpent TEXT, createdAt TEXT DEFAULT CURRENT_TIMESTAMP)";
  String alarmTable =
  "CREATE TABLE alarms(habitId INTEGER PRIMARY KEY,alarmDays TEXT, alarmHour TEXT,alarmMinute TEXT, Foreign KEY(habitId) REFERENCES habits(habitId) ON DELETE CASCADE)";


  Future<Database> initDB() async{
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, databaseName);
    //await deleteDatabase(path);
    return await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute(eventTable);
      await db.execute(focusTable);
      await db.execute(habitTable);
      await db.execute(appInfoTable);
      await db.execute(alarmTable);
    });
  }







  //crud alarm
  Future<int> createAlarm(AlarmModel alarm) async {
        final db = await initDB();
        return await db.insert('alarms', alarm.toMap());
    }
  Future<List<AlarmModel>> readAlarm() async{
      final db = await initDB();
      List<Map<String, dynamic>> result = await db.query('alarms');
      return result.map((e)=> AlarmModel.fromMap(e)).toList();
    }

  Future<int> deleteAlarm(habitId) async{
      final db = await initDB();
      return db.delete('alarms', where: 'habitId = ?', whereArgs: [habitId]);
    }


  //CRUD FOCUS
  //CREATE FOCUS
  Future<int> createFocus(FocusModel focus) async {
      final db = await initDB();
      return await db.insert('focus', focus.toMap());
  }
  //READ EVENT
  Future<List<FocusModel>> readFocus() async{
    final db = await initDB();
    List<Map<String, dynamic>> result = await db.query('focus');
    return result.map((e)=> FocusModel.fromMap(e)).toList();
  }

  //CRUD HABIT
  //CREATE HABIT
    Future<int> createHabit(HabitModel habit) async {
        final db = await initDB();
        return await db.insert('habits', habit.toMap());
    }

  //READ HABIT
    Future<List<HabitModel>> readHabit() async{
      final db = await initDB();
      List<Map<String, dynamic>> result = await db.query('habits');
      return result.map((e)=> HabitModel.fromMap(e)).toList();
    }
  //DELETE HABIT
    Future<int> deleteHabit(habitId) async{
      final db = await initDB();
      return db.delete('habits', where: 'habitId = ?', whereArgs: [habitId]);
    }
  //UPDATE HABIT
  Future<int> updateHabit(done,habitId) async{
      final db = await initDB();
      return db.rawUpdate('UPDATE habits SET done = ? WHERE habitId = ?',
      [done ? 1 : 0,habitId]);
    }















  //CRUD APP INFO
    Future<int> createAppInfo(AppModel appInfo) async {
        final db = await initDB();
        return await db.insert('appinfo', appInfo.toMap());
    }
  //READ PP INFO
  Future<List<AppModel>> readAppInfo() async{
    final db = await initDB();
    List<Map<String, dynamic>> result = await db.query('appinfo');
    return result.map((e)=> AppModel.fromMap(e)).toList();
  }
  //DELETE HABIT
    Future<int> deleteAppInfo(appInfoId) async{
      final db = await initDB();
      return db.delete('appinfo', where: 'appInfoId = ?', whereArgs: [appInfoId]);
    }
  Future<int> updateAppInfo(timeSpent,appInfoId) async{
      final db = await initDB();
      return db.rawUpdate('UPDATE appinfo SET timeSpent = ? WHERE appInfoId = ?',
      [timeSpent,appInfoId]);
  }
  Future<List<AppModel>> readPackageName() async{
    final db = await initDB();
    List<Map<String, dynamic>> result = await db.query('appinfo');
    return result.map((e)=> AppModel.fromMap(e)).toList();
  }
  
}