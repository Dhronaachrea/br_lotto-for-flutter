class QrScanRequest {
  String? deviceId;
  String? retailerId;
  String? retailerToken;
  String? ticketNo;
  String? domainName;

  QrScanRequest(
      {this.deviceId,
      this.retailerId,
      this.retailerToken,
      this.ticketNo,
      this.domainName});

  QrScanRequest.fromJson(Map<String, dynamic> json) {
    deviceId = json['deviceId'];
    retailerId = json['retailerId'];
    retailerToken = json['retailerToken'];
    ticketNo = json['ticketNo'];
    domainName = json['domainName'];
  }

  Map<String, String> toJson() {
    final Map<String, String> data = <String, String>{};
    data['deviceId'] = deviceId ?? "";
    data['retailerId'] = retailerId ?? "";
    data['retailerToken'] = retailerToken ?? "";
    data['ticketNo'] = ticketNo ?? "";
    data['domainName'] = domainName ?? "";
    return data;
  }
}
