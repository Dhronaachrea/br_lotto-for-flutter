import 'package:flutter/cupertino.dart';

abstract class LoginEvent {}

class LoginTokenApi extends LoginEvent {
  BuildContext context;
  String userName;
  String password;

  LoginTokenApi({required this.context, required this.userName, required this.password});
}

class GetLoginDataApi extends LoginEvent {
  BuildContext context;

  GetLoginDataApi({required this.context});
}

class VerifyPosApi extends LoginEvent {
  BuildContext context;

  VerifyPosApi({required this.context});
}
