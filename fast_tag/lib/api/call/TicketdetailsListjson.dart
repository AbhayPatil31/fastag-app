class TicketdetailsListjson {
  TicketdetailsListjson({
    required this.id,
   
  });
  late final String? id;
 
  
  TicketdetailsListjson.fromJson(Map<String, dynamic> json){
    id = json['id'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    return _data;
  }
}