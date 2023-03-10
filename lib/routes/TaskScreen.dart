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

class TaskScreen extends StatefulWidget {
  TaskScreen({super.key, required this.string});

  final String string;

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final formKey = GlobalKey<FormState>();
  List<Status>? statuses;
  late DateTimeRange dateTimeRange;
  List<DropdownMenuItem<Employee>>? dropdownvalues;
  final _textEditingController = TextEditingController();
  final _DescriptionController = TextEditingController();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  List<Subtask>? listSubtasks;
  var employee;
  User? _user;
  Task? _task;
  String? args;

  @override
  void initState() {
    getData(widget.string);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      appBar: AppBar(
        title: Text('Задача #${args}'),
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
              child: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const Padding(padding: EdgeInsets.only(top: 30)),
                        _user?.employee?.privileges == 'Admin'
                            ? SizedBox(
                                width: 350,
                                child: DropdownButtonFormField<Employee>(
                                    decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        isDense: true,
                                        labelText: 'Исполнитель'),
                                    value: employee,
                                    onChanged: (Employee? newEmployee) {
                                      setState(() {
                                        _task!.employeeId = newEmployee;
                                      });
                                    },
                                    items: dropdownvalues))
                            : SizedBox(
                                width: 350,
                                child: TextFormField(
                                  // enabled: false,
                                  readOnly: true,
                                  initialValue:
                                      '${_task!.employeeId!.name} ${_task!.employeeId!.name}',
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      isDense: true,
                                      labelText: 'Исполнитель'),
                                )),
                        const Padding(padding: EdgeInsets.only(top: 30)),
                        _user?.employee?.privileges == 'Admin'
                            ? SizedBox(
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
                                          final initialDateRange =
                                              DateTimeRange(
                                                  start: DateTime.now(),
                                                  end: DateTime.now().add(
                                                      Duration(hours: 24)));
                                          final newDate =
                                              await showDateRangePicker(
                                                  context: context,
                                                  // locale: const Locale('ru'),
                                                  firstDate: DateTime(
                                                      DateTime.now().year - 5),
                                                  lastDate: DateTime(
                                                      DateTime.now().year + 5),
                                                  initialDateRange:
                                                      dateTimeRange ??
                                                          initialDateRange);
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
                              )
                            : SizedBox(
                                width: 350,
                                child: TextFormField(
                                  // enabled: false,
                                  readOnly: true,
                                  initialValue:
                                      '${_task?.dateStart} ~ ${_task?.dateEnd}',
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      isDense: true,
                                      labelText: 'Дата начала и окончания'),
                                )),
                        const Padding(padding: EdgeInsets.only(top: 30)),
                        SizedBox(
                            width: 350,
                            child: TextFormField(
                              validator: (value) {},
                              onChanged: (value) {
                                _task?.description = value;
                                setState(() {});
                              },
                              maxLines: 5,
                              controller: _DescriptionController,
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
                                          initialValue:
                                              listSubtasks![index].description,
                                          decoration: const InputDecoration(
                                              border: OutlineInputBorder(),
                                              isDense: true,
                                              labelText: 'Описание подзадачи'),
                                        ),
                                      ),
                                      if (_user?.employee?.privileges ==
                                          'Admin')
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
                        if (_user?.employee?.privileges == 'Admin')
                          ElevatedButton(
                            onPressed: () async {
                              listSubtasks?.add(
                                  Subtask('', false, taskId: _task!.taskId));
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
                                  _task?.statusId = statuses![0];
                                } else {
                                  _task?.statusId = statuses![1];
                                }
                              } else {
                                _task?.statusId = statuses![0];
                              }
                              Task task = Task(
                                  _task!.employeeId,
                                  _user,
                                  DateFormat('dd-MM-yyyy')
                                      .format(DateTime.now()),
                                  DateFormat('dd-MM-yyyy')
                                      .format(dateTimeRange!.start),
                                  DateFormat('dd-MM-yyyy')
                                      .format(dateTimeRange!.end),
                                  _task?.statusId,
                                  description: _task?.description,
                                  listSubtask:
                                      subtaskModelToJson(listSubtasks!),
                                  taskId: _task!.taskId);
                              // print(task.toJson());
                              save(task);
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => Tasks()));
                              setState(() {});
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
    bool resp = await taskAPI().saveTask(task);
    if (resp) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => Tasks()));
      setState(() {});
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Ошибка обновления задачи')));
    }
  }

  Future<void> getUser() async {
    setState(() {});
  }

  void getData(String args) async {
    final prefs = await SharedPreferences.getInstance();
    _user = User.fromJson(jsonDecode(prefs.getString('user')!));
    statuses = await taskAPI().getStatuses();
    dropdownvalues = await taskAPI().getEmployee(_user);
    _task = await taskAPI().getTask(args);
    _textEditingController..text = '${_task!.dateStart} ~ ${_task!.dateEnd}';
    _DescriptionController..text = '${_task!.description}';
    listSubtasks = await taskAPI().getSubtasks(args);
    employee = dropdownvalues!
        .firstWhere((element) =>
            element.value?.employeeId == _task!.employeeId?.employeeId)
        .value;
    dateTimeRange = DateTimeRange(
        start: DateFormat('dd-MM-yyyy').parse(_task!.dateStart!),
        end: DateFormat('dd-MM-yyyy').parse(_task!.dateStart!));
    setState(() {});
  }
}
