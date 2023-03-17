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

class AddTask extends StatefulWidget {
  const AddTask({Key? key}) : super(key: key);

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> with SingleTickerProviderStateMixin {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late TabController _tabController;
  Employee? employee;
  String description = '';
  DateTime date = DateTime.now();
  String? dateStart;
  String? dateEnd;
  Status? statusId;
  var priority;
  bool form = false;
  List<Status>? statuses;
  late dynamic phys = NeverScrollableScrollPhysics();
  DateTimeRange? dateTimeRange;
  List<DropdownMenuItem<Employee>>? dropdownvalues;
  final _textEditingController = TextEditingController();
  List<Subtask>? listSubtasks = [];
  late User _user;
  List<DropdownMenuItem<String>> priorities =
      <String>["Низкий", "Средний", "Высокий"].map((String value) {
    return DropdownMenuItem<String>(
      value: value,
      child: Text(value),
    );
  }).toList();
  static const List<Tab> myTabs = <Tab>[
    Tab(child: Text('Информация о задаче')),
    Tab(child: Text('Подзадачи')),
  ];
  String _range = '';
  PickerDateRange initRange = PickerDateRange(
      DateTime.now(),
      DateTime.now().add(Duration(days: 1)).weekday == 6
          ? DateTime.now().add(Duration(days: 3))
          : DateTime.now().add(Duration(days: 1)));

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    updateUser();
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
      body: Padding(
        padding: EdgeInsets.only(top: 10, left: 10, right: 10),
        child: Column(
          children: [
            TabBar(
              tabs: myTabs,
              onTap: (index) {
                if (index == 1) {
                  setState(() {
                    if (formKey.currentState!.validate()) {
                      _tabController.index = index;
                    } else
                      _tabController.index = 0;
                  });
                }
              },
              controller: _tabController,
              labelColor: Colors.white,
              unselectedLabelColor: Color(0xFF2D3748),
              indicator: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                  color: Color(0xFF2D3748)),
            ),
            Expanded(
                child: TabBarView(
                    controller: _tabController,
                    physics: phys,
                    children: [
                  SafeArea(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                          child: Form(
                              onChanged: () => {
                                    if (formKey.currentState!.validate())
                                      {
                                        phys = ClampingScrollPhysics(),
                                        form = true
                                      }
                                  },
                              key: formKey,
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    SizedBox(
                                        width: 350,
                                        child: DropdownButtonFormField<String?>(
                                          decoration: const InputDecoration(
                                              border: OutlineInputBorder(),
                                              isDense: true,
                                              labelText: 'Приоритет'),
                                          value: priority,
                                          onChanged: (String? prior) {
                                            setState(() {
                                              priority = prior;
                                            });
                                          },
                                          items: priorities,
                                        )),
                                    const Padding(
                                        padding: EdgeInsets.only(top: 30)),
                                    SizedBox(
                                        width: 350,
                                        child: DropdownButtonFormField<
                                                Employee>(
                                            decoration: const InputDecoration(
                                                border: OutlineInputBorder(),
                                                isDense: true,
                                                labelText: 'Исполнитель'),
                                            validator: (element) {
                                              if (element == null) {
                                                return 'Выберите исполнителя';
                                              }
                                              return null;
                                            },
                                            value: employee,
                                            onChanged: (Employee? newEmployee) {
                                              setState(() {
                                                employee = newEmployee!;
                                              });
                                            },
                                            items: dropdownvalues)),
                                    const Padding(
                                        padding: EdgeInsets.only(top: 30)),
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
                                            onTap: () {
                                              showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                        content: SizedBox(
                                                      width: 350,
                                                      height: 350,
                                                      child: Column(
                                                        children: [
                                                          SizedBox(
                                                            child:
                                                                SfDateRangePicker(
                                                              startRangeSelectionColor:
                                                                  Color(
                                                                      0xFF2D3748),
                                                              endRangeSelectionColor:
                                                                  Color(
                                                                      0xFF2D3748),
                                                              rangeSelectionColor:
                                                                  Color(
                                                                      0xFFAAAEB5),
                                                              onCancel: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              navigationDirection:
                                                                  DateRangePickerNavigationDirection
                                                                      .vertical,
                                                              monthViewSettings:
                                                                  DateRangePickerMonthViewSettings(
                                                                      firstDayOfWeek:
                                                                          1),
                                                              onSelectionChanged:
                                                                  (args) => {
                                                                setState(() {
                                                                  if (args.value
                                                                      is PickerDateRange) {
                                                                    dateStart =
                                                                        '${DateFormat('dd-MM-yyyy').format(args.value.startDate)}';
                                                                    dateEnd =
                                                                        '${DateFormat('dd-MM-yyyy').format(args.value.endDate ?? args.value.startDate)}';
                                                                  } else if (args
                                                                          .value
                                                                      is DateTime) {
                                                                    final DateTime
                                                                        selectedDate =
                                                                        args.value;
                                                                  } else if (args
                                                                          .value
                                                                      is List<
                                                                          DateTime>) {
                                                                    final List<
                                                                            DateTime>
                                                                        selectedDates =
                                                                        args.value;
                                                                  } else {
                                                                    final List<
                                                                            PickerDateRange>
                                                                        selectedRanges =
                                                                        args.value;
                                                                  }
                                                                  setState(
                                                                      () {});
                                                                })
                                                              },
                                                              onSubmit:
                                                                  (value) => {
                                                                if (dateStart ==
                                                                        null ||
                                                                    dateEnd ==
                                                                        null)
                                                                  {
                                                                    dateStart =
                                                                        '${DateFormat('dd-MM-yyyy').format(initRange.startDate!)}',
                                                                    dateEnd =
                                                                        '${DateFormat('dd-MM-yyyy').format(initRange.endDate ?? initRange.startDate!)}'
                                                                  },
                                                                _range =
                                                                    '${dateStart} ~ ${dateEnd}',
                                                                _textEditingController
                                                                  ..text =
                                                                      _range,
                                                                Navigator.of(
                                                                        context)
                                                                    .pop()
                                                              },
                                                              enablePastDates:
                                                                  false,
                                                              maxDate: DateTime(
                                                                  DateTime.now()
                                                                          .year +
                                                                      5),
                                                              initialSelectedRange:
                                                                  initRange,
                                                              showActionButtons:
                                                                  true,
                                                              selectionMode:
                                                                  DateRangePickerSelectionMode
                                                                      .range,
                                                              selectableDayPredicate: (DateTime
                                                                      val) =>
                                                                  val.weekday ==
                                                                              6 ||
                                                                          val.weekday ==
                                                                              7
                                                                      ? false
                                                                      : true,
                                                            ),
                                                            width: 350,
                                                            height: 350,
                                                          ),
                                                        ],
                                                      ),
                                                    ));
                                                  });
                                            },
                                            decoration: const InputDecoration(
                                                border: OutlineInputBorder(),
                                                isDense: true,
                                                labelText:
                                                    'Дата начала и окончания'),
                                          )),
                                        ],
                                      ),
                                    ),
                                    const Padding(
                                        padding: EdgeInsets.only(top: 30)),
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
                                    const Padding(
                                        padding: EdgeInsets.only(top: 30)),
                                    ElevatedButton(
                                      onPressed: () async {
                                        if (formKey.currentState!.validate()) {
                                          int checkboxesFilled = 0;
                                          if (listSubtasks?.length != 0) {
                                            for (Subtask item
                                                in listSubtasks!) {
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
                                              DateFormat('dd-MM-yyyy')
                                                  .format(date),
                                              dateStart,
                                              dateEnd,
                                              statusId,
                                              description: description == ''
                                                  ? '\"\"'
                                                  : description,
                                              priority: priority,
                                              listSubtask: subtaskModelToJson(
                                                  listSubtasks!));
                                          // print(task.toJson().toString());
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
                  SafeArea(
                      child: Row(
                    children: [
                      Expanded(
                          child: ListView(
                        children: [
                          Column(
                            children: [
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
                                                        BorderRadius.circular(
                                                            2.0),
                                                  ),
                                                  side: BorderSide(
                                                      width: 1,
                                                      color: Colors.grey),
                                                  value: listSubtasks?[index]
                                                      .value,
                                                  activeColor:
                                                      Color(0xFF2D3748),
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
                                                  listSubtasks?[index]
                                                      .description = value;
                                                  setState(() {});
                                                },
                                                decoration: const InputDecoration(
                                                    border:
                                                        OutlineInputBorder(),
                                                    isDense: true,
                                                    labelText:
                                                        'Описание подзадачи'),
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
                                      dateStart,
                                      dateEnd,
                                      statusId,
                                      description: description == ''
                                          ? '\"\"'
                                          : description,
                                      priority: priority,
                                      listSubtask:
                                          subtaskModelToJson(listSubtasks!));
                                  // print(task.toJson().toString());
                                  await save(task);
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
                          )
                        ],
                      ))
                    ],
                  ))
                ]))
          ],
        ),
      ),
    );
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    setState(() {});
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
    statuses = await taskAPI().getStatuses();
    dropdownvalues = await taskAPI().getEmployee(_user);
    priority = priorities.first.value;
    setState(() {});
  }
}
