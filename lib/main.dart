import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasksystem_for_android/routes/EmployeeList.dart';
import 'package:tasksystem_for_android/routes/Home.dart';
import 'package:tasksystem_for_android/routes/Register.dart';
import 'package:tasksystem_for_android/routes/Tasks.dart';

import 'models/User.dart';

bool authCheck = false;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  auth().then((value) {
    runApp(MaterialApp(
        theme: ThemeData(
          primaryColor: Color(0xFFF0F0F0),
        ),
        initialRoute: value ? '/Tasks' : '/',
        routes: {
          '/': (context) => Home(),
          '/Register': (context) => Register(),
          '/Tasks': (context) => Tasks(),
          '/EmployeeList': (context) => EmployeeList(),
        }));
  });
}

Future<bool> auth() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  User user = User.fromJson(jsonDecode(prefs.getString('user') ?? '{}'));
  if (user.login != null) {
    return true;
  } else {
    return false;
  }
}
