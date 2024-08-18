import 'package:br_lotto/l10n/l10n.dart';
import 'package:br_lotto/main.dart';
import 'package:br_lotto/payment_report/bloc/payment_report_event.dart';
import 'package:br_lotto/payment_report/bloc/payment_report_state.dart';
import 'package:br_lotto/payment_report/payment_report_logic.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../utility/app_constant.dart';
import '../../utility/user_info.dart';
import '../models/request/paymentReportApiRequest.dart';
import '../models/response/payment_report_reponse.dart';

class PaymentReportBloc extends Bloc<PaymentReportEvent, PaymentReportState> {
  PaymentReportBloc() : super(PaymentReportInitial()) {
    on<GetPaymentReportApiData>(_onHomeEvent);
  }
}

_onHomeEvent(
    GetPaymentReportApiData event, Emitter<PaymentReportState> emit) async {
  emit(PaymentReportLoading());

  BuildContext context = event.context;
  String? toDate = event.fromDate;
  String? fromDate = event.toDate;

  var response = await PaymentReportLogic.callPaymentReportList(
      context,
      PaymentReportApiRequest(
        orgId: UserInfo.organisationID,
        startDate: toDate,
        endDate: fromDate,
        orgTypeCode: orgTypeCode,
      ).toJson());

  try {
    response.when(
        idle: () {},
        networkFault: (value) {
          emit(PaymentReportError(
              errorMessage: value["occurredErrorDescriptionMsg"]));
        },
        responseSuccess: (value) {
          PaymentReportResponse ledgerReportApiResponse = value;

          emit(PaymentReportSuccess(
              ledgerReportApiResponse: ledgerReportApiResponse));
        },
        responseFailure: (value) {
          print("bloc responseFailure:");
          PaymentReportResponse errorResponse = value as PaymentReportResponse;
          emit(PaymentReportError(errorMessage: loadLocalizedData("RMS_${errorResponse.responseData?.statusCode ?? ""}", BrLottoRetailApp.of(context).locale.languageCode) ?? errorResponse.responseData?.message ?? ""));
        },
        failure: (value) {
          print("bloc failure: ${value["occurredErrorDescriptionMsg"]}");
          emit(PaymentReportError(
              errorMessage: value["occurredErrorDescriptionMsg"]));
        });
  } catch (e) {
    print("error=========> $e");
  }
}
