import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasksystem_for_android/routes/AddEmployee.dart';
import 'package:tasksystem_for_android/routes/AddTask.dart';
import 'package:tasksystem_for_android/routes/EmployeeList.dart';
import 'package:tasksystem_for_android/routes/Home.dart';
import 'package:tasksystem_for_android/routes/Profile.dart';
import 'package:tasksystem_for_android/routes/Register.dart';
import 'package:tasksystem_for_android/routes/TaskScreen.dart';
import 'package:tasksystem_for_android/routes/Tasks.dart';
import 'package:tasksystem_for_android/taskAPI.dart';

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
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          Locale('en'), // English
          Locale('ru'), // Spanish
        ],
        routes: {
          '/': (context) => Home(),
          '/Register': (context) => Register(),
          '/Tasks': (context) => Tasks(),
          '/EmployeeList': (context) => EmployeeList(),
          '/AddTask': (context) => AddTask(),
          '/AddEmployee': (context) => AddEmployee(),
          '/TaskScreen': (context) => TaskScreen(
                string: '',
              ),
          '/Profile': (context) => Profile()
        }));
  });
}

Future<bool> auth() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  User user = User.fromJson(jsonDecode(prefs.getString('user') ?? '{}'));
  if (user.login != null) {
    String? response = await taskAPI().updateUser(user);
    if (response == 'NOT_FOUND') {
      return false;
    } else {
      user = User.fromJson(jsonDecode(response!));
      prefs.setString('user', response!);
      return true;
    }
  } else {
    return false;
  }
}
