import 'dart:convert';
import 'package:br_lotto/network/api_base_url.dart';
import 'package:br_lotto/utility/app_constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:br_lotto/scratch/packOrder/model/game_details_response.dart';
import 'package:br_lotto/scratch/packOrder/repository/game_details_repository.dart';
import 'package:br_lotto/utility/result.dart';

import '../../network/api_relative_urls.dart';

class GameDetailsLogic {
  static Future<Result<dynamic>> callGameDetailsData(BuildContext context, Map<String, dynamic> param, var scratchList) async {
    Map apiDetails = json.decode(scratchList.apiDetails);
    String endUrl = gameDetailsForQuickOrderUrl; //apiDetails['gameList']['url'];
    Map headerValues = apiDetails[apiDetails.keys.first]['headers'];
    Map<String, String> header = {
      "clientId": scratchClientId, // "RMS1",
      "clientSecret": scratchClientSecret, // "13f1JiFyWSZ0XI/3Plxr3mv7gbNObpU1",
      "Content-Type": headerValues['Content-Type']
    };
    // Map<String, String> header = {
    //   "clientId": headerValues['clientId'],
    //   "clientSecret": headerValues['clientSecret'],
    //   "Content-Type": headerValues['Content-Type']
    // };
    dynamic jsonMap = await GameDetailsRepository.callGameDetails(context, param, header, scratchUrl/*scratchList.basePath*/, endUrl);

    try {
      var respObj = GameDetailsResponse.fromJson(jsonMap);
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

