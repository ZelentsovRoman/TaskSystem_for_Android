import 'dart:convert';

import 'package:tasksystem_for_android/models/Employee.dart';
import 'package:tasksystem_for_android/models/Status.dart';
import 'package:tasksystem_for_android/models/User.dart';

List<Task> taskModelFromJson(String str) =>
    List<Task>.from(json.decode(str).map((x) => Task.fromJson(x)));

String taskModelToJson(List<Task> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Task {
  Employee? employeeId;
  User? userId;
  int? taskId;
  String? description;
  String? date;
  String? dateStart;
  String? dateEnd;
  Status? statusId;

  Task(
      {this.employeeId,
      this.userId,
      this.taskId,
      this.description,
      this.date,
      this.dateStart,
      this.dateEnd,
      this.statusId});

  Task.fromJson(Map<String, dynamic> json) {
    employeeId = json['employeeId'] != null
        ? new Employee.fromJson(json['employeeId'])
        : null;
    userId = json['userId'] != null ? new User.fromJson(json['userId']) : null;
    taskId = json['taskId'];
    description = json['description'];
    date = json['date'];
    dateStart = json['dateStart'];
    dateEnd = json['dateEnd'];
    statusId =
        json['statusId'] != null ? new Status.fromJson(json['statusId']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.employeeId != null) {
      data['employeeId'] = this.employeeId!.toJson();
    }
    if (this.userId != null) {
      data['userId'] = this.userId!.toJson();
    }
    data['taskId'] = this.taskId;
    data['description'] = this.description;
    data['date'] = this.date;
    data['dateStart'] = this.dateStart;
    data['dateEnd'] = this.dateEnd;
    if (this.statusId != null) {
      data['statusId'] = this.statusId!.toJson();
    }
    return data;
  }
}
