import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:br_lotto/l10n/l10n.dart';
import 'package:br_lotto/main.dart';
import 'package:br_lotto/splash/bloc/splash_event.dart';
import 'package:br_lotto/splash/bloc/splash_state.dart';
import 'package:br_lotto/splash/logic/splash_logic.dart';
import 'package:br_lotto/splash/model/version_control_request.dart';
import 'package:br_lotto/splash/model/version_control_response.dart';
import 'package:br_lotto/utility/app_constant.dart';
import 'package:br_lotto/utility/user_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:package_info_plus/package_info_plus.dart';


class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(SplashInitial()) {
    on<VersionControlApi>(_onVersionControlApi);
  }

  FutureOr<void> _onVersionControlApi(VersionControlApi event, Emitter<SplashState> emit) async {
    emit(VersionControlLoading());
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    BuildContext context = event.context;

    var request = VersionControlRequest(
        appType: "Cash",
        currAppVer: packageInfo.version,
        domainName: aliasName,
        os: "ANDROID",
        playerToken: UserInfo.userToken,
        playerId: (UserInfo.userId.toString())
    ).toJson();

    var response = await SplashLogic.callVersionControlApi(event.context, request);

    response.when(
        responseSuccess: (value) {
          print("bloc success");
          VersionControlResponse statusResponseModel = value as VersionControlResponse;
          emit(VersionControlSuccess(response: statusResponseModel));
        },
        idle: () {},
        networkFault: (value) {
          emit(VersionControlError(errorMsg: context.l10n.no_internet_connection));
        },
        responseFailure: (value) {
          print("======================>$value");
          print("splash bloc responseFailure: ${value?.errorCode}, ${value?.respMsg}");
          var errorResponse = value;
          emit(VersionControlError(errorMsg: loadLocalizedData("RMS_${errorResponse.responseData?.statusCode ?? ""}", BrLottoRetailApp.of(context).locale.languageCode) ?? errorResponse.responseData?.message ?? ""));
        },
        failure: (value) {
          print("splash bloc failure: ${value["occurredErrorDescriptionMsg"]}");
          if (value["occurredErrorDescriptionMsg"].toString().contains("connection abort")) {
            emit(VersionControlError(errorMsg: context.l10n.no_internet_connection,));
          } else {
            emit(VersionControlError(errorMsg: value["occurredErrorDescriptionMsg"] ?? "Something went wrong "));
          }

        });

    try {

    } catch (e) {
      emit(VersionControlError(errorMsg: "Technical issue, Please try again. $e"));
    }
  }

}
