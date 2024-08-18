import 'package:br_lotto/qr_scan/bloc/models/response/qrScanApiResponse.dart';

abstract class QrScanState {}

class QrScanInitial extends QrScanState {}

class QrScanLoading extends QrScanState {}

class QrScanSuccess extends QrScanState {
  QrScanApiResponse response;

  QrScanSuccess({required this.response});
}

class QrScanError extends QrScanState {
  String errorMessage;

  QrScanError({required this.errorMessage});
}
