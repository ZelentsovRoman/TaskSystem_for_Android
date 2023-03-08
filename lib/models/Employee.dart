import 'dart:convert';

import 'Company.dart';

List<Employee> employeeModelFromJson(String str) =>
    List<Employee>.from(json.decode(str).map((x) => Employee.fromJson(x)));

String employeeModelToJson(List<Employee> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Employee {
  int? employeeId;
  String? name;
  String? lastName;
  Company? company;
  String? privileges;

  Employee(
      {this.employeeId,
      this.name,
      this.lastName,
    this.company,
    this.privileges});

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
