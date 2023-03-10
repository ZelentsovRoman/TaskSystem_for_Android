import 'dart:convert';

List<Status> statusModelFromJson(String str) =>
    List<Status>.from(json.decode(str).map((x) => Status.fromJson(x)));

String statusModelToJson(List<Status> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Status {
  final int statusId;
  final String status;

  Status(this.statusId, this.status);

  Status.fromJson(Map<String, dynamic> json)
      : statusId = json['statusId'],
        status = json['status'];

  Map<String, dynamic> toJson() => {
    'statusId': statusId,
    'status': status,
  };
}
