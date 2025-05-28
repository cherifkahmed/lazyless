import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lazyless/component/my_text_field.dart';
import 'package:lazyless/component/stolen_button.dart';
import 'package:lazyless/services/auth/auth_gate.dart';
import 'package:lazyless/services/my_service/user_service.dart';

class UserForm extends StatefulWidget {
  const UserForm({super.key});

  @override
  State<UserForm> createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final ageController = TextEditingController();
  File? _selectedImage;

  final UserService _userService = UserService();
  String condition = '';


void _showCategoryPicker(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (_) {
      List<String> categories = [
        'ADHD (Attention-Deficit/Hyperactivity Disorder)', 
        'Anxiety Disorders', 
        'Depression', 
        'Sleep Disorders', 
        'Bipolar Disorder', 
        'Fibromyalgia'
      ];

      return ListView(
        padding: EdgeInsets.all(8.0),
        children: categories
            .expand((category) => [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xff73946B),Color(0xff9EBC8A)]
                      ),
                      borderRadius: BorderRadius.circular(15)
                    ), 
                    child: ListTile(
                      title: Text(category),
                      onTap: () {
                        Navigator.pop(context);
                        print('Selected: $category');
                        setState(() {
                          condition = category;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 5),
                ])
            .toList(),
      );

    },
  );
  }





  @override
  Widget build(BuildContext context) {
    //final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xffDDEB9D),Color(0xffA0C878)]
              )
            ),
            child: Column(
              children: [
                SizedBox(height: screenHeight * .02),
                //image
               GestureDetector(
                onTap: () {
                  _pickImage();
                },
                child: CircleAvatar(
                  radius: 70, // Adjust the radius as needed
                  backgroundImage: _selectedImage != null ? FileImage(_selectedImage!) : null,
                  child: _selectedImage == null
                      ? Icon(Icons.add_a_photo, size: 30)
                      : null,
                ),
              ),
              SizedBox(height: screenHeight * .01),
              //first name
              MyTextField(
                controller: firstNameController, 
                hintText: 'First name', 
                obscureText: false
              ),
              SizedBox(height: screenHeight * .01),
              // last name
              MyTextField(
                controller: lastNameController, 
                hintText: 'Last name', 
                obscureText: false
              ),
              SizedBox(height: screenHeight * .01),
              //age
              TextField(
                controller: ageController,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Age',
                ),
              ),
              SizedBox(height: screenHeight * .01),
              //condition (medical,psychological)
              
              
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Text("do you suffer from a trouble issues?"),
                  SizedBox(height: screenHeight * .2),
                  IconButton(
                onPressed: () => _showCategoryPicker(context), 
                
                icon: Icon(Icons.arrow_downward)
              ),
                ],
              ),
              StolenButton(
                text: 'Submit',
                onTap:()async{
                    await _userService.addUser(
                          firstNameController.text, 
                          lastNameController.text, 
                          int.parse(ageController.text), 
                          condition
                        );
                        Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AuthGate()
                        )
                      );
                } ,
              )
                  
             
              ],
              
            ),
          ),
        ),
      ),
    );
  }


  Future _pickImage()async{
    final faceImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _selectedImage = File(faceImage!.path);
    });
  
  
  }





}