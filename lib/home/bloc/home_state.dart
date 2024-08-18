import 'package:br_lotto/home/models/response/get_config_response.dart';
import 'package:br_lotto/login/models/response/GetLoginDataResponse.dart';

import '../models/response/UserMenuApiResponse.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class UserMenuListLoading extends HomeState{}

class UserMenuListSuccess extends HomeState{
  UserMenuApiResponse response;

  UserMenuListSuccess({required this.response});

}
class UserMenuListError extends HomeState{
  String errorMessage;

  UserMenuListError({required this.errorMessage});
}

class  UserConfigSuccess extends HomeState{
  GetConfigResponse response;

  UserConfigSuccess({required this.response});

}
class UserConfigError extends HomeState{
  String errorMessage;

  UserConfigError({required this.errorMessage});
}

class GetLoginDataLoading extends HomeState{}

class GetLoginDataSuccess extends HomeState{
  GetLoginDataResponse? response;

  GetLoginDataSuccess({required this.response});

}
class GetLoginDataError extends HomeState{
  String errorMessage;

  GetLoginDataError({required this.errorMessage});
}