import 'dart:convert';

import 'package:br_lotto/network/api_base_url.dart';
import 'package:br_lotto/network/api_relative_urls.dart';
import 'package:br_lotto/utility/app_constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:br_lotto/qr_scan/bloc/models/response/qrScanApiResponse.dart';
import 'package:br_lotto/scratch/saleTicket/repository/sale_ticket_repository.dart';
import 'package:br_lotto/utility/result.dart';

import 'model/response/sale_ticket_response.dart';

class SaleTicketLogic {
  static Future<Result<dynamic>> callSaleTicketData(BuildContext context, Map<String, dynamic> param, var scratchList) async {
    // Map<dynamic, dynamic> apiDetails = json.decode(scratchList.apiDetails);
    Map apiDetails = json.decode(scratchList.apiDetails);
    String endUrl = soldTicketUrl ; //apiDetails[apiDetails.keys.first]['url'];
    Map headerValues = apiDetails[apiDetails.keys.first]['headers'];
    Map<String, String> header = {
      "clientId": scratchClientId,//"RMS1",
      "clientSecret": scratchClientSecret, // scratchClientSecret, ph2Nj5knd4IjWBVLc4mhmYHo1hQDEdS3FlIC2KskHpeHFhsqxD
      "Content-Type": headerValues['Content-Type']
    };

    dynamic jsonMap = await SaleTicketRepository.callSaleTicket(context, param, header,scratchUrl/*scratchList.basePath*/, endUrl);

    try {
      var respObj = SaleTicketResponse.fromJson(jsonMap);
      if (respObj.responseCode == scratchResponseCode) {
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

