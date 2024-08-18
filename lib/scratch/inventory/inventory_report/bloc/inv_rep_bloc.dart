import 'dart:async';

import 'package:br_lotto/home/models/response/UserMenuApiResponse.dart';
import 'package:br_lotto/l10n/l10n.dart';
import 'package:br_lotto/main.dart';
import 'package:br_lotto/scratch/inventory/inventory_report/logic/inv_rep_logic.dart';
import 'package:br_lotto/scratch/inventory/inventory_report/model/response/inv_rep_response.dart';
import 'package:br_lotto/utility/user_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'inv_rep_event.dart';

part 'inv_rep_state.dart';

class InvRepBloc extends Bloc<InvRepEvent, InvRepState> {
  InvRepBloc() : super(InvRepInitial()) {
    on<InvRepForRetailer>(onInvRepForRetailer);
  }

  FutureOr<void> onInvRepForRetailer(
      InvRepForRetailer event, Emitter<InvRepState> emit) async {
    emit(GettingInvRepForRet());
    BuildContext context = event.context;
    MenuBeanList? menuBeanList = event.menuBeanList;
    var response = await InvRepLogic.callInvDetailsForRetailerAPI(
      context,
      menuBeanList,
      {"userName": UserInfo.userName, "userSessionId": UserInfo.userToken},
    );

    try {
      response.when(
          idle: () {},
          networkFault: (value) {
            emit(InvRepForRetError(
                errorMessage: value["occurredErrorDescriptionMsg"]));
          },
          responseSuccess: (value) {
            InvRepResponse successResponse = value as InvRepResponse;

            emit(GotInvRepForRet(response: successResponse));
          },
          responseFailure: (value) {
            print("bloc responseFailure:");
            InvRepResponse errorResponse = value as InvRepResponse;
            emit(InvRepForRetError(errorMessage: loadLocalizedData("SCRATCH_${errorResponse.responseCode ?? ""}", BrLottoRetailApp.of(context).locale.languageCode) ?? errorResponse.responseMessage ?? ""));
          },
          failure: (value) {
            print("bloc failure: ${value["occurredErrorDescriptionMsg"]}");
            emit(InvRepForRetError(
                errorMessage: value["occurredErrorDescriptionMsg"]));
          });
    } catch (e) {
      print("error=========> $e");
    }
  }
}
