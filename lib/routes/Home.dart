import 'package:flutter/material.dart';
import 'package:tasksystem_for_android/routes/Register.dart';
import 'package:tasksystem_for_android/taskAPI.dart';

import '../models/User.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final formKey = GlobalKey<FormState>();
  late String login;
  late String password;
  User? _user;

  Future<bool> getData(User user) async {
    dynamic temp = (await taskAPI().auth(user));
    if (temp != null) {
      _user = temp;
      return true;
    } else {
      return false;
    }
  }

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
                        const Padding(padding: EdgeInsets.only(top: 70)),
                        const Text(
                          'Авторизация',
                          style: TextStyle(
                              fontFamily: 'PT Sans Caption', fontSize: 30),
                        ),
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
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const Register()));
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Color(0xFF2D3748),
                          ),
                          child: const Text(
                            'Зарегистрироваться',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        const Padding(padding: EdgeInsets.only(top: 30)),
                        ElevatedButton(
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              User user = User(login, password);
                              if (await getData(user)) {
                                Navigator.pushNamedAndRemoveUntil(
                                    context, '/Tasks', (route) => false);
                              } else {
                                setState(() {
                                  ScaffoldMessenger.of(context)
                                      .clearSnackBars();
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text('Неверный логин или пароль')));
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF2D3748),
                          ),
                          child: const Text(
                            'Войти',
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
}
