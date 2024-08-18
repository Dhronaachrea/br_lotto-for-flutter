import 'package:br_lotto/l10n/l10n.dart';
import 'package:br_lotto/main.dart';
import 'package:br_lotto/scratch/saleTicket/model/response/sale_ticket_response.dart';
import 'package:br_lotto/utility/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:br_lotto/scratch/saleTicket/bloc/sale_ticket_event.dart';
import 'package:br_lotto/scratch/saleTicket/bloc/sale_ticket_state.dart';
import 'package:br_lotto/scratch/saleTicket/model/SaleTicketRequest.dart';
import 'package:br_lotto/scratch/saleTicket/sale_ticket_logic.dart';
import 'package:br_lotto/utility/user_info.dart';

class SaleTicketBloc extends Bloc<SaleTicketEvent, SaleTicketState> {
  SaleTicketBloc() : super(SaleTicketInitial()) {
    on<SaleTicketApi>(_onSaleTicketEvent);
  }
}

_onSaleTicketEvent(SaleTicketApi event, Emitter<SaleTicketState> emit) async {
  emit(SaleTicketLoading());

  BuildContext context  = event.context;
  var scratchList       = event.scratchList;

  /*{
    "barcodeNumber": "123456789000",
  "modelCode": "V2PRO",
  "terminalId": "NA",
  "userName": "demoret5",
  "userSessionId": "drxR2jMZvGO7MHKB-zZYCTJq529HVORqnh4qq6j0_x0"
  }*/

  var response = await SaleTicketLogic.callSaleTicketData(
      context,
      SaleTicketRequest(
        gameType: "Scratch", //required
        soldChannel: "WEB", //required "TERMINAL" - for pos
        bookNumberList: [
          event.barCodeText.toString(), //required
        ] ,
        userName: UserInfo.userName, //required
        //modelCode: androidInfo?.model ?? "TelpoM1","V2PRO", - required only for pos
        terminalId: "NA",
        userSessionId: UserInfo.userToken,
          //retailerOrgId : UserInfo.organisationID
      ).toJson(),
      scratchList);

  try {
    response.when(
        idle: () {},
        networkFault: (value) {
          emit(SaleTicketError(errorMessage: value["occurredErrorDescriptionMsg"]));
        },
        responseSuccess: (value) {
          SaleTicketResponse successResponse = value as SaleTicketResponse;

          emit(SaleTicketSuccess(response: successResponse));
        },
        responseFailure: (value) {
          print("bloc responseFailure:");
          SaleTicketResponse errorResponse = value as SaleTicketResponse;
          emit(SaleTicketError(errorMessage: loadLocalizedData("SCRATCH_${errorResponse.responseCode ?? ""}", BrLottoRetailApp.of(context).locale.languageCode) ?? errorResponse.responseMessage ?? ""));
        },
        failure: (value) {
          print("bloc failure: ${value["occurredErrorDescriptionMsg"]}");
          emit(SaleTicketError(errorMessage: value["occurredErrorDescriptionMsg"]));
        });
  } catch (e) {
    print("error=========> $e");
    emit(SaleTicketError(errorMessage: "Technical Issue !"));
  }
}
