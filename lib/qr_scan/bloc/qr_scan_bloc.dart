import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:br_lotto/qr_scan/bloc/models/request/qrScanRequest.dart';
import 'package:br_lotto/qr_scan/bloc/models/response/qrScanApiResponse.dart';
import 'package:br_lotto/qr_scan/bloc/qr_scan_event.dart';
import 'package:br_lotto/qr_scan/bloc/qr_scan_state.dart';
import 'package:br_lotto/qr_scan/qr_scan_logic.dart';

class QrScanBloc extends Bloc<QrScanEvent, QrScanState> {
  QrScanBloc() : super(QrScanInitial()) {
    on<GetWinClaimDataApi>(_onQrScanEvent);
  }
}

_onQrScanEvent(GetWinClaimDataApi event, Emitter<QrScanState> emit) async {
  emit(QrScanLoading());

  BuildContext context = event.context;
  String? barCodetext = event.barCodetext;

  var response = await QrScanLogic.callQrScanData(
      context,
      QrScanRequest(
              deviceId: "DESKTOP",
              // retailerId: UserInfo.userId,
              retailerId: "838",
              // retailerToken: UserInfo.userToken,
              retailerToken: "wnH3ThvpC2PzVQI1PddhVP4Z0Bn72qbvjwh2rMucfyU",
              // ticketNo: barCodetext,
              ticketNo: '16829349971520000838601',
              domainName: 'www.retail.co.in')
          .toJson());

  try {
    response.when(
        idle: () {},
        networkFault: (value) {
          emit(QrScanError(errorMessage: value["occurredErrorDescriptionMsg"]));
        },
        responseSuccess: (value) {
          QrScanApiResponse successResponse = value as QrScanApiResponse;

          emit(QrScanSuccess(response: successResponse));
        },
        responseFailure: (value) {
          print("bloc responseFailure:");
          emit(QrScanError(errorMessage: "responseFailure"));
        },
        failure: (value) {
          if(value.responseCode == 401 || value.responseCode == 100)
          {
            emit(QrScanError(errorMessage: value.responseMessage));
          }
          else
          {
            emit(QrScanError(errorMessage: value["occurredErrorDescriptionMsg"]));
          }
          print("bloc failure: ${value["occurredErrorDescriptionMsg"]}");
        });
  } catch (e) {
    print("error=========> $e");
  }
}
