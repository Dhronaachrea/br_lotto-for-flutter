import 'package:flutter/cupertino.dart';
import 'package:br_lotto/home/models/response/UserMenuApiResponse.dart';

abstract class SaleTicketEvent {}

class SaleTicketApi extends SaleTicketEvent {
  BuildContext context;
  MenuBeanList? scratchList;
  String? barCodeText;

  SaleTicketApi({required this.context, required this.scratchList, required this.barCodeText});
}
