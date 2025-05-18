import 'package:flutter/material.dart';
import 'package:lazyless/component/my_text_field.dart';
import 'package:lazyless/component/stolen_button.dart';
import 'package:lazyless/services/auth/auth_service.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;
  const RegisterPage({super.key, this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //text controller
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();


  void signup()async{
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password do not match!"))
      );
      return;
    }

    //get auth service
    final authService = Provider.of<AuthService>(context, listen: false);
    try {
      await authService.signUpWithEmailandPassword(
        emailController.text, 
        passwordController.text
        );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()))
      );
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
                  SizedBox(height: screenHeight * .01,),
                  //confirm password
                  MyTextField(
                    controller: confirmPasswordController,
                    hintText: 'Confirm Password', 
                    obscureText: true
                  ),
                  
                  SizedBox(height: screenHeight * .03,),
              
                  //sign up button 
                  StolenButton(
                    onTap: signup,
                    text: 'Sign up'
                  ),
                  SizedBox(height: screenHeight * .06,),
                  //not a member? register
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Already a member?'),
                      SizedBox(width: screenWidth*.01,),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: Text(
                          'Login now',
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