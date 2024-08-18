import 'package:flutter/material.dart';

import '../../network/api_base_url.dart';
import '../../network/api_call.dart';
import '../../network/api_relative_urls.dart';
import '../../network/network_utils.dart';

class PaymentReportRepository {
  static dynamic callPaymentReportList(BuildContext context, Map<String, dynamic>? requestBody, Map<String, String> header) async =>
      await CallApi.callApi(rmsBaseUrl, MethodType.post, getpaymentReportDataApi, requestBody: requestBody, headers: header);
}