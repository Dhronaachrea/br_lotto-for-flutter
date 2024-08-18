
import '../models/response/GetLoginDataResponse.dart';
import '../models/response/LoginTokenResponse.dart';
import '../models/response/VerifyPosResponse.dart';

abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginTokenLoading extends LoginState{}

class LoginTokenSuccess extends LoginState{
  LoginTokenResponse? response;

  LoginTokenSuccess({required this.response});

}
class LoginTokenError extends LoginState{
  String errorMessage;

  LoginTokenError({required this.errorMessage});
}

/////////////////////////////////////////////////////////////////////

class GetLoginDataLoading extends LoginState{}

class GetLoginDataSuccess extends LoginState{
  GetLoginDataResponse? response;

  GetLoginDataSuccess({required this.response});

}
class GetLoginDataError extends LoginState{
  String errorMessage;

  GetLoginDataError({required this.errorMessage});
}

class VerifyPosLoading extends LoginState{}

class VerifyPosSuccess extends LoginState{
  VerifyPosResponse? response;

  VerifyPosSuccess({required this.response});

}
class VerifyPosError extends LoginState{
  String errorMessage;

  VerifyPosError({required this.errorMessage});
}