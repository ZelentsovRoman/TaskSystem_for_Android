import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasksystem_for_android/models/Status.dart';
import 'package:tasksystem_for_android/models/Subtask.dart';
import 'package:tasksystem_for_android/routes/EmployeeList.dart';
import 'package:tasksystem_for_android/routes/Tasks.dart';

import '../models/Employee.dart';
import '../models/Task.dart';
import '../models/User.dart';
import '../taskAPI.dart';
import 'Profile.dart';

class AddTask extends StatefulWidget {
  const AddTask({Key? key}) : super(key: key);

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final formKey = GlobalKey<FormState>();
  Employee? employee;
  String? description;
  DateTime date = DateTime.now();
  late DateTime dateStart;
  late DateTime dateEnd;
  late Status statusId;
  List<Status>? statuses;
  DateTimeRange? dateTimeRange;
  List<DropdownMenuItem<Employee>>? dropdownvalues;
  final _textEditingController = TextEditingController();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  List<Subtask>? listSubtasks = [];
  late User _user;

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      appBar: AppBar(
        title: Text('Добавление задачи'),
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
                            child: DropdownButtonFormField<Employee>(
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    isDense: true,
                                    labelText: 'Исполнитель'),
                                value: employee,
                                onChanged: (Employee? newEmployee) {
                                  setState(() {
                                    employee = newEmployee!;
                                  });
                                },
                                items: dropdownvalues)),
                        const Padding(padding: EdgeInsets.only(top: 30)),
                        SizedBox(
                          width: 350,
                          child: Row(
                            children: [
                              Expanded(
                                  child: TextFormField(
                                validator: (value) {
                                  if (value?.isEmpty ?? true) {
                                    return 'Выберите дату начала и окончания';
                                  }
                                  return null;
                                },
                                readOnly: true,
                                controller: _textEditingController,
                                onChanged: (value) {
                                  setState(() {});
                                },
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    isDense: true,
                                    labelText: 'Дата начала и окончания'),
                              )),
                              IconButton(
                                  onPressed: () async {
                                    final initialDateRange = DateTimeRange(
                                        start: DateTime.now(),
                                        end: DateTime.now()
                                            .add(Duration(hours: 24)));
                                    final newDate = await showDateRangePicker(
                                        context: context,
                                        firstDate:
                                            DateTime(DateTime.now().year - 5),
                                        lastDate:
                                            DateTime(DateTime.now().year + 5),
                                        initialDateRange:
                                            dateTimeRange ?? initialDateRange);
                                    if (newDate != null) {
                                      dateTimeRange = newDate;
                                      _textEditingController
                                        ..text =
                                            '${DateFormat('dd-MM-yyyy').format(dateTimeRange!.start)} ~ ${DateFormat('dd-MM-yyyy').format(dateTimeRange!.end)}';
                                      setState(() {});
                                    } else
                                      return;
                                  },
                                  color: Colors.grey,
                                  icon: Icon(Icons.event))
                            ],
                          ),
                        ),
                        const Padding(padding: EdgeInsets.only(top: 30)),
                        SizedBox(
                            width: 350,
                            child: TextFormField(
                              validator: (value) {},
                              onChanged: (value) {
                                description = value;
                                setState(() {});
                              },
                              maxLines: 5,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  isDense: true,
                                  labelText: 'Описание'),
                            )),
                        const Padding(padding: EdgeInsets.only(top: 30)),
                        SizedBox(
                          width: 350,
                          child: ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: listSubtasks?.length ?? 0,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: EdgeInsets.only(bottom: 20),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Transform.scale(
                                        child: Checkbox(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(2.0),
                                            ),
                                            side: BorderSide(
                                                width: 1, color: Colors.grey),
                                            value: listSubtasks?[index].value,
                                            activeColor: Color(0xFF2D3748),
                                            onChanged: (value) {
                                              listSubtasks?[index].value =
                                                  value;
                                              setState(() {});
                                            }),
                                        scale: 2.8,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: TextFormField(
                                          validator: (value) {},
                                          onChanged: (value) {
                                            listSubtasks?[index].description =
                                                value;
                                            setState(() {});
                                          },
                                          decoration: const InputDecoration(
                                              border: OutlineInputBorder(),
                                              isDense: true,
                                              labelText: 'Описание подзадачи'),
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          listSubtasks!.removeAt(index);
                                          setState(() {});
                                        },
                                        icon: Icon(Icons.delete),
                                        color: Colors.grey,
                                      ),
                                    ],
                                  ),
                                );
                              }),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            listSubtasks?.add(Subtask('', false));
                            setState(() {});
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF2D3748),
                          ),
                          child: const Text(
                            'Добавить подзадачу',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              int checkboxesFilled = 0;
                              if (listSubtasks?.length != 0) {
                                for (Subtask item in listSubtasks!) {
                                  if (item.value == false) {
                                    checkboxesFilled++;
                                  }
                                }
                                if (checkboxesFilled > 0) {
                                  statusId = statuses![0];
                                } else {
                                  statusId = statuses![1];
                                }
                              } else {
                                statusId = statuses![0];
                              }
                              Task task = Task(
                                  employee,
                                  _user,
                                  DateFormat('dd-MM-yyyy').format(date),
                                  DateFormat('dd-MM-yyyy')
                                      .format(dateTimeRange!.start),
                                  DateFormat('dd-MM-yyyy')
                                      .format(dateTimeRange!.end),
                                  statusId,
                                  description: description ?? '\"\"',
                                  listSubtask:
                                      subtaskModelToJson(listSubtasks!));
                              await save(task);
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

  Future<void> save(Task task) async {
    bool resp = await taskAPI().saveNewTask(task);
    if (resp) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => Tasks()));
      setState(() {});
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Ошибка добавления задачи')));
    }
  }

  void getData() async {
    final prefs = await SharedPreferences.getInstance();
    _user = User.fromJson(jsonDecode(prefs.getString('user')!));
    statuses = await taskAPI().getStatuses();
    dropdownvalues = await taskAPI().getEmployee(_user);
    setState(() {});
  }
}
