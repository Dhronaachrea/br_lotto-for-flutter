import '../model/version_control_response.dart';

abstract class SplashState {}

class SplashInitial extends SplashState {}

class VersionControlLoading extends SplashState {}

class VersionControlSuccess extends SplashState {
  VersionControlResponse? response;

  VersionControlSuccess({required this.response});
}

class VersionControlError extends SplashState {
  final String errorMsg;

  VersionControlError({required this.errorMsg});
}

