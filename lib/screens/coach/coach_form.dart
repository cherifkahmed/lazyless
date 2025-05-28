import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lazyless/component/my_button.dart';
import 'package:lazyless/component/my_text_field.dart';
import 'package:lazyless/component/stolen_button.dart';
import 'package:lazyless/services/auth/auth_gate.dart';
import 'package:lazyless/services/my_service/coach_service.dart';

class CoachForm extends StatefulWidget {
  const CoachForm({super.key});

  @override
  State<CoachForm> createState() => _CoachFormState();
}

class _CoachFormState extends State<CoachForm> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final ageController = TextEditingController();
  File? _selectedImage;

  final CoachService _coachService = CoachService();
  String domain = '';


void _showCategoryPicker(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (_) {
      List<String> categories = [
        'Personal Development', 
        'Career Coaching', 
        'Health & Wellness', 
        'Relationships', 
        'Financial Coaching (Life+Money)', 
        'Spiritual or Purpose Coaching'
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
                          domain = category;
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
        body: Container(
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
                radius: 100, // Adjust the radius as needed
                backgroundImage: _selectedImage != null ? FileImage(_selectedImage!) : null,
                child: _selectedImage == null
                    ? Icon(Icons.add_a_photo, size: 30)
                    : null,
              ),
            ),
            SizedBox(height: screenHeight * .1),
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
                labelText: 'Enter numbers only',
              ),
            ),
            SizedBox(height: screenHeight * .01),
            //domain (medical,psychological)
           
            MyButton(
              title: 'domain', 
              onPressed: () => _showCategoryPicker(context)
            ),
            SizedBox(height: screenHeight * .2),
            StolenButton(
              text: 'Submit',
              onTap:()async{
                Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AuthGate()
                      )
                    );
                  await _coachService.addCoach(
                        firstNameController.text , 
                        lastNameController.text,
                        int.parse(ageController.text), 
                        domain
                    );
              } ,
            )
                
           
            ],
            
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