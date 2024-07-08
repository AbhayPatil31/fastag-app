class Ticketlistjson {
  Ticketlistjson({
    required this.agent_id,
   
  });
  late final String? agent_id;
 
  
  Ticketlistjson.fromJson(Map<String, dynamic> json){
    agent_id = json['agent_id'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['agent_id'] = agent_id;
    return _data;
  }
}