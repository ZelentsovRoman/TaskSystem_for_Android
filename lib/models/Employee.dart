import 'dart:convert';

import 'package:flutter/material.dart';

import 'Company.dart';

List<Employee> employeeModelFromJson(String str) =>
    List<Employee>.from(json.decode(str).map((x) => Employee.fromJson(x)));

List<DropdownMenuItem<Employee>> employeeDropDownModelFromJson(String str) =>
    List<
        DropdownMenuItem<
            Employee>>.from(json.decode(str).map((x) => DropdownMenuItem(
        child: Text(
            '${Employee.fromJson(x).name} ${Employee.fromJson(x).lastName}'),
        value: Employee.fromJson(x))));

String employeeModelToJson(List<Employee> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Employee {
  int? employeeId;
  String? name;
  String? lastName;
  Company? company;
  String? privileges;

  Employee(this.name, this.lastName, this.privileges,
      {this.employeeId, this.company});

  Employee.fromJson(Map<String, dynamic> json) {
    employeeId = json['employeeId'];
    name = json['name'];
    lastName = json['lastName'];
    company =
        json['company'] != null ? new Company.fromJson(json['company']) : null;
    privileges = json['privileges'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['employeeId'] = this.employeeId;
    data['name'] = this.name;
    data['lastName'] = this.lastName;
    if (this.company != null) {
      data['company'] = this.company!.toJson();
    }
    data['privileges'] = this.privileges;
    return data;
  }
}
