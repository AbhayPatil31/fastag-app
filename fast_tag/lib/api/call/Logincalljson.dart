class Logincalljson {
  Logincalljson({required this.mobile_number, required this.push_token});
  late final String? mobile_number;
  String? push_token;

  Logincalljson.fromJson(Map<String, dynamic> json) {
    mobile_number = json['mobile_number'] ?? '';
    push_token = json["push_token"];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['mobile_number'] = mobile_number;
    _data["push_token"] = push_token;
    return _data;
  }
}
