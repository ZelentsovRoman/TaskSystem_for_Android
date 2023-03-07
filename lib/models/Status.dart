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
