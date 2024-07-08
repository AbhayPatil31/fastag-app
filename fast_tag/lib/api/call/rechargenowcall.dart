// To parse this JSON data, do
//
//     final rechargenowcall = rechargenowcallFromJson(jsonString);

import 'dart:convert';

Rechargenowcall rechargenowcallFromJson(String str) =>
    Rechargenowcall.fromJson(json.decode(str));

String rechargenowcallToJson(Rechargenowcall data) =>
    json.encode(data.toJson());

class Rechargenowcall {
  String? transactionType;
  String? agentId;
  String? amount;
  String? remark;
  String? transcationId;
  String? paymentMode;
  String? payment_status;

  Rechargenowcall(
      {this.transactionType,
      this.agentId,
      this.amount,
      this.remark,
      this.transcationId,
      this.paymentMode,
      this.payment_status});

  factory Rechargenowcall.fromJson(Map<String, dynamic> json) =>
      Rechargenowcall(
        transactionType: json["transaction_type"],
        agentId: json["agent_id"],
        amount: json["amount"],
        remark: json["remark"],
        transcationId: json["transcation_id"],
        paymentMode: json["payment_mode"],
        payment_status: json["payment_status"],
      );

  Map<String, dynamic> toJson() => {
        "transaction_type": transactionType,
        "agent_id": agentId,
        "amount": amount,
        "remark": remark,
        "transcation_id": transcationId,
        "payment_mode": paymentMode,
        "payment_status": payment_status,
      };
}
