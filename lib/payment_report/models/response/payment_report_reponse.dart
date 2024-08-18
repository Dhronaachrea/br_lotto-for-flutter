class PaymentReportResponse {
  int? responseCode;
  String? responseMessage;
  ResponseData? responseData;

  PaymentReportResponse(
      {this.responseCode, this.responseMessage, this.responseData});

  PaymentReportResponse.fromJson(Map<String, dynamic> json) {
    responseCode = json['responseCode'];
    responseMessage = json['responseMessage'];
    responseData = json['responseData'] != null
        ? new ResponseData.fromJson(json['responseData'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['responseCode'] = this.responseCode;
    data['responseMessage'] = this.responseMessage;
    if (this.responseData != null) {
      data['responseData'] = this.responseData!.toJson();
    }
    return data;
  }
}

class ResponseData {
  String? message;
  int? statusCode;
  List<Data>? data;

  ResponseData({this.message, this.statusCode, this.data});

  ResponseData.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    statusCode = json['statusCode'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['statusCode'] = this.statusCode;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? orgName;
  int? orgId;
  List<Transaction>? transaction;

  Data({this.orgName, this.orgId, this.transaction});

  Data.fromJson(Map<String, dynamic> json) {
    orgName = json['orgName'];
    orgId = json['orgId'];
    if (json['transaction'] != null) {
      transaction = <Transaction>[];
      json['transaction'].forEach((v) {
        transaction!.add(new Transaction.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orgName'] = this.orgName;
    data['orgId'] = this.orgId;
    if (this.transaction != null) {
      data['transaction'] = this.transaction!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Transaction {
  String? createdAt;
  String? txnValue;
  String? narration;
  String? balancePostTxn;
  String? txnType;
  String? txnBy;
  String? userId;
  String? orgDueAmount;
  String? txnId;

  Transaction(
      {this.createdAt,
        this.txnValue,
        this.narration,
        this.balancePostTxn,
        this.txnType,
        this.txnBy,
        this.userId,
        this.orgDueAmount,
        this.txnId});

  Transaction.fromJson(Map<String, dynamic> json) {
    createdAt = json['createdAt'];
    txnValue = json['txnValue'];
    narration = json['narration'];
    balancePostTxn = json['balancePostTxn'];
    txnType = json['txnType'];
    txnBy = json['txnBy'];
    userId = json['userId'];
    orgDueAmount = json['orgDueAmount'];
    txnId = json['txnId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createdAt'] = this.createdAt;
    data['txnValue'] = this.txnValue;
    data['narration'] = this.narration;
    data['balancePostTxn'] = this.balancePostTxn;
    data['txnType'] = this.txnType;
    data['txnBy'] = this.txnBy;
    data['userId'] = this.userId;
    data['orgDueAmount'] = this.orgDueAmount;
    data['txnId'] = this.txnId;
    return data;
  }
}
