import 'dart:typed_data';

//import 'package:app_usage/app_usage.dart';
import 'package:flutter/material.dart';
import 'package:lazyless/database/models/app_model.dart';
import 'package:lazyless/database/sqflite.dart';

class MarkApp extends StatefulWidget {
  final String appPackageName;
  final Uint8List appIcon;
  final String appName;
  const MarkApp({super.key,required this.appPackageName, required this.appIcon, required this.appName});

  @override
  State<MarkApp> createState() => _MarkAppState();
}

class _MarkAppState extends State<MarkApp> {
  final db = DatabaseHelper();


  




  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('Mark this app'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF98D8EF),Color(0xff0E46A3), Color(0xFF00CCDD)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(screenWidth * .15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            
            children: [
              
              Image.memory(widget.appIcon,width: 80,height: 80),
              SizedBox(height: screenHeight * .02),
              Text(
                widget.appName,
                style: const TextStyle(fontSize: 20, fontWeight:FontWeight.bold),
              ),
              SizedBox(height: screenHeight * .02),
              Text('Do you want to mark this app then you can always be aware of your usage',style: TextStyle(fontSize: 30,),textAlign: TextAlign.center,),
              ElevatedButton(
                onPressed: (){
                  ///add the app to the database
                  db.createAppInfo(AppModel(
                    appName: widget.appName, 
                    appPackageName: widget.appPackageName, 
                    appIcon: widget.appIcon, 
                    timeSpent: "0s"
                  ));
                  Navigator.pop(context);
                  print("success");
                }, 
                child: Text('MARK'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}