import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/Employee.dart';
import '../models/User.dart';
import '../taskAPI.dart';
import 'AddEmployee.dart';
import 'Profile.dart';
import 'Tasks.dart';

class EmployeeList extends StatefulWidget {
  const EmployeeList({Key? key}) : super(key: key);

  @override
  State<EmployeeList> createState() => _EmployeeListState();
}

class _EmployeeListState extends State<EmployeeList> {
  @override
  void initState() {
    getData();
    super.initState();
  }

  List<Employee>? list;
  User? user;

  @override
  Widget build(BuildContext context) {
    final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
        GlobalKey<RefreshIndicatorState>();
    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      appBar: AppBar(
        title: Text('Список сотрудников'),
        backgroundColor: Color(0xFF2D3748),
        actions: [
          IconButton(
              onPressed: () => {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => AddEmployee()))
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
              iconColor: Colors.white,
              leading: Icon(Icons.description, size: 40),
              title: Text(
                'Список задач',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => Tasks()));
              },
            ),
            ListTile(
              shape: Border(left: BorderSide(color: Colors.white, width: 7)),
              iconColor: Colors.white,
              tileColor: Colors.blueGrey,
              leading: Icon(Icons.people, size: 40),
              title: Text(
                'Список сотрудников',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
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
            child: ListView.builder(
              itemCount: list?.length ?? 0,
              itemBuilder: (context, index) {
                return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    padding: EdgeInsets.all(10),
                    height: 100,
                    margin: EdgeInsets.all(10),
                    // <-- Red color provided to below Row
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Flexible(
                          child: Text(
                            '${list?[index].name}',
                            style: TextStyle(overflow: TextOverflow.fade),
                          ),
                        ),
                        Flexible(
                          child: Text(
                            '${list?[index].lastName}',
                            style: TextStyle(overflow: TextOverflow.fade),
                          ),
                        ),
                        Text('Права доступа: \n${list?[index].privileges}'),
                        if (list![index].employeeId !=
                            user?.employee?.employeeId)
                          IconButton(
                              onPressed: () => showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                        title: Text('Удаление'),
                                        content: Text(
                                            'Вы точно хотите удалить пользователя?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(
                                                context, 'Cancel'),
                                            child: const Text('Отмена'),
                                          ),
                                          TextButton(
                                            onPressed: () =>
                                                deleteEmployee(list![index]),
                                            child: const Text('Удалить'),
                                          ),
                                        ],
                                      )),
                              icon: Icon(Icons.delete))
                      ],
                    ));
              },
            ),
          )),
        ],
      )),
    );
  }

  Future<Null> getData() async {
    final prefs = await SharedPreferences.getInstance();
    user = User.fromJson(jsonDecode(prefs.getString('user')!));
    list = await taskAPI().allEmployee(user);
    setState(() {});
  }

  void logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    setState(() {});
  }

  void deleteEmployee(Employee employee) async {
    bool resp = await taskAPI().deleteUser(employee);
    if (resp) {
      await getData();
      Navigator.pop(context);
      setState(() {});
    } else
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка удаления пользователя')));
  }
}
