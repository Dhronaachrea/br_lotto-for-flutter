

import '../models/response/payment_report_reponse.dart';

abstract class PaymentReportState {}

class PaymentReportInitial extends PaymentReportState {}

class PaymentReportLoading extends PaymentReportState{}

class PaymentReportSuccess extends PaymentReportState{
  PaymentReportResponse ledgerReportApiResponse;

  PaymentReportSuccess({required this.ledgerReportApiResponse});

}
class PaymentReportError extends PaymentReportState{
  String errorMessage;

  PaymentReportError({required this.errorMessage});
}