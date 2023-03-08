import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasksystem_for_android/models/Employee.dart';
import 'package:tasksystem_for_android/models/Task.dart';

import 'ApiConstants.dart';
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
}
