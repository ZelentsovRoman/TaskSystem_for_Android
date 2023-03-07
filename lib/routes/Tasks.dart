import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/Task.dart';
import '../models/User.dart';
import '../taskAPI.dart';

class Tasks extends StatefulWidget {
  const Tasks({Key? key}) : super(key: key);

  @override
  State<Tasks> createState() => _TasksState();
}

class _TasksState extends State<Tasks> {
  @override
  void initState() {
    getData();
    super.initState();
  }

  User? user;
  List<Task>? list;

  @override
  Widget build(BuildContext context) {
    final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
        GlobalKey<RefreshIndicatorState>();
    return Scaffold(
        backgroundColor: const Color(0xFFF0F0F0),
        body: SafeArea(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
                child: RefreshIndicator(
              onRefresh: getData,
              key: _refreshIndicatorKey,
              child: ListView.builder(
                itemCount: list?.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('${list?[index].userId?.employee?.name}'),
                  );
                },
              ),
            ))
          ],
        )));
  }

  Future<Null> getData() async {
    final prefs = await SharedPreferences.getInstance();
    user = User.fromJson(jsonDecode(prefs.getString('user')!));
    if (user?.employee?.privileges == 'Admin') {
      list = await taskAPI().tasksForAdmin(user);
    } else {
      list = await taskAPI().tasksForUser(user);
    }
    setState(() {});
  }
}
