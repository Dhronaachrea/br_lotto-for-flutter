class GetLoginDataResponse {
  int? responseCode;
  String? responseMessage;
  ResponseData? responseData;

  GetLoginDataResponse(
      {this.responseCode, this.responseMessage, this.responseData});

  GetLoginDataResponse.fromJson(Map<String, dynamic> json) {
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
  Data? data;

  ResponseData({this.message, this.statusCode, this.data});

  ResponseData.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    statusCode = json['statusCode'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['statusCode'] = this.statusCode;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? lastName;
  String? userStatus;
  String? walletType;
  String? mobileNumber;
  String? isHead;
  int? orgId;
  String? accessSelfDomainOnly;
  String? billAmount;
  String? balance;
  Null? qrCode;
  String? orgCode;
  int? parentAgtOrgId;
  int? parentMagtOrgId;
  String? creditLimit;
  String? userBalance;
  String? distributableLimit;
  String? saleBlockDate;
  String? orgTypeCode;
  String? mobileCode;
  String? orgName;
  int? userId;
  String? isAffiliate;
  int? domainId;
  String? walletMode;
  String? orgStatus;
  String? firstName;
  String? regionBinding;
  double? rawUserBalance;
  String? billNumber;
  int? parentSagtOrgId;
  String? displayCommision;
  String? username;

  Data(
      {this.lastName,
        this.userStatus,
        this.walletType,
        this.mobileNumber,
        this.isHead,
        this.orgId,
        this.accessSelfDomainOnly,
        this.billAmount,
        this.balance,
        this.qrCode,
        this.orgCode,
        this.parentAgtOrgId,
        this.parentMagtOrgId,
        this.creditLimit,
        this.userBalance,
        this.distributableLimit,
        this.saleBlockDate,
        this.orgTypeCode,
        this.mobileCode,
        this.orgName,
        this.userId,
        this.isAffiliate,
        this.domainId,
        this.walletMode,
        this.orgStatus,
        this.firstName,
        this.regionBinding,
        this.rawUserBalance,
        this.billNumber,
        this.parentSagtOrgId,
        this.displayCommision,
        this.username});

  Data.fromJson(Map<String, dynamic> json) {
    lastName = json['lastName'];
    userStatus = json['userStatus'];
    walletType = json['walletType'];
    mobileNumber = json['mobileNumber'];
    isHead = json['isHead'];
    orgId = json['orgId'];
    accessSelfDomainOnly = json['accessSelfDomainOnly'];
    billAmount = json['billAmount'];
    balance = json['balance'];
    qrCode = json['qrCode'];
    orgCode = json['orgCode'];
    parentAgtOrgId = json['parentAgtOrgId'];
    parentMagtOrgId = json['parentMagtOrgId'];
    creditLimit = json['creditLimit'];
    userBalance = json['userBalance'];
    distributableLimit = json['distributableLimit'];
    saleBlockDate = json['saleBlockDate'];
    orgTypeCode = json['orgTypeCode'];
    mobileCode = json['mobileCode'];
    orgName = json['orgName'];
    userId = json['userId'];
    isAffiliate = json['isAffiliate'];
    domainId = json['domainId'];
    walletMode = json['walletMode'];
    orgStatus = json['orgStatus'];
    firstName = json['firstName'];
    regionBinding = json['regionBinding'];
    rawUserBalance = json['rawUserBalance'];
    billNumber = json['billNumber'];
    parentSagtOrgId = json['parentSagtOrgId'];
    displayCommision = json['displayCommision'];
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lastName'] = this.lastName;
    data['userStatus'] = this.userStatus;
    data['walletType'] = this.walletType;
    data['mobileNumber'] = this.mobileNumber;
    data['isHead'] = this.isHead;
    data['orgId'] = this.orgId;
    data['accessSelfDomainOnly'] = this.accessSelfDomainOnly;
    data['billAmount'] = this.billAmount;
    data['balance'] = this.balance;
    data['qrCode'] = this.qrCode;
    data['orgCode'] = this.orgCode;
    data['parentAgtOrgId'] = this.parentAgtOrgId;
    data['parentMagtOrgId'] = this.parentMagtOrgId;
    data['creditLimit'] = this.creditLimit;
    data['userBalance'] = this.userBalance;
    data['distributableLimit'] = this.distributableLimit;
    data['saleBlockDate'] = this.saleBlockDate;
    data['orgTypeCode'] = this.orgTypeCode;
    data['mobileCode'] = this.mobileCode;
    data['orgName'] = this.orgName;
    data['userId'] = this.userId;
    data['isAffiliate'] = this.isAffiliate;
    data['domainId'] = this.domainId;
    data['walletMode'] = this.walletMode;
    data['orgStatus'] = this.orgStatus;
    data['firstName'] = this.firstName;
    data['regionBinding'] = this.regionBinding;
    data['rawUserBalance'] = this.rawUserBalance;
    data['billNumber'] = this.billNumber;
    data['parentSagtOrgId'] = this.parentSagtOrgId;
    data['displayCommision'] = this.displayCommision;
    data['username'] = this.username;
    return data;
  }
}



/*
* {
  "responseCode": 0,
  "responseMessage": "Success",
  "responseData": {
    "message": "Success",
    "statusCode": 0,
    "data": {
      "lastName": "reet",
      "userStatus": "ACTIVE",
      "walletType": "POSTPAID",
      "mobileNumber": "2324243443",
      "isHead": "YES",
      "orgId": 179,
      "accessSelfDomainOnly": "YES",
      "billAmount": "3975.0",
      "balance": "-3 975,00 ",
      "qrCode": null,
      "orgCode": "0011",
      "parentAgtOrgId": 174,
      "parentMagtOrgId": 139,
      "creditLimit": "0,00 ",
      "userBalance": "-4 025,00 ",
      "distributableLimit": "0,00 ",
      "saleBlockDate": "03/08/2023",
      "orgTypeCode": "RET",
      "mobileCode": "+380",
      "orgName": "shobhareet",
      "userId": 392,
      "isAffiliate": "NO",
      "domainId": 1,
      "walletMode": "SALE",
      "orgStatus": "ACTIVE",
      "firstName": "shobha",
      "regionBinding": "REGION",
      "rawUserBalance": -4025.0,
      "billNumber": "INV23073000AAAB",
      "parentSagtOrgId": 0,
      "displayCommision": "0.0",
      "username": "shobhareet"
    }
  }
}
*
*
* */