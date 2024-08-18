import 'package:flutter/cupertino.dart';

abstract class PaymentReportEvent {}

class GetPaymentReportApiData extends PaymentReportEvent {
  BuildContext context;
  String? fromDate;
  String? toDate;

  GetPaymentReportApiData({required this.context, required this.fromDate, required this.toDate});
}
