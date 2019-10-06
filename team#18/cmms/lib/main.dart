import 'package:cmms/utils/Mandi.dart';
import 'package:cmms/utils/tools.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  Mandi.pref = await SharedPreferences.getInstance();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Tools.signInHandler(),
      theme: ThemeData(buttonColor: Colors.green, primarySwatch: Colors.green),
    );
  }
}
