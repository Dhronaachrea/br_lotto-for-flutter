import 'dart:convert';

import 'package:br_lotto/home/models/response/UserMenuApiResponse.dart';
import 'package:br_lotto/network/api_base_url.dart';
import 'package:br_lotto/network/api_relative_urls.dart';
import 'package:br_lotto/scratch/inventory/inventory_flow/model/response/inv_flow_response.dart';
import 'package:br_lotto/scratch/inventory/inventory_flow/repository/inv_flow_repository.dart';
import 'package:br_lotto/utility/app_constant.dart';
import 'package:br_lotto/utility/result.dart';
import 'package:flutter/material.dart';

class InvFlowLogic {
  static Future<Result<dynamic>> callInvFlowReportAPI(BuildContext context,
      MenuBeanList? menuBeanList, Map<String, String> param) async {
    Map apiDetails = json.decode(menuBeanList?.apiDetails ?? "");
    String? endUrl = apiDetails[apiDetails.keys.first]['url'];
    Map headerValues = apiDetails[apiDetails.keys.first]['headers'];
    Map<String, String> header = {
      "clientId": scratchClientId /*headerValues['clientId']*/,
      "clientSecret": scratchClientSecret //merchantPwd ,  /*headerValues['clientSecret']*/
    };

    dynamic jsonMap = await InvFlowRepository.callInvFlowReportAPI(
        context,
        param,
        header,
        scratchUrl,//menuBeanList!.basePath ?? "https://rms-wls.infinitilotto.com/PPL",
        inventoryFlowReportUrl, // endUrl ?? "/reports/inventoryFlowReport",
    );

    try {
      var respObj = InvFlowResponse.fromJson(jsonMap);
      if (respObj.responseCode == 1000) {
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
