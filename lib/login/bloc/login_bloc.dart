import 'dart:convert';

import 'package:br_lotto/l10n/l10n.dart';
import 'package:br_lotto/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utility/shared_pref.dart';
import '../../utility/user_info.dart';
import '../../utility/utils.dart';
import '../login_logic.dart';
import '../models/request/VerifyPosRequest.dart';
import '../models/response/GetLoginDataResponse.dart';
import '../models/response/LoginTokenResponse.dart';
import '../models/response/VerifyPosResponse.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginTokenApi>(_onLoginTokenApiEvent);
    on<GetLoginDataApi>(_onGetLoginDataEvent);
    on<VerifyPosApi>(_onVerifyPosEvent);
  }


  _onLoginTokenApiEvent(LoginTokenApi event, Emitter<LoginState> emit) async {
    emit(LoginTokenLoading());
    BuildContext context      = event.context;
    String userName           = event.userName;
    String encryptedPassword  = encryptMd5(event.password);
    String password = event.password;

    Map<String, String> loginInfo = {
        "userName"    : userName,
        "password"    : encryptedPassword // encryptedPassword
    };

    var response = await LoginLogic.callLoginTokenApi(context, loginInfo);

    try {
      response.when(idle: () {

      },
          networkFault: (value) {
            emit(LoginTokenError(
                errorMessage: value["occurredErrorDescriptionMsg"]));
          },
          responseSuccess: (value) {
            LoginTokenResponse successResponse = value as LoginTokenResponse;
            String playerId = (successResponse.responseData?.userId != null) ? successResponse.responseData!.userId.toString() : "";
            UserInfo.setPlayerToken( successResponse.responseData?.authToken ?? "");
            UserInfo.setPlayerId(playerId);
            emit(LoginTokenSuccess(response: successResponse));
          },
          responseFailure: (value) {
            LoginTokenResponse errorResponse = value as LoginTokenResponse;
            print("bloc responseFailure: ${errorResponse.responseData?.message} =======> ");
            emit(LoginTokenError(errorMessage: loadLocalizedData("RMS_${errorResponse.responseData?.statusCode ?? ""}", BrLottoRetailApp.of(context).locale.languageCode) ?? errorResponse.responseData?.message ?? ""));
          },
          failure: (value) {
            print("bloc failure: ${value["occurredErrorDescriptionMsg"]}");
            emit(LoginTokenError(errorMessage: value["occurredErrorDescriptionMsg"]));
          });
    } catch (e) {
      print("error=========> $e");
    }
  }

  _onGetLoginDataEvent(GetLoginDataApi event, Emitter<LoginState> emit) async {
    emit(GetLoginDataLoading());
    BuildContext context      = event.context;

    var response = await LoginLogic.callGetLoginDataApi(context);
    response.when(idle: () {

    },
        networkFault: (value) {
          emit(GetLoginDataError(errorMessage: value["occurredErrorDescriptionMsg"]));
        },
        responseSuccess: (value) {
          print("-------------------------------------------------------------------------------------------------------------------->");
          GetLoginDataResponse successResponse = value as GetLoginDataResponse;
          String orgId = successResponse.responseData?.data?.orgId?.toString() ?? "";
          print("orgId: $orgId");
          print("UserInfo.organisationID: ${UserInfo.organisationID}");
          if(UserInfo.organisationID != orgId) {
            UserInfo.setLastSaleTicketNo("");

          }

          UserInfo.setTotalBalance(successResponse.responseData?.data?.balance?.toString() ?? "");
          UserInfo.setOrganisation(successResponse.responseData?.data?.orgCode?.toString() ?? "");
          UserInfo.setDisplayCommission(successResponse.responseData?.data?.displayCommision ?? "");
          UserInfo.setOrganisationId(successResponse.responseData?.data?.orgId?.toString() ?? "");
          UserInfo.setUserName(successResponse.responseData?.data?.username?.toString() ?? "");
          UserInfo.setUserInfoData(jsonEncode(successResponse));
          UserInfo.setSaleBlockDate(successResponse.responseData?.data?.saleBlockDate ?? "");
          GetLoginDataResponse loginResponse        = GetLoginDataResponse.fromJson(jsonDecode(UserInfo.getUserInfo));
          print("loginResponse.responseData?.data?.orgName: ${loginResponse.responseData?.data?.orgName}");
          emit(GetLoginDataSuccess(response: successResponse));
        },
        responseFailure: (value) {
          print("bloc responseFailure:");
          GetLoginDataResponse errorResponse = value as GetLoginDataResponse;
          emit(GetLoginDataError(errorMessage: loadLocalizedData("RMS_${errorResponse.responseData?.statusCode ?? ""}", BrLottoRetailApp.of(context).locale.languageCode) ?? errorResponse.responseData?.message ?? ""));
        },
        failure: (value) {

          print("bloc failure: ${value}");
          print("bloc failure: ${value["OS Error:"]}");
          emit(GetLoginDataError(errorMessage: "Something Went Wrong!"));
        });
    try {

    } catch (e) {
      print("error=========> $e");
    }
  }

  _onVerifyPosEvent(VerifyPosApi event, Emitter<LoginState> emit) async {
    emit(VerifyPosLoading());
    BuildContext context      = event.context;

    var response = await LoginLogic.callVerifyPosApi(context, VerifyPosRequest(
      latitudes: "0",
      longitudes: "0",
      modelCode: "NA",
      simType: "MTN",
      terminalId: "NA",
      version: "1.0.0"
    ).toJson());
    response.when(idle: () {

    },
    networkFault: (value) {
      emit(VerifyPosError(errorMessage: value["occurredErrorDescriptionMsg"]));
    },
    responseSuccess: (value) {
      VerifyPosResponse successResponse = value as VerifyPosResponse;
      emit(VerifyPosSuccess(response: successResponse));
    },
    responseFailure: (value) {
      VerifyPosResponse errorResponse = value as VerifyPosResponse;
      print("bloc responseFailure:");
      emit(VerifyPosError(errorMessage: loadLocalizedData("RMS_${errorResponse.responseData?.statusCode ?? ""}", BrLottoRetailApp.of(context).locale.languageCode) ?? errorResponse.responseData?.message ?? ""));
    },
    failure: (value) {
      print("bloc failure: ${value}");
      emit(VerifyPosError(errorMessage: "Something Went Wrong!"));
    });
    try {

    } catch (e) {
      print("error=========> $e");
    }
  }

}
