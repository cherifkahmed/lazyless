import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lazyless/screens/user/focus/void_screen.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {

  double _sliderValue = 45 * 60 ;
  Timer? _timer;
  bool _isRunning= false;

  // Get the hours, minutes, and seconds from the slider value
  String get _formattedTime {
    int totalSeconds = _sliderValue.toInt();
    int hours = totalSeconds ~/ 3600;
    int minutes = (totalSeconds % 3600) ~/ 60;
    int seconds = totalSeconds % 60;
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')} H : ${minutes.toString().padLeft(2, '0')} MIN';
    }else{
      return '${minutes.toString().padLeft(2, '0')} MIN : ${seconds.toString().padLeft(2, '0')} SEC';
    }
    
  }


  void _startCountDown() {
    setState(() {
      _isRunning= true;
    });
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      if (_sliderValue <= 0) {
        timer.cancel(); // Stop the countdown when the value reaches 0
      } else {
        setState(() {
          _sliderValue -= 1; // Decrease the slider value by 1 second
          if (_sliderValue < 0) {
            _sliderValue = 0; // Prevent negative values
            _isRunning= false;
          }
        });
      }
    });
  }

  void _stopTimer() {
    _timer!.cancel();
    setState(() {
      _isRunning= false;
    });
    
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }



  @override
  void dispose() {
    // Ensure the timer is canceled when the widget is disposed
    _timer!.cancel();
    super.dispose();
  }









  @override
  Widget build(BuildContext context) {
    //WakelockPlus.enable();
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [

          // THE TIMER
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: screenHeight * .01),
                // SLIDER 
                SleekCircularSlider(
                  initialValue: _sliderValue,
                  min: 0,
                  max: 90*60, // 3 hours in seconds
                  onChange: _isRunning?null
                  :(double value) {
                    setState(() {
                      _sliderValue = value;
                    });
                  },
                  appearance: CircularSliderAppearance(
                    size: 250,
                    startAngle: 270,
                    angleRange: 360,
                    customWidths: CustomSliderWidths(
                      handlerSize: 10,
                      progressBarWidth: 20,
                      trackWidth: 20,
                    ),
                    customColors: CustomSliderColors(
                      // CUSTOMIZE THE COLOR OF THE SLIDER
                    )
                  ),
                  innerWidget: (double value) {
                    return Center(
                      child: Text(
                        value>0? _formattedTime:'You did it',
                        
                        style: const TextStyle(
                          fontSize: 24,
                        ),
                      ),
                    );
                  },
                ),
              
              SizedBox(height: screenHeight * .01),
              // VOID BUTTON
              SizedBox(
                width: screenWidth * .8,
                height: screenHeight * .08,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      
                      
                      
                    ),
                    backgroundColor: Color(0xff328E6E),
                  ),
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VoidScreen(
                          sliderValue: _sliderValue
                      )
                    )
                    );
                  },
                  label: Text('  V O I D  ',style: TextStyle(color: Colors.white,fontSize: 25),),
                  icon: Icon(Icons.not_interested, size: screenHeight * .04,color: Colors.white,),
                  
                  
                ),
              ),
              Text('To-Do'),

            ],

            ),
            
          ),

          
          
        
        ],
      )
    );
  }
}