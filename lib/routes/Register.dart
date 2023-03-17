import 'package:flutter/material.dart';

import '../models/Company.dart';
import '../models/Employee.dart';
import '../models/User.dart';
import '../taskAPI.dart';
import 'Home.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final formKey = GlobalKey<FormState>();
  late String login;
  late String password;
  late String name;
  late String lastName;
  late String company;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF0F0F0),
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
                        const Padding(padding: EdgeInsets.only(top: 60)),
                        const Text(
                          'Регистрация',
                          style: TextStyle(
                              fontFamily: 'PT Sans Caption', fontSize: 30),
                        ),
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
                            child: TextFormField(
                              validator: (value) {
                                if (value?.isEmpty ?? true) {
                                  return 'Введите название компании';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                company = value;
                                setState(() {});
                              },
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  isDense: true,
                                  labelText: 'Компания'),
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
                              setState(() {
                                ScaffoldMessenger.of(context).clearSnackBars();
                              });
                              late SnackBar snackbar;
                              bool check = false;
                              Company comp = Company(company);
                              Company? getCompany = await checkCompany(comp);
                              if (getCompany?.name != comp.name) {
                                User user = User(login, password);
                                User? getUser = await checkUser(user);
                                if (getUser?.login != user.login) {
                                  Employee employee =
                                      Employee(name, lastName, 'Admin');
                                  save(user, employee, comp);
                                } else {
                                  check = true;
                                  snackbar = SnackBar(
                                    content: Text(
                                        'Пользователь с таким логином уже существует'),
                                  );
                                }
                              } else {
                                check = true;
                                snackbar = SnackBar(
                                  content: Text(
                                      'Компания с таким названием уже существует'),
                                );
                              }
                              if (check) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackbar);
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF2D3748),
                          ),
                          child: const Text(
                            'Зарегистрироваться',
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

  Future<User?> checkUser(User user) async {
    return await taskAPI().checkUser(user);
  }

  Future<Company?> checkCompany(Company company) async {
    return await taskAPI().checkCompany(company);
  }

  Future<void> save(User user, Employee employee, Company company) async {
    dynamic getCompany = await taskAPI().saveCompany(company);
    employee.company = getCompany;
    dynamic getEmployee = await taskAPI().saveEmployee(employee);
    user.employee = getEmployee;
    bool resp = await taskAPI().saveUser(user);
    if (resp) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => Home()));
      setState(() {});
    }
  }
}
