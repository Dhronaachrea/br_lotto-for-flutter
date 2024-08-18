import 'package:flutter/material.dart';
import 'package:br_lotto/network/api_base_url.dart';
import 'package:br_lotto/network/api_call.dart';
import 'package:br_lotto/network/api_relative_urls.dart';
import 'package:br_lotto/network/network_utils.dart';

class QrScanRepository {
  static dynamic callQrScan(BuildContext context, Map<String, String> param) async =>
      await CallApi.callApi(sportsBaseUrl,
          MethodType.get, claimWinningApi,
          requestBody: param);
//  my code bellow

/*static dynamic callQrScan(BuildContext context, Map<String, String> param,
      Map<String, String> header, String basePath, String endUrl) async =>
      await CallApi.callApi(basePath,
          MethodType.post, endUrl,
          requestBody: param, headers: header);*/
}