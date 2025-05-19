import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lazyless/database/models/focus_model.dart';
import 'package:lazyless/database/sqflite.dart';
import 'package:lazyless/services/dnd_mode.dart';
import 'package:vibration/vibration.dart';
import 'package:wakelock_plus/wakelock_plus.dart';


class VoidScreen extends StatefulWidget {
  final double sliderValue;
  const VoidScreen({super.key, required this.sliderValue});

  @override
  State<VoidScreen> createState() => _VoidScreenState();
}

class _VoidScreenState extends State<VoidScreen> {
  // TIMER VARS
  late double initialValue;
  Timer? _timer;
  // BREAK VARS
  Timer? _breakTimer;
  double breakValue = 0;
  //DATABASE VALUES
  final db = DatabaseHelper();
  int brakCount = 0;
  double pickedTime = 1.0;
  //time where breakes not allowed
  double allowBreakValue = 30;
  bool isBreakAllowed = false;
  Timer? _allowBreakTimer;

  bool allowBreak(){
    isBreakAllowed = false;
    allowBreakValue = 30;
    _allowBreakTimer= Timer.periodic(Duration(seconds: 1), (timer){
      setState(() {
        if (allowBreakValue > 0) {
          allowBreakValue --;
        } else {
          _allowBreakTimer?.cancel();
          isBreakAllowed = true;
        }
      });
    });
    return isBreakAllowed;
  }




  void startDeepWork(){
    _timer = Timer.periodic(Duration(seconds: 1), (timer){
      setState(() {
        if (initialValue > 0) {
          initialValue--;
          allowBreak();
        }else{
          _timer?.cancel();
        }
      });
    });
  }

  void takeBreak(){
    _timer!.cancel();
    breakValue = 15*60;
    welcomenoise();
    _breakTimer =Timer.periodic(Duration(seconds: 1), (timer){
      if (breakValue<= 10) {
        Vibration.vibrate(pattern: [500, 1000, 500, 2000]);
      }
      setState(() {
        if (breakValue > 0) {
          breakValue--;
        } else {
          _breakTimer?.cancel();
          startDeepWork();
          Vibration.cancel();
          embraceTheZen();
        }
      });
    });
  }

  String get _formattedTime {
    int totalSeconds = initialValue.toInt();
    int hours = totalSeconds ~/ 3600;
    int minutes = (totalSeconds % 3600) ~/ 60;
    int seconds = totalSeconds % 60;
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')} H : ${minutes.toString().padLeft(2, '0')} MIN';
    }else{
      return '${minutes.toString().padLeft(2, '0')} MIN : ${seconds.toString().padLeft(2, '0')} SEC';
    }
    
  }
  
  String get _formattedTimeBreak {
    int totalSeconds = breakValue.toInt();
    int hours = totalSeconds ~/ 3600;
    int minutes = (totalSeconds % 3600) ~/ 60;
    int seconds = totalSeconds % 60;
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')} H : ${minutes.toString().padLeft(2, '0')} MIN';
    }else{
      return '${minutes.toString().padLeft(2, '0')} MIN : ${seconds.toString().padLeft(2, '0')} SEC';
    }
    
  }


  Future<String> timeFormat(double value){
    int totalSeconds = value.toInt();
    int hours = totalSeconds ~/ 3600;
    int minutes = (totalSeconds % 3600) ~/ 60;
    int seconds = totalSeconds % 60;
    String formattedTime;
    if (hours > 0) {
      formattedTime = '${hours.toString().padLeft(2, '0')} H : ${minutes.toString().padLeft(2, '0')} MIN';
    }else{
      formattedTime = '${minutes.toString().padLeft(2, '0')} MIN : ${seconds.toString().padLeft(2, '0')} SEC';
    }
    return Future.value(formattedTime);
  }



  @override
  void initState() {
    //ACTIVATE DND MODE
    embraceTheZen();
    //HIDE SYSTEM BAR
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    initialValue = widget.sliderValue;
    pickedTime=widget.sliderValue;
    startDeepWork();
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }
  @override
  void dispose() async{
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    //SHOW SYSTEM BAR
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    welcomenoise();
    _timer!.cancel();
    super.dispose();

    String formattedPickedTime = await timeFormat(pickedTime);
    String formattedFocusTime = await timeFormat(pickedTime - initialValue);  

    //CREATE THE ROW IN THE DATABASE
    db.createFocus (FocusModel (
      pickedTime: formattedPickedTime,
      focusTime: formattedFocusTime,
      breakNumber:brakCount,
      ));

  }


  @override
  Widget build(BuildContext context) {
    WakelockPlus.enable();
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      
      body: Container(
        decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Color(0xFF061993),
          Color(0xFF1973D1),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    ),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: screenHeight * 0.02),
                  
                  Row(
                    children: [
                      SizedBox(width: screenWidth * .1),
                      Text(_formattedTime, style: TextStyle(color: Colors.white70 , fontSize: screenHeight * .22)),
                      //SOUND BUTTON
                      
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.1),
                  //NUMBER OF BREAKS
                  Text(breakValue>0? _formattedTimeBreak :'you took $brakCount breaks', style: TextStyle(color: const Color.fromARGB(255, 242, 82, 82) , fontSize: screenHeight * .08)),
                  SizedBox(height: screenHeight * 0.1),
                  // TAKE BREAK BUTTON
                  if(isBreakAllowed)
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      backgroundColor: const Color.fromARGB(255, 242, 82, 82),
                    ),
                    onPressed: (){
                      takeBreak();
                      setState(() {
                        brakCount++;
                      });
                      
                    },
                    label: Text('B R E A K', style: TextStyle(fontSize: 30 , color: Colors.black)),
                    icon: Icon(Icons.coffee, size: screenHeight * .15 , color: Colors.lightGreen),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}