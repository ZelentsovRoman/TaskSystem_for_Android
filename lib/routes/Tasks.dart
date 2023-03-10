import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasksystem_for_android/routes/EmployeeList.dart';
import 'package:tasksystem_for_android/routes/TaskScreen.dart';

import '../models/Task.dart';
import '../models/User.dart';
import '../taskAPI.dart';
import 'AddTask.dart';
import 'Profile.dart';

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
        actions: [
          if (user?.employee?.privileges == 'Admin')
            IconButton(
                onPressed: () => {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => AddTask()))
                    },
                icon: Icon(Icons.add))
        ],
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
            if (user?.employee?.privileges == 'Admin')
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
              leading: Icon(Icons.person, size: 40),
              title: Text(
                'Профиль',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => Profile()));
              },
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
                  child: list?.length == 0
                      ? ListView(
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
                        )
                      : ListView.builder(
                          itemCount: list?.length ?? 0,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TaskScreen(
                                        string: list![index].taskId.toString()),
                                  ),
                                );
                              },
                              child: Slidable(
                                child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8)),
                                    ),
                                    height: 150,
                                    margin: EdgeInsets.all(10),
                                    // <-- Red color provided to below Row
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 20,
                                          decoration: BoxDecoration(
                                            color: list?[index]
                                                        .statusId
                                                        ?.statusId ==
                                                    1
                                                ? Colors.red
                                                : Colors.green,
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(8),
                                                bottomLeft: Radius.circular(8)),
                                          ),
                                        ),
                                        Expanded(
                                            child: Padding(
                                          padding: EdgeInsets.all(15),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    'Задача #${list?[index].taskId}',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 20),
                                                  ),
                                                  Text(
                                                    'от ${list?[index].date?.substring(0, 10)}',
                                                    style: TextStyle(
                                                        // fontWeight: FontWeight.bold,
                                                        fontSize: 18),
                                                  ),
                                                ],
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                              ),
                                              Text(
                                                list?[index].description != ''
                                                    ? '${list?[index].description}'
                                                    : 'Описание отсутствует',
                                                overflow: TextOverflow.fade,
                                                maxLines: 2,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Icon(
                                                            Icons.person,
                                                            color: Colors.grey,
                                                          ),
                                                          Text(
                                                              '${list?[index].employeeId?.lastName} ${list?[index].employeeId?.name?[0]}.'),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Icon(
                                                            Icons
                                                                .add_moderator_sharp,
                                                            color: Colors.grey,
                                                          ),
                                                          Text(
                                                              '${list?[index].userId?.employee?.lastName} ${list?[index].userId?.employee?.name?[0]}.'),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                  Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Icon(
                                                            Icons.event,
                                                            color: Colors.grey,
                                                          ),
                                                          Text(
                                                              '${list?[index].dateStart}'),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Icon(
                                                            Icons
                                                                .event_available,
                                                            color: Colors.grey,
                                                          ),
                                                          Text(
                                                              '${list?[index].dateEnd}'),
                                                        ],
                                                      )
                                                    ],
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        ))
                                      ],
                                    )),
                                endActionPane: ActionPane(
                                  motion: StretchMotion(),
                                  children: [
                                    SlidableAction(
                                      autoClose: true,
                                      backgroundColor: Colors.red,
                                      icon: Icons.delete,
                                      label: 'Удалить',
                                      onPressed: (BuildContext context) {
                                        delete(list![index].taskId);
                                      },
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        )))
        ],
      )),
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

  Future<bool?> delete(int? index) async {
    bool resp = await taskAPI().deleteTask(index);
    if (resp) {
      await getData();
      setState(() {});
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Ошибка удаления задачи')));
    }
  }
}
