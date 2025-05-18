import 'package:flutter/material.dart';
import 'package:lazyless/component/my_text_field.dart';
import 'package:lazyless/component/stolen_button.dart';
import 'package:lazyless/services/auth/auth_service.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;
  const LoginPage({super.key, this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  //text controller
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void signin()async{
    final authService = Provider.of<AuthService>(context, listen: false);
    try {
      await authService.signInWithEmailandPassord(
        emailController.text, 
        passwordController.text
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString()
            )));
    }
  }



  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: screenHeight * .1,),
                  //logo 
                  Icon(
                    Icons.self_improvement,
                    size: screenHeight * .2,
                  ),
              
                  //welcome back message
                  Text("Welcome back you\'ve been missed!",style: TextStyle(fontSize: screenHeight * .025),),
              
                  //email textfield
                  MyTextField(
                    controller: emailController,
                    hintText: 'Email', 
                    obscureText: false
                  ),
                  SizedBox(height: screenHeight * .01,),
                  //password textfield
                  MyTextField(
                    controller: passwordController,
                    hintText: 'Password', 
                    obscureText: true
                  ),
                  SizedBox(height: screenHeight * .03,),
              
                  //sign in button 
                  StolenButton(
                    onTap: signin,
                    text: 'Sign in'
                  ),
                  SizedBox(height: screenHeight * .06,),
                  //not a member? register
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Not a member?'),
                      SizedBox(width: screenWidth*.01,),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: Text(
                          'Register now',
                          style: TextStyle(
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}