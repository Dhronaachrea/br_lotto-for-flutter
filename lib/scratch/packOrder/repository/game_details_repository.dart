import 'package:flutter/material.dart';
import 'package:br_lotto/network/api_call.dart';
import 'package:br_lotto/network/network_utils.dart';

class GameDetailsRepository {
  static dynamic callGameDetails(
      BuildContext context,
      Map<String, dynamic> param,
      Map<String, String> header,
      String basePath,
      String relativeUrl
      ) async =>
      await CallApi.callApi(basePath, MethodType.get, relativeUrl, params: param, headers: header);
}
