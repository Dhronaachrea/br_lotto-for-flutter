import 'package:br_lotto/splash/model/version_control_response.dart';
import 'package:br_lotto/splash/repository/splash_repository.dart';
import 'package:flutter/material.dart';

import '../../utility/result.dart';

class SplashLogic {
  static Future<Result<dynamic>> callVersionControlApi(
      BuildContext context, Map<String, dynamic> request) async {

    dynamic jsonMap = await SplashRepository.callVersionControlApi(context, request);
    //dynamic jsonMapDummy = '{"responseCode":0,"responseMessage":"Success","responseData":{"message":"Success","statusCode":0,"data":{"id":16,"appTypeId":4,"appId":1,"version":"1.0.1","isMandatory":"YES","fileSize":"34 MB","downloadStatus":"ACTIVE","versionStatus":"ACTIVE","downloadUrl":"https://smartelist4u.pythonanywhere.com/media/Longalottoretail_v100.apk","createdBy":1,"appRemark":"This is a new version 1.1.4","createdAt":1683752400000,"isLatest":"YES","updatedAt":1683752400000}}}';
    try {
      VersionControlResponse respObj = VersionControlResponse.fromJson(jsonMap);
      if (respObj.responseCode == 0) {
        return Result.responseSuccess(data: respObj);
      } else {
        return Result.responseFailure(data: respObj);
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