import 'package:br_lotto/network/api_base_url.dart';
import 'package:br_lotto/network/api_call.dart';
import 'package:br_lotto/network/api_relative_urls.dart';
import 'package:br_lotto/network/network_utils.dart';
import 'package:flutter/cupertino.dart';

class SplashRepository {

  static dynamic callVersionControlApi(
      BuildContext context, Map<String, dynamic> request) async =>
      await CallApi.callApi(
        rmsBaseUrl,
        MethodType.get,
        versionControlUrl,
        requestBody: request,
        headers: {
          "Content-Type": "application/json",
        },
      );
}
