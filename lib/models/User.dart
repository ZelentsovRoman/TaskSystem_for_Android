import 'Employee.dart';

class User {
  int? userId;
  Employee? employee;
  String? login;
  String? password;

  User(this.login, this.password, {this.employee, this.userId});

  User.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    employee = json['employee'] != null
        ? new Employee.fromJson(json['employee'])
        : null;
    login = json['login'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    if (this.employee != null) {
      data['employee'] = this.employee!.toJson();
    }
    data['login'] = this.login;
    data['password'] = this.password;
    return data;
  }
}
