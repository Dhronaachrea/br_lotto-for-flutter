import 'package:flutter/material.dart';

abstract class QrScanEvent {}

class GetWinClaimDataApi extends QrScanEvent {
  BuildContext context;
  String? barCodetext;

  GetWinClaimDataApi({required this.context, required this.barCodetext});
}
