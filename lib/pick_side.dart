import 'package:flutter/material.dart';
import 'package:lazyless/component/stolen_button.dart';
import 'package:lazyless/screens/coach/coach_form.dart';
import 'package:lazyless/screens/user/user_form.dart';

class PickSide extends StatefulWidget {
  const PickSide({super.key});

  @override
  State<PickSide> createState() => _PickSideState();
}

class _PickSideState extends State<PickSide> {
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color(0xff328E6E),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
                    width: screenWidth* .6,
                    height: screenHeight * .3,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('lib/assets/images/user-img.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
          Row(
            children: [
              SizedBox(width: 40,),
              StolenButton(text: 'User',onTap: () {
                Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserForm()
                          )
                        );
              },),
            ],
          ),
          SizedBox(height: 10,),
          Container(
                    width: screenWidth* .6,
                    height: screenHeight * .3,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('lib/assets/images/coach-img.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
          Row(
            children: [
              SizedBox(width: 40),
              StolenButton(text: 'Coach',onTap: () {
                Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CoachForm()
                          )
                        );
              },),
            ],
          ),
          SizedBox(height: screenHeight * .01,),
          
        ],
      ),
    );
  }
}