import 'package:flutter/material.dart';
import 'package:lazyless/screens/coach/home_coach.dart';
import 'package:lazyless/screens/user/home_user.dart';

class ClientOrCoach extends StatefulWidget {
  final bool isCoach;
  const ClientOrCoach({super.key, required this.isCoach});

  @override
  State<ClientOrCoach> createState() => _ClientOrCoachState();
}

class _ClientOrCoachState extends State<ClientOrCoach> {
  @override
  Widget build(BuildContext context) {
    if (widget.isCoach) {
      return HomeCoach();
    } else {
      return HomeUser();
    }
    
  }
}