import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasksystem_for_android/routes/EmployeeList.dart';

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
          children: <Widget>[
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
              shape: Border(left: BorderSide(color: Colors.white, width: 7)),
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
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => EmployeeList()));
              },
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
              onTap: logout,
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
                  child: list?.length != 0
                      ? ListView.builder(
                          itemCount: list?.length ?? 0,
                          itemBuilder: (context, index) {
                            return Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                height: 100,
                                margin: EdgeInsets.all(10),
                                // <-- Red color provided to below Row
                                child: Row(
                                  // mainAxisAlignment: MainAxisAlignment.,
                                  children: [
                                    Text('#${list?[index].taskId}'),
                                    Text('${list?[index].description}',
                                        overflow: TextOverflow.fade),
                                  ],
                                ));
                          },
                        )
                      : ListView(
                          children: [
                            Container(
                              child: Center(
                                child: Text('Задачи отсутствуют',
                                    style: TextStyle(
                                        fontSize: 24, color: Colors.grey)),
                              ),
                              height: 500,
                            )
                          ],
                        )))
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

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    setState(() {});
  }
}
