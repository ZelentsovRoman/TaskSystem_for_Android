class Company {
  int? companyId;
  String? name;

  Company(this.name, {this.companyId});

  Company.fromJson(Map<String, dynamic> json) {
    companyId = json['companyId'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['companyId'] = this.companyId;
    data['name'] = this.name;
    return data;
  }
}
