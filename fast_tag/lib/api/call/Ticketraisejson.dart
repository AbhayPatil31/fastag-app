class Ticketraisejson {
  Ticketraisejson({
    required this.agent_id,
    required this.description,
    required this.help_type_id,
  });

  late final String? agent_id;
  late final String? description;
  late final String? help_type_id;

  Ticketraisejson.fromJson(Map<String, dynamic> json) {
    agent_id = json['agent_id'] ?? '';
    description = json['description'] ?? '';
    help_type_id = json['help_type_id'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['agent_id'] = agent_id;
    _data['description'] = description;
    _data['help_type_id'] = help_type_id;

    return _data;
  }
}
