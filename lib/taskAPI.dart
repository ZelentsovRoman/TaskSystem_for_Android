import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasksystem_for_android/models/Employee.dart';
import 'package:tasksystem_for_android/models/Task.dart';

import 'ApiConstants.dart';
import 'models/Company.dart';
import 'models/User.dart';

class taskAPI {
  Future<User?> auth(User user) async {
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.auth);
      var response = await http.post(url, body: user.toJson().toString());
      if (response.body != '\"NOT_FOUND\"') {
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

  Future<List<Task>?> tasksForAdmin(User? user) async {
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.TaskForAdmin);
      var response = await http.post(url, body: user?.toJson().toString());
      List<Task> list = taskModelFromJson(response.body);
      return list;
    } catch (e) {
      log(e.toString());
    }
  }

  Future<List<Task>?> tasksForUser(User? user) async {
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.TaskForUser);
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
}
