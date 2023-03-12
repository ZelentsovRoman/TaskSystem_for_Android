import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasksystem_for_android/routes/EmployeeList.dart';
import 'package:tasksystem_for_android/routes/Tasks.dart';

import '../models/User.dart';
import '../taskAPI.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final formKey = GlobalKey<FormState>();
  User? _user;
  final _Name = TextEditingController();
  final _LastName = TextEditingController();
  final _Login = TextEditingController();
  final _Password = TextEditingController();
  String? login;

  @override
  void initState() {
    updateUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
        GlobalKey<RefreshIndicatorState>();
    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      appBar: AppBar(
        title: Text('Профиль'),
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
            if (_user?.employee?.privileges == 'Admin')
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
              shape: Border(left: BorderSide(color: Colors.white, width: 7)),
              tileColor: Colors.blueGrey,
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
            onRefresh: updateUser,
            child: Form(
                key: formKey,
                child: ListView(
                  children: [
                    Column(
                      children: [
                        const Padding(padding: EdgeInsets.only(top: 30)),
                        SizedBox(
                            width: 350,
                            child: Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Компания: ',
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        '${_user?.employee?.company?.name ?? ''}',
                                        style: TextStyle(
                                          fontSize: 20,
                                        ))
                                  ],
                                )
                              ],
                            )),
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
                              controller: _Name,
                              onChanged: (value) {
                                _user?.employee?.name = value;
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
                              controller: _LastName,
                              onChanged: (value) {
                                _user?.employee?.lastName = value;
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
                            child: TextFormField(
                              validator: (value) {
                                if (value?.isEmpty ?? true) {
                                  return 'Введите логин';
                                }
                                return null;
                              },
                              controller: _Login,
                              onChanged: (value) {
                                _user?.login = value;
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
                              controller: _Password,
                              onChanged: (value) {
                                _user?.password = value;
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
                            setState(() {});
                            if (formKey.currentState!.validate()) {
                              if (login != _user?.login) {
                                User? check = await checkUser(_user!);
                                if (check?.login != null) {
                                  if (check?.login == _user?.login) {
                                    setState(() {
                                      ScaffoldMessenger.of(context)
                                          .clearSnackBars();
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Пользователь с таким логином уже существует')));
                                  } else {
                                    save(_user!);
                                  }
                                } else {
                                  save(_user!);
                                }
                              } else {
                                save(_user!);
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
                  ],
                )),
          ))
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

  Future<void> save(User user) async {
    bool resp = await taskAPI().editUser(user);
    ScaffoldMessenger.of(context).clearSnackBars();
    if (resp) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Данные обновлены')));
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ошибка редактирования профиля')));
    }
  }

  Future<void> updateUser() async {
    final prefs = await SharedPreferences.getInstance();
    _user = User.fromJson(jsonDecode(prefs.getString('user')!));
    String? response = await taskAPI().updateUser(_user);
    _user = User.fromJson(jsonDecode(response!));
    prefs.setString('user', response!);
    setState(() {
      getData();
    });
  }

  Future<void> getData() async {
    login = _user?.login;
    _Name..text = (_user?.employee?.name)!;
    _LastName..text = (_user?.employee?.lastName)!;
    _Login..text = (_user?.login)!;
    _Password..text = (_user?.password)!;
    setState(() {});
  }
}
