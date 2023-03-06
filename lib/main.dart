// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:tasksystem_for_android/routes/Home.dart';

void main() => runApp(MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      initialRoute: '/',
      routes: {'/': (context) => Home()},
    ));
