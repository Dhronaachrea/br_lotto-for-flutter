import 'package:br_lotto/network/api_call.dart';
import 'package:br_lotto/network/network_utils.dart';
import 'package:flutter/material.dart';

class GameListRepository {
  static dynamic callGameList(
      BuildContext context,
      Map<String, dynamic> param,
      Map<String, String> header,
      String basePath,
      String relativeUrl
      ) async =>
      await CallApi.callApi(basePath, MethodType.get, relativeUrl, params: param, headers: header);
}
