import 'package:br_lotto/home/bloc/home_bloc.dart';
import 'package:br_lotto/home/home_screen.dart';
import 'package:br_lotto/home/models/response/UserMenuApiResponse.dart';
import 'package:br_lotto/scratch/inventory/inventory_flow/bloc/inv_flow_bloc.dart';
import 'package:br_lotto/scratch/inventory/inventory_flow/inventory_flow_screen.dart';
import 'package:br_lotto/scratch/inventory/inventory_report/bloc/inv_rep_bloc.dart';
import 'package:br_lotto/scratch/inventory/inventory_report/inventory_report_screen.dart';
import 'package:br_lotto/scratch/packOrder/bloc/pack_bloc.dart';
import 'package:br_lotto/scratch/packOrder/pack_order_screen.dart';
import 'package:br_lotto/scratch/packReceive/pack_reveice_screen.dart';
import 'package:br_lotto/scratch/pack_activation/pack_activation_screen.dart';
import 'package:br_lotto/scratch/pack_return/pack_return_screen.dart';
import 'package:br_lotto/scratch/saleTicket/bloc/sale_ticket_bloc.dart';
import 'package:br_lotto/scratch/saleTicket/sale_ticket_screen.dart';
import 'package:br_lotto/scratch/ticketValidationAndClaim/bloc/ticket_validation_and_claim_bloc.dart';
import 'package:br_lotto/scratch/ticketValidationAndClaim/ticket_validation_and_claim_screen.dart';
import 'package:br_lotto/splash/bloc/splash_bloc.dart';
import 'package:br_lotto/utility/widgets/selectdate/bloc/select_date_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../change_pin/bloc/change_pin_bloc.dart';
import '../change_pin/change_pin.dart';
import '../ledger_report/bloc/ledger_report_bloc.dart';
import '../ledger_report/ledger_report_screen.dart';
import '../login/bloc/login_bloc.dart';
import '../login/login_screen.dart';
import '../saleWinTxnReport/bloc/sale_win_bloc.dart';
import '../saleWinTxnReport/sale_win_transaction_report.dart';
import '../payment_report/bloc/payment_report_bloc.dart';
import '../payment_report/payment_report_screen.dart';
import '../splash/splash_screen.dart';
import '../summarize_ledger_report/bloc/summarize_ledger_bloc.dart';
import '../summarize_ledger_report/summarize_ledger_report_screen.dart';
import '../utility/br_lotto_pos_screens.dart';

class AppRoute {
  router(RouteSettings setting) {
    switch (setting.name) {
      case BrLottoPosScreen.splashScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider<SplashBloc>(
            create: (BuildContext context) => SplashBloc(),
            child: const SplashScreen(),
          ),
        );

      case BrLottoPosScreen.loginScreen:
        return MaterialPageRoute(
            builder: (_) => MultiBlocProvider(
                  providers: [
                    BlocProvider<LoginBloc>(
                      create: (BuildContext context) => LoginBloc(),
                    )
                  ],
                  child: const LoginScreen(),
                ));

      case BrLottoPosScreen.homeScreen:
        return MaterialPageRoute(
            builder: (_) => MultiBlocProvider(
                  providers: [
                    BlocProvider<HomeBloc>(
                      create: (BuildContext context) => HomeBloc(),
                    ),
                    BlocProvider<LoginBloc>(
                      create: (BuildContext context) => LoginBloc(),
                    )
                  ],
                  child: const HomeScreen(),
                ));

      case BrLottoPosScreen.saleWinTxn:
        String? title = setting.arguments as String?;
        return MaterialPageRoute(
            builder: (_) => MultiBlocProvider(
                  providers: [
                    BlocProvider<SaleWinBloc>(
                      create: (BuildContext context) => SaleWinBloc(),
                    ),
                    BlocProvider<SelectDateBloc>(
                      create: (BuildContext context) => SelectDateBloc(),
                    ),
                  ],
                  child: SaleWinTransactionReport(title: title),
                ));

      case BrLottoPosScreen.ledgerReportScreen:
        String? title = setting.arguments as String?;
        return MaterialPageRoute(
            builder: (_) => MultiBlocProvider(
                  providers: [
                    BlocProvider<LedgerReportBloc>(
                      create: (BuildContext context) => LedgerReportBloc(),
                    ),
                    BlocProvider<SelectDateBloc>(
                      create: (BuildContext context) => SelectDateBloc(),
                    ),
                  ],
                  child: LedgerReportScreen(title: title),
                ));

      case BrLottoPosScreen.summarizeLedgerReport:
        String? title = setting.arguments as String?;
        return MaterialPageRoute(
            builder: (_) => MultiBlocProvider(
                  providers: [
                    BlocProvider<SelectDateBloc>(
                      create: (BuildContext context) => SelectDateBloc(),
                    ),
                    BlocProvider<SummarizeLedgerBloc>(
                      create: (BuildContext context) => SummarizeLedgerBloc(),
                    )
                  ],
                  child: SummarizeLedgerReportScreen(title: title),
                ));

      case BrLottoPosScreen.changePin:
        String? title = setting.arguments as String?;
        return MaterialPageRoute(
            builder: (_) => MultiBlocProvider(
                  providers: [
                    BlocProvider<ChangePinBloc>(
                      create: (BuildContext context) => ChangePinBloc(),
                    )
                  ],
                  child: ChangePin(
                    title: title,
                  ),
                ));

      case BrLottoPosScreen.paymentReportScreen:
        String? title = setting.arguments as String?;
        return MaterialPageRoute(
            builder: (_) => MultiBlocProvider(
                  providers: [
                    BlocProvider<PaymentReportBloc>(
                      create: (BuildContext context) => PaymentReportBloc(),
                    ),
                    BlocProvider<SelectDateBloc>(
                      create: (BuildContext context) => SelectDateBloc(),
                    ),
                  ],
                  child: PaymentReportScreen(title: title),
                ));

      case BrLottoPosScreen.inventoryFlowReportScreen:
        MenuBeanList? menuBeanList = setting.arguments as MenuBeanList?;
        return MaterialPageRoute(
            builder: (_) => MultiBlocProvider(
                  providers: [
                    BlocProvider<InvFlowBloc>(
                      create: (BuildContext context) => InvFlowBloc(),
                    ),
                    BlocProvider<SelectDateBloc>(
                      create: (BuildContext context) => SelectDateBloc(),
                    )
                  ],
                  child: InventoryFlowScreen(menuBeanList: menuBeanList),
                ));

      case BrLottoPosScreen.inventoryReportScreen:
        MenuBeanList? menuBeanList = setting.arguments as MenuBeanList?;
        return MaterialPageRoute(
            builder: (_) => MultiBlocProvider(
                  providers: [
                    BlocProvider<InvRepBloc>(
                      create: (BuildContext context) => InvRepBloc(),
                    )
                  ],
                  child: InventoryReportScreen(menuBeanList: menuBeanList),
                ));

      case BrLottoPosScreen.packOrderScreen:
        MenuBeanList? scratchList = setting.arguments as MenuBeanList?;
        return MaterialPageRoute(
            builder: (_) => MultiBlocProvider(
                  providers: [
                    BlocProvider<PackBloc>(
                      create: (BuildContext context) => PackBloc(),
                    )
                  ],
                  child: PackOrderScreen(
                    scratchList: scratchList,
                  ),
                ));

      case BrLottoPosScreen.packReceiveScreen:
        MenuBeanList? scratchList = setting.arguments as MenuBeanList?;
        return MaterialPageRoute(
            builder: (_) => MultiBlocProvider(
                  providers: [
                    BlocProvider<PackBloc>(
                      create: (BuildContext context) => PackBloc(),
                    )
                  ],
                  child: PackReceiveScreen(
                    scratchList: scratchList,
                  ),
                ));

      case BrLottoPosScreen.packActivationScreen:
        MenuBeanList? scratchList = setting.arguments as MenuBeanList?;
        return MaterialPageRoute(
            builder: (_) => MultiBlocProvider(
                  providers: [
                    BlocProvider<PackBloc>(
                      create: (BuildContext context) => PackBloc(),
                    )
                  ],
                  child: PackActivationScreen(
                    scratchList: scratchList,
                  ),
                ));

      case BrLottoPosScreen.packReturnScreen:
        MenuBeanList? scratchList = setting.arguments as MenuBeanList?;
        return MaterialPageRoute(
            builder: (_) => MultiBlocProvider(
                  providers: [
                    BlocProvider<PackBloc>(
                      create: (BuildContext context) => PackBloc(),
                    )
                  ],
                  child: PackReturnScreen(
                    scratchList: scratchList,
                  ),
                ));

      case BrLottoPosScreen.saleTicketScreen:
        MenuBeanList? scratchList = setting.arguments as MenuBeanList?;
        return MaterialPageRoute(
            builder: (_) => MultiBlocProvider(
                  providers: [
                    BlocProvider<SaleTicketBloc>(
                      create: (BuildContext context) => SaleTicketBloc(),
                    ),
                    BlocProvider<PackBloc>(
                      create: (BuildContext context) => PackBloc(),
                    )
                  ],
                  child: SaleTicketScreen(
                    scratchList: scratchList,
                  ),
                ));

      case BrLottoPosScreen.ticketValidationAndClaimScreen:
        MenuBeanList? scratchList = setting.arguments as MenuBeanList?;
        return MaterialPageRoute(
            builder: (_) => MultiBlocProvider(
                  providers: [
                    BlocProvider<TicketValidationAndClaimBloc>(
                      create: (BuildContext context) =>
                          TicketValidationAndClaimBloc(),
                    )
                  ],
                  child: TicketValidationAndClaimScreen(
                    scratchList: scratchList,
                  ),
                ));
    }
  }
}
