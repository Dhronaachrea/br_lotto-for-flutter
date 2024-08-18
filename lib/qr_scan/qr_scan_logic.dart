import 'package:flutter/cupertino.dart';
import 'package:br_lotto/qr_scan/bloc/models/response/qrScanApiResponse.dart';
import 'package:br_lotto/qr_scan/repository/qr_scan_repository.dart';
import 'package:br_lotto/utility/result.dart';

class QrScanLogic {
  static Future<Result<dynamic>> callQrScanData(
      BuildContext context, Map<String, String> param) async {
    Map<String, String> header = {
      // "Authorization" : "Bearer ${UserInfo.userToken}"
      "Authorization": "Bearer v8RTJ0Ai21bkLoo-apZanYi7SG_-avf2t76bjXCNSQY"
    };
    // header for scratch
    /*Map<String, String> header = {
      "clientId": "RMS1",
      "clientSecret": "13f1JiFyWSZ0XI/3Plxr3mv7gbNObpU1",
      "Content-Type": headerValues['Content-Type']
    };*/

    dynamic jsonMap = await QrScanRepository.callQrScan(context, param);

    try {
      var respObj = QrScanApiResponse.fromJson(jsonMap);
      if (respObj.responseCode == 0) {
        return Result.responseSuccess(data: respObj);
      } else if (respObj.responseCode == 401 || respObj.responseCode == 100) {
        return Result.failure(data: respObj);
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
