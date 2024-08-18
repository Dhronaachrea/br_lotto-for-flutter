import 'dart:convert';
import 'dart:developer';

import 'package:br_lotto/l10n/l10n.dart';
import 'package:br_lotto/main.dart';
import 'package:br_lotto/utility/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:br_lotto/home/home_logic.dart';
import 'package:br_lotto/home/models/request/UserMenuListRequest.dart';
import 'package:br_lotto/login/models/response/GetLoginDataResponse.dart';
import 'package:br_lotto/utility/app_constant.dart';
import 'package:br_lotto/utility/user_info.dart';

import '../models/response/UserMenuApiResponse.dart';
import '../models/response/get_config_response.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<GetUserMenuListApiData>(_onHomeEvent);
    on<GetConfigData>(_onConfigEvent);
    on<GetLoginDataApi>(_onGetLoginDataEvent);
  }
}

_onHomeEvent(GetUserMenuListApiData event, Emitter<HomeState> emit) async {
  emit(UserMenuListLoading());

  BuildContext context = event.context;

  var response = await HomeLogic.callUserMenuList(
      context,
      UserMenuListRequest(
        userId: UserInfo.userId,
        appType: appType,
        engineCode: clientId, // RMS
        languageCode: getLanguageWithContext(context),
      ).toJson());

  try {
    response.when(
        idle: () {},
        networkFault: (value) {
          emit(UserMenuListError(
              errorMessage: value["occurredErrorDescriptionMsg"]));
        },
        responseSuccess: (value) {
          UserMenuApiResponse successResponse = value as UserMenuApiResponse;

          List<ModuleBeanLst> fetchGameListModuleBean = successResponse.responseData?.moduleBeanLst?.where((element) => element.moduleCode == "DRAW_GAME").toList() ?? [];
          if (fetchGameListModuleBean.isNotEmpty == true) {
            var fetchGameListMenuBean = fetchGameListModuleBean[0].menuBeanList?.where((element) => element.menuCode == "DGE_GAME_LIST").toList();
            if (fetchGameListMenuBean?.isNotEmpty == true) {
              UserInfo.setLotteryMenuBeanList(jsonEncode(fetchGameListMenuBean?[0]));
            }
          }

          emit(UserMenuListSuccess(response: successResponse));
        },
        responseFailure: (value) {
          print("bloc responseFailure:");
          UserMenuApiResponse errorResponse = value as UserMenuApiResponse;
          emit(UserMenuListError(errorMessage: loadLocalizedData("RMS_${errorResponse.responseData?.statusCode ?? ""}", BrLottoRetailApp.of(context).locale.languageCode) ?? errorResponse.responseData?.message ?? ""));
        },
        failure: (value) {
          print("bloc failure: ${value["occurredErrorDescriptionMsg"]}");
          emit(UserMenuListError(
              errorMessage: value["occurredErrorDescriptionMsg"]));
        });
  } catch (e) {
    print("error=========> $e");
    emit(UserMenuListError(errorMessage: "Technical Issue !"));
  }
}

_onConfigEvent(GetConfigData event, Emitter<HomeState> emit) async {
  emit(UserMenuListLoading());

  BuildContext context = event.context;

  GetLoginDataResponse loginResponse        = GetLoginDataResponse.fromJson(jsonDecode(UserInfo.getUserInfo));

  log("savedLoginResponse: $loginResponse");
  Map<String, String> param = {
    'domainId': "${loginResponse.responseData?.data?.domainId}" ?? "1",
  };

  var response = await HomeLogic.callConfigData(context, param);

  try {
    response.when(
        idle: () {},
        networkFault: (value) {
          emit(UserConfigError(
              errorMessage: value["occurredErrorDescriptionMsg"]));
        },
        responseSuccess: (value) {
          GetConfigResponse successResponse = value as GetConfigResponse;
          emit(UserConfigSuccess(response: successResponse));
        },
        responseFailure: (value) {
          print("bloc responseFailure:");
          GetConfigResponse errorResponse = value as GetConfigResponse;
          emit(UserConfigError(errorMessage: loadLocalizedData("RMS_${errorResponse.responseData?.statusCode ?? ""}", BrLottoRetailApp.of(context).locale.languageCode) ?? errorResponse.responseData?.message ?? ""));
        },
        failure: (value) {
          print("bloc failure: ${value["occurredErrorDescriptionMsg"]}");
          emit(UserConfigError(
              errorMessage: value["occurredErrorDescriptionMsg"]));
        });
  } catch (e) {
    print("error=========> $e");
  }
}

_onGetLoginDataEvent(GetLoginDataApi event, Emitter<HomeState> emit) async {
  emit(GetLoginDataLoading());
  BuildContext context      = event.context;

  var response = await HomeLogic.callGetLoginDataApi(context);
  response.when(idle: () {

  },
      networkFault: (value) {
        emit(GetLoginDataError(errorMessage: value["occurredErrorDescriptionMsg"]));
      },
      responseSuccess: (value) {
        print("------------------------------------------- pull to reffresh ------------------------------------------------------------------------->");
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
