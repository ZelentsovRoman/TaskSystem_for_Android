import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasksystem_for_android/models/Employee.dart';
import 'package:tasksystem_for_android/models/Task.dart';

import 'ApiConstants.dart';
import 'models/Company.dart';
import 'models/Status.dart';
import 'models/User.dart';

class taskAPI {
  Future<User?> auth(User user) async {
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.auth);
      var response = await http.post(url, body: user.toJson().toString());
      if (response.statusCode != 404) {
        user = User.fromJson(jsonDecode(response.body));
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('user', response.body);
        return user;
      } else {
        return null;
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<List<DropdownMenuItem<Employee>>?> getEmployee(User? user) async {
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.allEmployee);
      var response = await http.post(url, body: user?.toJson().toString());
      List<DropdownMenuItem<Employee>> list =
          employeeDropDownModelFromJson(response.body);
      return list;
    } catch (e) {
      log(e.toString());
    }
  }

  Future<List<Status>?> getStatuses() async {
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.getStatuses);
      var response = await http.get(url);
      List<Status> list = statusModelFromJson(response.body);
      return list;
    } catch (e) {
      log(e.toString());
    }
  }

  Future<List<Task>?> allTasks(User? user) async {
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.allTasks);
      var response = await http.post(url, body: user?.toJson().toString());
      List<Task> list = taskModelFromJson(response.body);
      return list;
    } catch (e) {
      log(e.toString());
    }
  }

  Future<List<Employee>?> allEmployee(User? user) async {
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.allEmployee);
      var response = await http.post(url, body: user?.toJson().toString());
      List<Employee> list = employeeModelFromJson(response.body);
      return list;
    } catch (e) {
      log(e.toString());
    }
  }

  Future<bool> deleteUser(Employee? employee) async {
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.deleteUser);
      var response = await http.post(url, body: employee?.toJson().toString());
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      log(e.toString());
    }
    return false;
  }

  Future<bool> deleteTask(int? index) async {
    try {
      var url =
          Uri.parse(ApiConstants.baseUrl + ApiConstants.deleteTask + '/$index');
      var response = await http.post(url);
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      log(e.toString());
    }
    return false;
  }

  Future<bool> editUser(User? user) async {
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.editUser);
      var response = await http.post(url, body: user?.toJson().toString());
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      log(e.toString());
    }
    return false;
  }

  Future<User?> checkUser(User? user) async {
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.findUser);
      var response = await http.post(url, body: user?.toJson().toString());
      if (response.statusCode == 200) {
        return User.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<String?> updateUser(User? user) async {
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.update);
      var response = await http.post(url, body: user?.toJson().toString());
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return 'NOT_FOUND';
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<Company?> checkCompany(Company? company) async {
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.getCompany);
      var response = await http.post(url, body: company?.toJson().toString());
      if (response.statusCode == 200) {
        return Company.fromJson(jsonDecode(response.body));
      } else {
        return null;
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<Employee?> saveEmployee(Employee? employee) async {
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.saveEmployee);
      var response = await http.post(url, body: employee?.toJson().toString());
      if (response.statusCode == 200) {
        return Employee.fromJson(jsonDecode(response.body));
      } else {
        return null;
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<Task?> getTask(String? index) async {
    try {
      var url =
          Uri.parse(ApiConstants.baseUrl + ApiConstants.getTask + '/${index}');
      var response = await http.get(url);
      if (response.statusCode == 200) {
        return Task.fromJson(jsonDecode(response.body));
      } else {
        return null;
      }
    } catch (e) {
      log(e.toString());
    }
  }


  Future<Company?> saveCompany(Company? company) async {
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.saveCompany);
      var response = await http.post(url, body: company?.toJson().toString());
      if (response.statusCode == 200) {
        return Company.fromJson(jsonDecode(response.body));
      } else {
        return null;
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<bool> saveUser(User? user) async {
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.saveUser);
      var response = await http.post(url, body: user?.toJson().toString());
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      log(e.toString());
    }
    return false;
  }

  Future<bool> saveTask(Task? task) async {
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.saveTask);
      var response = await http.post(url, body: task?.toJson().toString());
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      log(e.toString());
    }
    return false;
  }
}
