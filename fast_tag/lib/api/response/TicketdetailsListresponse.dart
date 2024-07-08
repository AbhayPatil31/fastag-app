// To parse this JSON data, do
//
//     final ticketdetailsListresponse = ticketdetailsListresponseFromJson(jsonString);

import 'dart:convert';

List<TicketdetailsListresponse> ticketdetailsListresponseFromJson(String str) =>
    List<TicketdetailsListresponse>.from(
        json.decode(str).map((x) => TicketdetailsListresponse.fromJson(x)));

String ticketdetailsListresponseToJson(List<TicketdetailsListresponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TicketdetailsListresponse {
  String? status;
  String? message;
  Ticket? ticket;
  List<Reply>? reply;

  TicketdetailsListresponse({
    this.status,
    this.message,
    this.ticket,
    this.reply,
  });

  factory TicketdetailsListresponse.fromJson(Map<String, dynamic> json) =>
      TicketdetailsListresponse(
        status: json["status"],
        message: json["message"],
        ticket: json["ticket"] == null ? null : Ticket.fromJson(json["ticket"]),
        reply: json["reply"] == null
            ? []
            : List<Reply>.from(json["reply"]!.map((x) => Reply.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "ticket": ticket?.toJson(),
        "reply": reply == null
            ? []
            : List<dynamic>.from(reply!.map((x) => x.toJson())),
      };
}

class Reply {
  String? id;
  String? description;
  String? ticketId;
  String? replyBy;
  String? replyDate;
  String? status;
  String? isDeleted;
  DateTime? createdOn;
  DateTime? updatedOn;

  Reply({
    this.id,
    this.description,
    this.ticketId,
    this.replyBy,
    this.replyDate,
    this.status,
    this.isDeleted,
    this.createdOn,
    this.updatedOn,
  });

  factory Reply.fromJson(Map<String, dynamic> json) => Reply(
        id: json["id"],
        description: json["description"],
        ticketId: json["ticket_id"],
        replyBy: json["reply_by"],
        replyDate: json["reply_date"],
        // replyDate: json["reply_date"] == null
        //     ? null
        //     : DateTime.parse(json["reply_date"]),
        status: json["status"],
        isDeleted: json["is_deleted"],
        createdOn: json["created_on"] == null
            ? null
            : DateTime.parse(json["created_on"]),
        updatedOn: json["updated_on"] == null
            ? null
            : DateTime.parse(json["updated_on"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "description": description,
        "ticket_id": ticketId,
        "reply_by": replyBy,
        "reply_date": replyDate,
        // "reply_date":
        //     "${replyDate!.year.toString().padLeft(4, '0')}-${replyDate!.month.toString().padLeft(2, '0')}-${replyDate!.day.toString().padLeft(2, '0')}",
        "status": status,
        "is_deleted": isDeleted,
        "created_on": createdOn?.toIso8601String(),
        "updated_on": updatedOn?.toIso8601String(),
      };
}

class Ticket {
  String? id;
  String? agentId;
  String? ticketNumber;
  DateTime? ticketCreateDate;
  String? ticketStatus;
  String? description;
  String? attachment;
  String? helpTypeId;
  String? status;
  String? isDeleted;
  String? createdOn;
  DateTime? updatedOn;
  String? helpTypeName;

  Ticket({
    this.id,
    this.agentId,
    this.ticketNumber,
    this.ticketCreateDate,
    this.ticketStatus,
    this.description,
    this.attachment,
    this.helpTypeId,
    this.status,
    this.isDeleted,
    this.createdOn,
    this.updatedOn,
    this.helpTypeName,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) => Ticket(
        id: json["id"],
        agentId: json["agent_id"],
        ticketNumber: json["ticket_number"],
        ticketCreateDate: json["ticket_create_date"] == null
            ? null
            : DateTime.parse(json["ticket_create_date"]),
        ticketStatus: json["ticket_status"],
        description: json["description"],
        attachment: json["attachment"],
        helpTypeId: json["help_type_id"],
        status: json["status"],
        isDeleted: json["is_deleted"],
        createdOn: json["created_on"],
        updatedOn: json["updated_on"] == null
            ? null
            : DateTime.parse(json["updated_on"]),
        helpTypeName: json["help_type_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "agent_id": agentId,
        "ticket_number": ticketNumber,
        "ticket_create_date":
            "${ticketCreateDate!.year.toString().padLeft(4, '0')}-${ticketCreateDate!.month.toString().padLeft(2, '0')}-${ticketCreateDate!.day.toString().padLeft(2, '0')}",
        "ticket_status": ticketStatus,
        "description": description,
        "attachment": attachment,
        "help_type_id": helpTypeId,
        "status": status,
        "is_deleted": isDeleted,
        "created_on": createdOn,
        "updated_on": updatedOn?.toIso8601String(),
        "help_type_name": helpTypeName,
      };
}
