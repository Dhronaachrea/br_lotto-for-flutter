import 'package:br_lotto/l10n/l10n.dart';
import 'package:br_lotto/main.dart';
import 'package:br_lotto/summarize_ledger_report/bloc/summarize_ledger_event.dart';
import 'package:br_lotto/summarize_ledger_report/bloc/summarize_ledger_state.dart';
import 'package:br_lotto/utility/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utility/app_constant.dart';
import '../../utility/user_info.dart';
import '../model/response/summarize_date_wise_response.dart';
import '../model/response/summarize_defalut_response.dart';
import '../summarize_ledger_logic.dart';

class SummarizeLedgerBloc
    extends Bloc<SummarizeLedgerEvent, SummarizeLedgerState> {
  SummarizeLedgerBloc() : super(SummarizeLedgerInitial()) {
    on<SummarizeLedgerModel>(_getSummarizeDateWiseList);
  }

  _getSummarizeDateWiseList(
      SummarizeLedgerModel event, Emitter<SummarizeLedgerState> emit) async {
    emit(SummarizeLedgerLoading());
    BuildContext context = event.context;

    Map<String, String> param = {
      'orgId': UserInfo.organisationID,
      'startDate': event.startDate,
      'endDate': event.endDate,
      'type': event.type,
      'languageCode':  getLanguageWithContext(context),
      'appType': appType,
    };

    var response = await SummarizeLedgerLogic.getSummarizeDateWise(context, param, event.type);

    try {
      response.when(
          idle: () {},
          networkFault: (value) {
            emit(SummarizeLedgerDateWiseError(
                errorMessage: value["occurredErrorDescriptionMsg"]));
          },
          responseSuccess: (value) {
            if (event.type == "default") {
              SummarizeDefaultResponse _response = value as SummarizeDefaultResponse;
              emit(SummarizeLedgerDefaultSuccess(response: _response));
            } else {
              SummarizeDateWiseResponse _response = value as SummarizeDateWiseResponse;
              emit(SummarizeLedgerDateWiseSuccess(response: _response));
            }
          },
          responseFailure: (value) {
            var errorResponse;
            if (event.type == "default") {
              errorResponse =
              value as SummarizeDefaultResponse;
            } else {
              errorResponse =
              value as SummarizeDateWiseResponse;
            }
            print(
                "bloc responseFailure: ${errorResponse.responseData?.message} =======> ");
            emit(SummarizeLedgerDateWiseError(
                errorMessage: loadLocalizedData("RMS_${errorResponse.responseData?.statusCode ?? ""}", BrLottoRetailApp.of(context).locale.languageCode) ?? errorResponse.responseData?.message ?? ""));
          },
          failure: (value) {
            print("bloc failure: ${value["occurredErrorDescriptionMsg"]}");
            emit(SummarizeLedgerDateWiseError(
                errorMessage: value["occurredErrorDescriptionMsg"]));
          });
    } catch (e) {
      print("error=========> $e");
    }
  }
}
