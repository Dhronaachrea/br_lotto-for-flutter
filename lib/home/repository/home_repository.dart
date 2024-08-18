import 'package:flutter/material.dart';
import 'package:br_lotto/network/api_base_url.dart';
import 'package:br_lotto/network/api_call.dart';
import 'package:br_lotto/network/api_relative_urls.dart';
import 'package:br_lotto/network/network_utils.dart';

class HomeRepository {

  static dynamic callUserMenuList(BuildContext context, Map<String, String> param, Map<String, String> header) async =>
      await CallApi.callApi(rmsBaseUrl, MethodType.get, getUserMenuListApi, params: param, headers: header);

  static dynamic getConfigResponse(BuildContext context, Map<String, String> param, Map<String, String> header) async =>
      await CallApi.callApi(rmsBaseUrl, MethodType.get, configApi, params: param, headers: header);

  static dynamic callGetLoginDataApi(BuildContext context, Map<String, String> header) async =>
      await CallApi.callApi(rmsBaseUrl, MethodType.get, getLoginDataApi, headers: header);

}