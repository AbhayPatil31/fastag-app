class Ticketdetailsjson {
  Ticketdetailsjson({
 required this.id,
  required this.description,
    
  });

  late final String? id;
  late final String? description;
  
  Ticketdetailsjson.fromJson(Map<String, dynamic> json){
    description = json['description'] ?? '';
    id = json['id'] ?? '';
   
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['description'] = description;
    _data['id'] = id;
  
    return _data;
  }
}