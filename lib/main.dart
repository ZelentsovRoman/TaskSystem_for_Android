import 'package:flutter/material.dart';
import 'package:tasksystem_for_android/routes/Home.dart';
import 'package:tasksystem_for_android/routes/Register.dart';
import 'package:tasksystem_for_android/routes/Tasks.dart';

void main() => runApp(MaterialApp(
        theme: ThemeData(
          primaryColor: Color(0xFFF0F0F0),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => Home(),
          '/Register': (context) => Register(),
          '/Tasks': (context) => Tasks(),
        }));
