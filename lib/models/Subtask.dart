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

  Subtask(this.description, this.value, {this.taskId, this.subtaskId});

  Subtask.fromJson(Map<String, dynamic> json)
      : subtaskId = json['subtaskId'],
        description = json['description'],
        value = json['value'],
        taskId = json['taskId'];

  Map<String, dynamic> toJson() => {
        'subtaskId': subtaskId,
        'description': description,
        'value': value,
        'taskId': taskId
      };
}
