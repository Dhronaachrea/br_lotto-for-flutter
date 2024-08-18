import 'package:br_lotto/summarize_ledger_report/repository/summarize_ledger_repository.dart';
import 'package:flutter/cupertino.dart';
import '../utility/result.dart';
import '../utility/user_info.dart';
import 'model/response/summarize_date_wise_response.dart';
import 'model/response/summarize_defalut_response.dart';

class SummarizeLedgerLogic {
  static Future<Result<dynamic>> getSummarizeDateWise(
      BuildContext context, Map<String, dynamic>? params, String type) async {
    Map<String, String> header = {
      "Authorization": "Bearer ${UserInfo.userToken}"
    };

    dynamic jsonMap = await SummarizeLedgerRepository.getSummarizeLedgerReport(
        context, header, "", params);

    try {
      var respObj;

      if (type == "default") {
        respObj = SummarizeDefaultResponse.fromJson(jsonMap);
      } else {
        respObj = SummarizeDateWiseResponse.fromJson(jsonMap);
      }
      if (respObj.responseCode == 0 && respObj.responseData?.statusCode == 0) {
        return Result.responseSuccess(data: respObj);
      } else {
        return jsonMap["occurredErrorDescriptionMsg"] != null
            ? jsonMap["occurredErrorDescriptionMsg"] == "No connection"
                ? Result.networkFault(data: jsonMap)
                : Result.failure(data: jsonMap)
            : Result.responseFailure(data: respObj);
      }
    } catch (e) {
      if (jsonMap["occurredErrorDescriptionMsg"] == "No connection") {
        return Result.networkFault(data: jsonMap);
      } else {
        return Result.failure(
            data: jsonMap["occurredErrorDescriptionMsg"] != null
                ? jsonMap
                : {"occurredErrorDescriptionMsg": e});
      }
    }
  }
}
