import 'package:flutter/material.dart';

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
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(
                                    'Проверка $name $lastName $company $login $password'),
                                backgroundColor: Colors.black,
                              ));
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
}
