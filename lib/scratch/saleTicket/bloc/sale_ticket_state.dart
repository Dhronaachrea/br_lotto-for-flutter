
import 'package:br_lotto/scratch/saleTicket/model/response/sale_ticket_response.dart';

abstract class SaleTicketState {}

class SaleTicketInitial extends SaleTicketState {}

class SaleTicketLoading extends SaleTicketState {}

class SaleTicketSuccess extends SaleTicketState {
  SaleTicketResponse response;

  SaleTicketSuccess({required this.response});
}

class SaleTicketError extends SaleTicketState {
  String errorMessage;

  SaleTicketError({required this.errorMessage});
}
