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
      appBar: AppBar(
        title: Text('Задачи'),
        backgroundColor: Color(0xFF2D3748),
      ),
      drawer: Drawer(
        backgroundColor: Color(0xFF2D3748),
        child: Column(
          children: const <Widget>[
            SizedBox(
              height: 80,
              child: DrawerHeader(
                padding: EdgeInsets.only(left: 0),
                decoration: BoxDecoration(
                  color: Color(0xFF2D3748),
                ),
                child: ListTile(
                  iconColor: Colors.white,
                  leading: Icon(Icons.checklist, size: 40),
                  title: Text(
                    'TaskSystem',
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                ),
              ),
            ),
            Divider(
              height: 0,
              color: Colors.white,
            ),
            ListTile(
              iconColor: Colors.white,
              tileColor: Colors.blueGrey,
              leading: Icon(Icons.description, size: 40),
              title: Text(
                'Список задач',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
            ListTile(
              iconColor: Colors.white,
              leading: Icon(Icons.people, size: 40),
              title: Text(
                'Список сотрудников',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
            Expanded(child: Text('')),
            ListTile(
              iconColor: Colors.white,
              leading: Icon(Icons.group_add, size: 40),
              title: Text(
                'Добавление сотрудника',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
            ListTile(
              iconColor: Colors.white,
              leading: Icon(Icons.person, size: 40),
              title: Text(
                'Профиль',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
            ListTile(
              iconColor: Colors.white,
              leading: Icon(Icons.logout, size: 40),
              title: Text(
                'Выйти',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
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
                return Row(
                  children: [
                    Expanded(
                      child: Text('${list?[index].taskId}'),
                      flex: 1,
                    ),
                    Expanded(
                      child: Text('${list?[index].description}'),
                      flex: 2,
                    ),
                  ],
                );
              },
            ),
          ))
        ],
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Color(0xFF2D3748),
        child: Icon(Icons.add),
      ),
    );
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
