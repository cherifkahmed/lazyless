import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lazyless/services/auth/auth_gate.dart';
import 'package:lazyless/services/auth/auth_service.dart';
import 'package:lazyless/services/personal_info/user_data_service.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  await Firebase.initializeApp();
  runApp(
    
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserDataService()),
        ChangeNotifierProvider(create: (_) => AuthService()),
        // other providers like AuthService...
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthGate(),
    );
  }
}