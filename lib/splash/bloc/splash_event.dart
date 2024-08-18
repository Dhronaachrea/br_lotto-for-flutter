import 'package:flutter/material.dart';

abstract class SplashEvent {}

class VersionControlApi extends SplashEvent {
  final BuildContext context;

  VersionControlApi({required this.context});
}