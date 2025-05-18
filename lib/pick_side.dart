import 'package:flutter/material.dart';
import 'package:lazyless/component/my_button.dart';
import 'package:lazyless/screens/login_page.dart';

class PickSide extends StatelessWidget {
  const PickSide({super.key});

  @override
  Widget build(BuildContext context) {
    //final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Color(0xffBF9264),Color(0xff73946B)])
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight * .2),
              Center(
                child: Text(
                  "I'm a User",
                  style: TextStyle(fontSize: screenHeight * .06),
                  textAlign: TextAlign.center,
                ),
              ),
              MyButton(
                title: 'Continue',
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginPage()),
                    );
                  
                }
              ),
              SizedBox(height: screenHeight * .1),
              Center(
                child: Text(
                  "I'm a Coach",
                  style: TextStyle(fontSize: screenHeight * .06),
                  textAlign: TextAlign.center,
                ),
              ),
              MyButton(
                title: 'Continue',
                onPressed: (){}
              ),
            ],
          ),
        ),
      ),
    );
  }
}
