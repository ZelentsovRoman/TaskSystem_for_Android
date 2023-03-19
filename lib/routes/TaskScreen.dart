import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:tasksystem_for_android/models/Status.dart';
import 'package:tasksystem_for_android/models/Subtask.dart';
import 'package:tasksystem_for_android/routes/EmployeeList.dart';
import 'package:tasksystem_for_android/routes/Tasks.dart';

import '../models/Employee.dart';
import '../models/Task.dart';
import '../models/User.dart';
import '../taskAPI.dart';
import 'Profile.dart';

class TaskScreen extends StatefulWidget {
  TaskScreen({super.key, required this.string});

  final String string;

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  GlobalKey<FormState> formKey1 = GlobalKey<FormState>();
  List<Status>? statuses;
  List<DropdownMenuItem<Employee>>? dropdownvalues;
  TextEditingController _textEditingController = TextEditingController();
  TextEditingController _DescriptionController = TextEditingController();
  TextEditingController _EmployeeController = TextEditingController();
  TextEditingController _PriorityController = TextEditingController();
  GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  List<Subtask>? listSubtasks;
  var employee;
  String? dateStart;
  String? dateEnd;
  User? _user;
  Task? _task;
  String? args;
  var priority;
  static const List<Tab> myTabs = <Tab>[
    Tab(child: Text('Информация о задаче')),
    Tab(child: Text('Подзадачи')),
  ];

  List<DropdownMenuItem<String>> priorities =
      <String>["Низкий", "Средний", "Высокий"].map((String value) {
    return DropdownMenuItem<String>(
      value: value,
      child: Text(value),
    );
  }).toList();
  String _range = '';
  late PickerDateRange initRange;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    updateUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            backgroundColor: const Color(0xFFF0F0F0),
            appBar: AppBar(
              title: Text('Задача #${widget.string}'),
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
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => Tasks()));
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
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => EmployeeList()));
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
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => Profile()));
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
            body: Padding(
              padding: EdgeInsets.only(top: 10, right: 10, left: 10),
              child: Column(
                children: [
                  TabBar(
                    tabs: myTabs,
                    controller: _tabController,
                    labelColor: Colors.white,
                    unselectedLabelColor: Color(0xFF2D3748),
                    indicator: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        color: Color(0xFF2D3748)),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 30)),
                  Expanded(
                      child: TabBarView(controller: _tabController, children: [
                    SafeArea(
                        child: Row(
                      children: [
                        Expanded(
                            child: Container(
                          alignment: Alignment.center,
                          child: RefreshIndicator(
                            onRefresh: getData,
                            child: Form(
                                key: formKey,
                                child: ListView(
                                  children: [
                                    Column(
                                      children: [
                                        SizedBox(
                                            width: 350,
                                            child: Row(
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Создано: ',
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                      ),
                                                    ),
                                                    const Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 30)),
                                                    Text(
                                                      'Статус: ',
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                      ),
                                                    ),
                                                    if (_user?.employee
                                                            ?.privileges !=
                                                        'Admin') ...[
                                                      const Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 30)),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            'Приоритет: ',
                                                            style: TextStyle(
                                                              fontSize: 20,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ]
                                                  ],
                                                ),
                                                const Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 30)),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      '${_task?.userId?.employee?.name ?? ""} ${_task?.userId?.employee?.lastName ?? ""}',
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                      ),
                                                    ),
                                                    const Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 30)),
                                                    Text(
                                                      '${_task?.statusId?.status ?? ''}',
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          color: _task?.statusId
                                                                      ?.statusId ==
                                                                  1
                                                              ? Colors.red
                                                              : Colors.green),
                                                    ),
                                                    if (_user?.employee
                                                            ?.privileges !=
                                                        'Admin') ...[
                                                      const Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 30)),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            '${_task?.priority ?? ''}',
                                                            style: TextStyle(
                                                                fontSize: 20,
                                                                color: priorityColor(
                                                                    '${_task?.priority}')),
                                                          ),
                                                        ],
                                                      )
                                                    ]
                                                  ],
                                                )
                                              ],
                                            )),
                                        if (_user?.employee?.privileges ==
                                            'Admin') ...[
                                          const Padding(
                                              padding:
                                                  EdgeInsets.only(top: 30)),
                                          SizedBox(
                                              width: 350,
                                              child: DropdownButtonFormField<
                                                  String?>(
                                                decoration:
                                                    const InputDecoration(
                                                        border:
                                                            OutlineInputBorder(),
                                                        isDense: true,
                                                        labelText: 'Приоритет'),
                                                value: priority,
                                                onChanged: (String? priority) {
                                                  setState(() {
                                                    _task!.priority = priority;
                                                  });
                                                },
                                                items: priorities,
                                              )),
                                        ],
                                        const Padding(
                                            padding: EdgeInsets.only(top: 30)),
                                        _user?.employee?.privileges == 'Admin'
                                            ? SizedBox(
                                                width: 350,
                                                child: DropdownButtonFormField<
                                                        Employee>(
                                                    decoration:
                                                        const InputDecoration(
                                                            border:
                                                                OutlineInputBorder(),
                                                            isDense: true,
                                                            labelText:
                                                                'Исполнитель'),
                                                    value: employee,
                                                    onChanged: (Employee?
                                                        newEmployee) {
                                                      setState(() {
                                                        _task!.employeeId =
                                                            newEmployee;
                                                      });
                                                    },
                                                    items: dropdownvalues))
                                            : SizedBox(
                                                width: 350,
                                                child: TextFormField(
                                                  // enabled: false,
                                                  readOnly: true,
                                                  controller:
                                                      _EmployeeController,
                                                  decoration:
                                                      const InputDecoration(
                                                          border:
                                                              OutlineInputBorder(),
                                                          isDense: true,
                                                          labelText:
                                                              'Исполнитель'),
                                                )),
                                        const Padding(
                                            padding: EdgeInsets.only(top: 30)),
                                        _user?.employee?.privileges == 'Admin'
                                            ? SizedBox(
                                                width: 350,
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                        child: TextFormField(
                                                      validator: (value) {
                                                        if (value?.isEmpty ??
                                                            true) {
                                                          return 'Выберите дату начала и окончания';
                                                        }
                                                        return null;
                                                      },
                                                      readOnly: true,
                                                      controller:
                                                          _textEditingController,
                                                      onChanged: (value) {
                                                        setState(() {});
                                                      },
                                                      onTap: () {
                                                        showDialog(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return AlertDialog(
                                                                  content:
                                                                      SizedBox(
                                                                width: 350,
                                                                height: 350,
                                                                child: Column(
                                                                  children: [
                                                                    SizedBox(
                                                                      child:
                                                                          SfDateRangePicker(
                                                                        startRangeSelectionColor:
                                                                            Color(0xFF2D3748),
                                                                        endRangeSelectionColor:
                                                                            Color(0xFF2D3748),
                                                                        rangeSelectionColor:
                                                                            Color(0xFFAAAEB5),
                                                                        onCancel:
                                                                            () {
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        },
                                                                        cancelText:
                                                                            'Отмена',
                                                                        confirmText:
                                                                            'Ок',
                                                                        navigationDirection:
                                                                            DateRangePickerNavigationDirection.vertical,
                                                                        monthViewSettings:
                                                                            DateRangePickerMonthViewSettings(firstDayOfWeek: 1),
                                                                        onSelectionChanged:
                                                                            (args) =>
                                                                                {
                                                                          setState(
                                                                              () {
                                                                            if (args.value
                                                                                is PickerDateRange) {
                                                                              dateStart = '${DateFormat('dd-MM-yyyy').format(args.value.startDate)}';
                                                                              dateEnd = '${DateFormat('dd-MM-yyyy').format(args.value.endDate ?? args.value.startDate)}';
                                                                            } else if (args.value
                                                                                is DateTime) {
                                                                              final DateTime selectedDate = args.value;
                                                                            } else if (args.value
                                                                                is List<DateTime>) {
                                                                              final List<DateTime> selectedDates = args.value;
                                                                            } else {
                                                                              final List<PickerDateRange> selectedRanges = args.value;
                                                                            }
                                                                            setState(() {});
                                                                          })
                                                                        },
                                                                        onSubmit:
                                                                            (value) =>
                                                                                {
                                                                          if (dateStart == null ||
                                                                              dateEnd == null)
                                                                            {
                                                                              dateStart = '${DateFormat('dd-MM-yyyy').format(initRange.startDate!)}',
                                                                              dateEnd = '${DateFormat('dd-MM-yyyy').format(initRange.endDate ?? initRange.startDate!)}'
                                                                            },
                                                                          _range =
                                                                              '${dateStart} ~ ${dateEnd}',
                                                                          _textEditingController
                                                                            ..text =
                                                                                _range,
                                                                          Navigator.of(context)
                                                                              .pop()
                                                                        },
                                                                        enablePastDates:
                                                                            false,
                                                                        maxDate:
                                                                            DateTime(DateTime.now().year +
                                                                                5),
                                                                        initialSelectedRange:
                                                                            initRange,
                                                                        showActionButtons:
                                                                            true,
                                                                        selectionMode:
                                                                            DateRangePickerSelectionMode.range,
                                                                        selectableDayPredicate: (DateTime val) => val.weekday == 6 ||
                                                                                val.weekday == 7
                                                                            ? false
                                                                            : true,
                                                                      ),
                                                                      width:
                                                                          350,
                                                                      height:
                                                                          350,
                                                                    ),
                                                                  ],
                                                                ),
                                                              ));
                                                            });
                                                      },
                                                      decoration: const InputDecoration(
                                                          border:
                                                              OutlineInputBorder(),
                                                          isDense: true,
                                                          labelText:
                                                              'Дата начала и окончания'),
                                                    )),
                                                  ],
                                                ),
                                              )
                                            : SizedBox(
                                                width: 350,
                                                child: TextFormField(
                                                  // enabled: false,
                                                  readOnly: true,
                                                  controller:
                                                      _textEditingController,
                                                  decoration: const InputDecoration(
                                                      border:
                                                          OutlineInputBorder(),
                                                      isDense: true,
                                                      labelText:
                                                          'Дата начала и окончания'),
                                                )),
                                        const Padding(
                                            padding: EdgeInsets.only(top: 30)),
                                        SizedBox(
                                            width: 350,
                                            child: TextFormField(
                                              validator: (value) {},
                                              onChanged: (value) {
                                                _task?.description = value;
                                                setState(() {});
                                              },
                                              maxLines: 5,
                                              controller:
                                                  _DescriptionController,
                                              decoration: const InputDecoration(
                                                  border: OutlineInputBorder(),
                                                  isDense: true,
                                                  labelText: 'Описание'),
                                            )),
                                        const Padding(
                                            padding: EdgeInsets.only(top: 30)),
                                        ElevatedButton(
                                          onPressed: () async {
                                            if (formKey.currentState!
                                                .validate()) {
                                              int checkboxesFilled = 0;
                                              if (listSubtasks?.length != 0) {
                                                for (Subtask item
                                                    in listSubtasks!) {
                                                  if (item.value == false) {
                                                    checkboxesFilled++;
                                                  }
                                                }
                                                if (checkboxesFilled > 0) {
                                                  _task?.statusId =
                                                      statuses![0];
                                                } else {
                                                  _task?.statusId =
                                                      statuses![1];
                                                }
                                              } else {
                                                _task?.statusId = statuses![0];
                                              }
                                              Task task = Task(
                                                  _task!.employeeId,
                                                  _user,
                                                  DateFormat('dd-MM-yyyy')
                                                      .format(DateTime.now()),
                                                  dateStart,
                                                  dateEnd,
                                                  _task?.statusId,
                                                  description:
                                                      _task!.description == ''
                                                          ? '\"\"'
                                                          : _task!.description,
                                                  listSubtask:
                                                      subtaskModelToJson(
                                                          listSubtasks!),
                                                  taskId: _task!.taskId,
                                                  priority: _task!.priority);
                                              await save(task);
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          Tasks()));
                                              setState(() {});
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Color(0xFF2D3748),
                                          ),
                                          child: const Text(
                                            'Сохранить',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                )),
                          ),
                        ))
                      ],
                    )),
                    SafeArea(
                        child: Row(
                      children: [
                        Expanded(
                            child: Container(
                          child: RefreshIndicator(
                            onRefresh: getData,
                            child: Form(
                                key: formKey1,
                                child: ListView(
                                  children: [
                                    Column(
                                      children: [
                                        const Padding(
                                            padding: EdgeInsets.only(top: 10)),
                                        SizedBox(
                                          width: 350,
                                          child: ListView.builder(
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount:
                                                  listSubtasks?.length ?? 0,
                                              itemBuilder: (context, index) {
                                                return Container(
                                                  margin: EdgeInsets.only(
                                                      bottom: 20),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      Transform.scale(
                                                        child: Checkbox(
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          2.0),
                                                            ),
                                                            side: BorderSide(
                                                                width: 1,
                                                                color: Colors
                                                                    .grey),
                                                            value:
                                                                listSubtasks?[
                                                                        index]
                                                                    .value,
                                                            activeColor: Color(
                                                                0xFF2D3748),
                                                            onChanged: (value) {
                                                              listSubtasks?[
                                                                          index]
                                                                      .value =
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
                                                            listSubtasks?[index]
                                                                    .description =
                                                                value;
                                                            setState(() {});
                                                          },
                                                          initialValue:
                                                              listSubtasks![
                                                                      index]
                                                                  .description,
                                                          decoration: const InputDecoration(
                                                              border:
                                                                  OutlineInputBorder(),
                                                              isDense: true,
                                                              labelText:
                                                                  'Описание подзадачи'),
                                                        ),
                                                      ),
                                                      if (_user?.employee
                                                              ?.privileges ==
                                                          'Admin')
                                                        IconButton(
                                                          onPressed: () {
                                                            listSubtasks!
                                                                .removeAt(
                                                                    index);
                                                            setState(() {});
                                                          },
                                                          icon: Icon(
                                                              Icons.delete),
                                                          color: Colors.grey,
                                                        ),
                                                    ],
                                                  ),
                                                );
                                              }),
                                        ),
                                        if (_user?.employee?.privileges ==
                                            'Admin')
                                          ElevatedButton(
                                            onPressed: () async {
                                              listSubtasks?.add(Subtask(
                                                  '', false,
                                                  taskId: _task!.taskId));
                                              setState(() {});
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Color(0xFF2D3748),
                                            ),
                                            child: const Text(
                                              'Добавить подзадачу',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ElevatedButton(
                                          onPressed: () async {
                                            if (formKey1.currentState!
                                                .validate()) {
                                              int checkboxesFilled = 0;
                                              if (listSubtasks?.length != 0) {
                                                for (Subtask item
                                                    in listSubtasks!) {
                                                  if (item.value == false) {
                                                    checkboxesFilled++;
                                                  }
                                                }
                                                if (checkboxesFilled > 0) {
                                                  _task?.statusId =
                                                      statuses![0];
                                                } else {
                                                  _task?.statusId =
                                                      statuses![1];
                                                }
                                              } else {
                                                _task?.statusId = statuses![0];
                                              }
                                              Task task = Task(
                                                  _task!.employeeId,
                                                  _user,
                                                  DateFormat('dd-MM-yyyy')
                                                      .format(DateTime.now()),
                                                  dateStart,
                                                  dateEnd,
                                                  _task?.statusId,
                                                  description:
                                                      _task!.description == ''
                                                          ? '\"\"'
                                                          : _task!.description,
                                                  listSubtask:
                                                      subtaskModelToJson(
                                                          listSubtasks!),
                                                  taskId: _task!.taskId,
                                                  priority: _task!.priority);
                                              await save(task);
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          Tasks()));
                                              setState(() {});
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Color(0xFF2D3748),
                                          ),
                                          child: const Text(
                                            'Сохранить',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                )),
                          ),
                        ))
                      ],
                    ))
                  ]))
                ],
              ),
            )));
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

  Future<void> getData() async {
    String args = widget.string;
    statuses = await taskAPI().getStatuses();
    dropdownvalues = await taskAPI().getEmployee(_user);
    _task = (await taskAPI().getTask(args))!;
    _textEditingController..text = '${_task!.dateStart} ~ ${_task!.dateEnd}';
    _PriorityController..text = '${_task!.priority}';
    _DescriptionController..text = '${_task!.description}';
    _EmployeeController
      ..text = '${_task!.employeeId!.name} ${_task!.employeeId!.lastName}';
    listSubtasks = await taskAPI().getSubtasks(args);
    employee = dropdownvalues!
        .firstWhere((element) =>
            element.value?.employeeId == _task!.employeeId?.employeeId)
        .value;
    priority = priorities!
        .firstWhere((element) => element.value == _task!.priority)
        .value;
    initRange = PickerDateRange(
        DateFormat('dd-MM-yyyy').parse(_task!.dateStart!),
        DateFormat('dd-MM-yyyy').parse(_task!.dateEnd!));
    dateStart = _task!.dateStart!;
    dateEnd = _task!.dateEnd!;
    setState(() {});
  }

  Future<void> updateUser() async {
    final prefs = await SharedPreferences.getInstance();
    _user = User.fromJson(jsonDecode(prefs.getString('user')!));
    String? response = await taskAPI().updateUser(_user);
    if (response == 'NOT_FOUND') {
      logout();
    } else {
      _user = User.fromJson(jsonDecode(response!));
      prefs.setString('user', response!);
      setState(() {
        getData();
      });
    }
  }

  priorityColor(String priority) {
    switch (priority) {
      case "Низкий":
        return Colors.green;
      case "Средний":
        return Colors.orange;
      case "Высокий":
        return Colors.red;
    }
  }
}
