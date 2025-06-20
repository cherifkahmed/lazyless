import 'package:flutter/material.dart';

class Conv {
  final bool isUser;
  final String message;
  final DateTime date;

  Conv( {
    required this.isUser, 
    required this.message, 
    required this.date,
  });
}

class Convs extends StatelessWidget {
  final bool isUser;
  final String message;
  final String date;
  const Convs({super.key, required this.isUser, required this.message, required this.date});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.symmetric(vertical: 15).copyWith(
        left:isUser? 100:10,
        right:isUser? 10:100
      ),
      decoration: BoxDecoration(
        color:isUser? Colors.transparent:Colors.grey.shade400,
        border:isUser? Border.all(): null,
        borderRadius: BorderRadius.only(
          bottomLeft:isUser? Radius.circular(10): Radius.zero,
          topRight: Radius.circular(10),
          topLeft: Radius.circular(10),
          bottomRight: isUser? Radius.zero:Radius.circular(10)
        )
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message,
            style: TextStyle(fontSize: 16,color: Colors.white),
          ),
          Text(
            date,
            style: TextStyle(fontSize: 10,color: Colors.white),
          ),
        ],
      ),

    );
  }
}