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


  final List<String> _tasks = [];
  final TextEditingController _controller = TextEditingController();

  void _addTask() {
    if (_controller.text.trim().isEmpty) return;
    setState(() {
      _tasks.add(_controller.text.trim());
      _controller.clear();
    });
  }

  void _removeTask(int index) {
    setState(() {
      _tasks.removeAt(index);
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
                      
                      trackColors: [Color(0xff4B352A),Color(0xffCA7842)],
                      progressBarColors: [Color(0xff90C67C),Color(0xff328E6E)]
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
              Text('To-Do',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        labelText: 'Enter a task',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xff328E6E),
                      borderRadius: BorderRadius.circular(12)
                    ),
                    child: IconButton(
                      iconSize: screenWidth*.1,
                      onPressed: _addTask,
                      icon: Icon(Icons.add)
                    ),
                  ),
                  
                ],
              ),
              SizedBox(height: 16),
              Expanded(
                
                child: _tasks.isEmpty
                    ? Center(child: Text('No tasks yet!',style: TextStyle(color: Colors.white),))
                    : ListView.builder(
                        itemCount: _tasks.length,
                        itemBuilder: (context, index) => Card(
                          child: ListTile(
                            tileColor: Color(0xff90C67C),
                            title: Text(_tasks[index],style: TextStyle(color: Colors.white),),
                            trailing: IconButton(
                              icon: Icon(Icons.delete),
                              color: Colors.grey[200],
                              onPressed: () => _removeTask(index),
                            ),
                          ),
                        ),
                      ),
              ),
      
            ],
      
            ),
            
          ),
      
          
          
        
        ],
      )
    );
  }
}