import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasksystem_for_android/routes/EmployeeList.dart';
import 'package:tasksystem_for_android/routes/Tasks.dart';

import '../models/Employee.dart';
import '../models/User.dart';
import '../taskAPI.dart';
import 'Profile.dart';

class AddEmployee extends StatefulWidget {
  const AddEmployee({Key? key}) : super(key: key);

  @override
  State<AddEmployee> createState() => _AddEmployeeState();
}

class _AddEmployeeState extends State<AddEmployee> {
  final formKey = GlobalKey<FormState>();
  late String login;
  late String password;
  late String name;
  late String lastName;
  late String privileges;

  @override
  void initState() {
    getData();
    super.initState();
  }

  late User _user;

  @override
  Widget build(BuildContext context) {
    final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
        GlobalKey<RefreshIndicatorState>();
    List<DropdownMenuItem<String>> dropdownvalues = [
      DropdownMenuItem(child: Text("User"), value: "User"),
      DropdownMenuItem(child: Text("Admin"), value: "Admin"),
    ];
    privileges = dropdownvalues.first.value!;
    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      appBar: AppBar(
        title: Text('Добавление сотрудника'),
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
              child: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const Padding(padding: EdgeInsets.only(top: 30)),
                        SizedBox(
                            width: 350,
                            child: TextFormField(
                              validator: (value) {
                                if (value?.isEmpty ?? true) {
                                  return 'Введите имя';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                name = value;
                                setState(() {});
                              },
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  isDense: true,
                                  labelText: 'Имя'),
                            )),
                        const Padding(padding: EdgeInsets.only(top: 30)),
                        SizedBox(
                            width: 350,
                            child: TextFormField(
                              validator: (value) {
                                if (value?.isEmpty ?? true) {
                                  return 'Введите фамилию';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                lastName = value;
                                setState(() {});
                              },
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  isDense: true,
                                  labelText: 'Фамилия'),
                            )),
                        const Padding(padding: EdgeInsets.only(top: 30)),
                        SizedBox(
                            width: 350,
                            child: DropdownButtonFormField(
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    isDense: true,
                                    labelText: 'Права доступа'),
                                value: privileges,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    privileges = newValue!;
                                  });
                                },
                                items: dropdownvalues)),
                        const Padding(padding: EdgeInsets.only(top: 30)),
                        SizedBox(
                            width: 350,
                            child: TextFormField(
                              validator: (value) {
                                if (value?.isEmpty ?? true) {
                                  return 'Введите логин';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                login = value;
                                setState(() {});
                              },
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  isDense: true,
                                  labelText: 'Логин'),
                            )),
                        const Padding(padding: EdgeInsets.only(top: 30)),
                        SizedBox(
                            width: 350,
                            child: TextFormField(
                              obscureText: true,
                              validator: (value) {
                                if (value?.isEmpty ?? true) {
                                  return 'Введите пароль';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                password = value;
                                setState(() {});
                              },
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  isDense: true,
                                  labelText: 'Пароль'),
                            )),
                        const Padding(padding: EdgeInsets.only(top: 30)),
                        ElevatedButton(
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              Employee employee = Employee(
                                  name, lastName, privileges,
                                  company: _user?.employee?.company);
                              User user =
                                  User(login, password, employee: employee);
                              User? check = await checkUser(user);
                              if (check?.login == user.login) {
                                setState(() {
                                  ScaffoldMessenger.of(context)
                                      .clearSnackBars();
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'Пользователь с таким логином уже существует')));
                              } else {
                                save(user, employee);
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF2D3748),
                          ),
                          child: const Text(
                            'Добавить',
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      ],
                    ),
                  )))
        ],
      )),
    );
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    setState(() {});
  }

  Future<User?> checkUser(User user) async {
    return await taskAPI().checkUser(user);
  }

  Future<void> save(User user, Employee employee) async {
    dynamic getEmployee = await taskAPI().saveEmployee(employee);
    user.employee = getEmployee;
    bool resp = await taskAPI().saveUser(user);
    if (resp) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => EmployeeList()));
      setState(() {});
    }
  }

  Future<void> getData() async {
    final prefs = await SharedPreferences.getInstance();
    _user = User.fromJson(jsonDecode(prefs.getString('user')!));
  }
}
