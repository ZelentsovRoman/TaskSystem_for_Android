import 'dart:convert';

List<Subtask> subtaskModelFromJson(String str) =>
    List<Subtask>.from(json.decode(str).map((x) => Subtask.fromJson(x)));

String subtaskModelToJson(List<Subtask> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Subtask {
  int? subtaskId;
  String? description;
  bool? value;
  int? taskId;

  Subtask(this.description, this.value, {this.subtaskId, this.taskId});

  Subtask.fromJson(Map<String, dynamic> json) {
    subtaskId = json['subtaskId'];
    description = json['description'];
    value = json['value'];
    taskId = json['taskId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subtaskId'] = this.subtaskId;
    data['description'] = this.description;
    data['value'] = this.value;
    data['taskId'] = this.taskId;
    return data;
  }
}
