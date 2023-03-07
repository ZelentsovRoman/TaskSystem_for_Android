import 'dart:convert';

List<Subtask> subtaskModelFromJson(String str) =>
    List<Subtask>.from(json.decode(str).map((x) => Subtask.fromJson(x)));

String subtaskModelToJson(List<Subtask> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Subtask {
  final int subtaskId;
  final String description;
  final bool value;
  final int taskId;

  Subtask(this.subtaskId, this.description, this.value, this.taskId);

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
