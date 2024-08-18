// To parse this JSON data, do
//
//     final qrScanApiResponse = qrScanApiResponseFromJson(jsonString);

import 'dart:convert';

QrScanApiResponse qrScanApiResponseFromJson(String str) => QrScanApiResponse.fromJson(json.decode(str));

String qrScanApiResponseToJson(QrScanApiResponse data) => json.encode(data.toJson());

class QrScanApiResponse {
  dynamic responseCode;
  dynamic responseMessage;
  var responseData;

  QrScanApiResponse({
    required this.responseCode,
    required this.responseMessage,
    required this.responseData,
  });

  factory QrScanApiResponse.fromJson(Map<String, dynamic> json) => QrScanApiResponse(
    responseCode: json["responseCode"],
    responseMessage: json["responseMessage"],
    responseData: json["responseData"] != null ? ResponseData.fromJson(json["responseData"]) : null,
  );

  Map<String, dynamic> toJson() => {
    "responseCode": responseCode,
    "responseMessage": responseMessage,
    "responseData": responseData.toJson(),
  };
}

class ResponseData {
  dynamic transactionStatus;
  dynamic message;
  dynamic ticketNumber;
  dynamic orderId;
  dynamic itemId;
  dynamic playerId;
  dynamic drawId;
  dynamic totalSaleAmount;
  DateTime transactionDateTime;

  ResponseData({
    required this.transactionStatus,
    required this.message,
    required this.ticketNumber,
    required this.orderId,
    required this.itemId,
    required this.playerId,
    required this.drawId,
    required this.totalSaleAmount,
    required this.transactionDateTime,
  });

  factory ResponseData.fromJson(Map<String, dynamic> json) => ResponseData(
    transactionStatus: json["transactionStatus"],
    message: json["message"],
    ticketNumber: json["ticketNumber"],
    orderId: json["orderId"],
    itemId: json["itemId"],
    playerId: json["playerId"],
    drawId: json["drawId"],
    totalSaleAmount: json["totalSaleAmount"],
    transactionDateTime: DateTime.parse(json["transactionDateTime"]),
  );

  Map<String, dynamic> toJson() => {
    "transactionStatus": transactionStatus,
    "message": message,
    "ticketNumber": ticketNumber,
    "orderId": orderId,
    "itemId": itemId,
    "playerId": playerId,
    "drawId": drawId,
    "totalSaleAmount": totalSaleAmount,
    "transactionDateTime": transactionDateTime.toIso8601String(),
  };
}
