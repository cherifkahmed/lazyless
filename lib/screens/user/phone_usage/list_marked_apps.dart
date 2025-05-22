import 'package:app_usage/app_usage.dart';
import 'package:flutter/material.dart';
import 'package:lazyless/database/models/app_model.dart';
import 'package:lazyless/database/sqflite.dart';

class ListMarkedApps extends StatefulWidget {
  const ListMarkedApps({super.key});

  @override
  State<ListMarkedApps> createState() => _ListMarkedAppsState();
}

class _ListMarkedAppsState extends State<ListMarkedApps> {

  final db = DatabaseHelper();
  List<AppUsageInfo> _infos = [];
  //String timeSpent='';

  Future<void> getUsageStats() async {
    try {
      DateTime now = DateTime.now();
      DateTime endDate = DateTime.now();
      DateTime startDate =   DateTime(now.year, now.month, now.day,0,0);
      List<AppUsageInfo> infoList = await AppUsage().getAppUsage(startDate, endDate);
      setState(() => _infos = infoList);
    } catch (exception) {
      print(exception);
    }
  }


  Future<void> realTimeUsage(String targetPackageName) async {
    // 1. Refresh usage info first
    await getUsageStats(); // ⬅️ Populate `_infos`

    // 2. Get the matching usage info
    AppUsageInfo? usageInfo = _infos.firstWhere(
      (info) => info.packageName == targetPackageName,
      orElse: () => AppUsageInfo(targetPackageName, 0, DateTime.now(), DateTime.now(), DateTime.now()),
    );

    // 3. Format time spent as string
    String timeSpent = usageInfo.usage.toString(); // e.g., "0:15:32.000000"

    // 4. Find app in DB and update time
    List<AppModel> apps = await db.readAppInfo();
    for (var app in apps) {
      if (app.appPackageName == targetPackageName) {
        int? appInfoId = app.appInfoId;
        await db.updateAppInfo(timeSpent, appInfoId);
        break;
      }
    }
  }

  Future<void> updateAllTimeSpent() async {
    await getUsageStats(); // Get usage data first
    List<AppModel> apps = await db.readAppInfo();

    for (var app in apps) {
      await realTimeUsage(app.appPackageName); // Update DB for each app
    }

    setState(() {}); // Rebuild UI with updated data
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    updateAllTimeSpent();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Marked as distracting apps'),
        centerTitle: true,
        foregroundColor: Colors.white,
        backgroundColor: Color(0xff328E6E),
      ),
      body: FutureBuilder<List<AppModel>>(
        future: db.readAppInfo(),
        builder: (context,snapshot){
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No apps found'));
          }else{
            final apps = snapshot.data!;
            return ListView.builder(
              itemCount: apps.length,
              itemBuilder: (context,index){
                final app = apps[index];
                return ListTile(
                  leading: Image.memory(app.appIcon, width: 40, height: 40),
                  title: Text(app.appName),
                  subtitle: Text('Time spent: ${app.timeSpent}'),
                );
              }
            );
          }
          
        }
      ),
    );
  }
}