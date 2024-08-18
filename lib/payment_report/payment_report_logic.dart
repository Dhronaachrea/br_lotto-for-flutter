import 'package:br_lotto/payment_report/repository/payment_report_repository.dart';
import 'package:flutter/cupertino.dart';

import '../utility/result.dart';
import '../utility/user_info.dart';
import 'models/response/payment_report_reponse.dart';

class PaymentReportLogic {
  static Future<Result<dynamic>> callPaymentReportList(
      BuildContext context, Map<String, dynamic>? requestBody) async {
    Map<String, String> header = {
       "Authorization" : "Bearer ${UserInfo.userToken}"
    };

    dynamic jsonMap = await PaymentReportRepository.callPaymentReportList(
        context, requestBody, header);

    try {
      var respObj = PaymentReportResponse.fromJson(jsonMap);
      if (respObj.responseCode == 0 &&
          respObj.responseData!.statusCode != 102) {
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
