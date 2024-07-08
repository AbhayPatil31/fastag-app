class Profilejson {
  Profilejson({
    required this.id,
  });
  late final String? id;

  Profilejson.fromJson(Map<String, dynamic> json) {
    id = json['agent_id'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['agent_id'] = id;
    return _data;
  }
}
