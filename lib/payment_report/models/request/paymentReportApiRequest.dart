class PaymentReportApiRequest {
  String? orgId;
  String? startDate;
  String? endDate;
  String? orgTypeCode;

  PaymentReportApiRequest(
      {this.orgId, this.startDate, this.endDate, this.orgTypeCode});

  PaymentReportApiRequest.fromJson(Map<String, dynamic> json) {
    orgId = json['orgId'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    orgTypeCode = json['orgTypeCode'];
  }

  Map<String, String> toJson() {
    final Map<String, String> data = <String, String>{};
    data['orgId'] = orgId ?? "";
    data['startDate'] = startDate ?? "";
    data['endDate'] = endDate ?? "";
    data['orgTypeCode'] = orgTypeCode ?? "";
    return data;
  }
}
