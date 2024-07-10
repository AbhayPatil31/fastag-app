import 'dart:io';

class Ticketraisejson {
  Ticketraisejson({
    required this.agent_id,
    required this.description,
    required this.help_type_id,
    this.attachement,
  });

  String? agent_id;
  String? description;
  String? help_type_id;
  String? attachement; // Store the path as a string

  Ticketraisejson.fromJson(Map<String, dynamic> json) {
    agent_id = json['agent_id'] ?? '';
    description = json['description'] ?? '';
    help_type_id = json['help_type_id'] ?? '';
    attachement = json['attachement'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['agent_id'] = agent_id;
    _data['description'] = description;
    _data['help_type_id'] = help_type_id;
    _data['attachement'] = attachement; // Add the image path to the JSON

    return _data;
  }
}
