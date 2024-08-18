import 'package:br_lotto/home/widget/br_lotto_scaffold.dart';
import 'package:br_lotto/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:velocity_x/velocity_x.dart';

import '../utility/app_constant.dart';
import '../utility/br_lotto_pos_color.dart';
import '../utility/date_format.dart';
import '../utility/utils.dart';
import '../utility/widgets/selectdate/bloc/select_date_bloc.dart';
import '../utility/widgets/selectdate/forward.dart';
import '../utility/widgets/selectdate/select_date.dart';
import '../utility/widgets/selectdate/select_week_month.dart';
import '../utility/widgets/show_snackbar.dart';
import 'bloc/payment_report_bloc.dart';
import 'bloc/payment_report_event.dart';
import 'bloc/payment_report_state.dart';
import 'models/response/payment_report_reponse.dart';

class PaymentReportScreen extends StatefulWidget {
  final String? title;
  const PaymentReportScreen({Key? key, required this.title}) : super(key: key);

  @override
  _PaymentReportState createState() => _PaymentReportState();
}

class _PaymentReportState extends State<PaymentReportScreen> {
  BuildContext conx = navigatorKey.currentContext!;
  var selectedData = "";

  @override
  void initState() {
    // BlocProvider.of<PaymentReportBloc>(context).add(GetPaymentReportApiData(
    //   context: context,
    //   fromDate: formatDate(
    //     date: context.read<SelectDateBloc>().fromDate,
    //     inputFormat: Format.dateFormat9,
    //     outputFormat: Format.apiDateFormat3,
    //   ),
    //   toDate: formatDate(
    //     date: context.read<SelectDateBloc>().toDate,
    //     inputFormat: Format.dateFormat9,
    //     outputFormat: Format.apiDateFormat3,
    //   ),
    // ));

    initData(formatDate(
            date: findFirstDateOfTheWeek(DateTime.now()).toString(),
            inputFormat: Format.apiDateFormat2,
            outputFormat: Format.apiDateFormat3),
        formatDate(
            date: findLastDateOfTheWeek(DateTime.now()).toString(),
            inputFormat: Format.apiDateFormat2,
            outputFormat: Format.apiDateFormat3));
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    var filterList = [
      context.l10n.this_week,
      context.l10n.last_week,
      context.l10n.last_month
    ];

    if (selectedData == "") {
      selectedData = context.l10n.this_week;
    }

    var body = Column(
      children: [
        Container(
          color: BrLottoPosColor.white,
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  setState(() {
                    selectedData = filterList[index];
                  });

                  if (selectedData == context.l10n.this_week) {
                    initData(
                       formatDate(
                            date: findFirstDateOfTheWeek(DateTime.now())
                                .toString(),
                            inputFormat: Format.apiDateFormat2,
                            outputFormat: Format.apiDateFormat3),
                        formatDate(
                            date: findLastDateOfTheWeek(DateTime.now())
                                .toString(),
                            inputFormat: Format.apiDateFormat2,
                            outputFormat: Format.apiDateFormat3));
                  } else if (selectedData == context.l10n.last_week) {
                    initData(
                        formatDate(
                            date: findFirstDateOfPreviousWeek(DateTime.now())
                                .toString(),
                            inputFormat: Format.apiDateFormat2,
                            outputFormat: Format.apiDateFormat3),
                     formatDate(
                            date: findLastDateOfPreviousWeek(DateTime.now())
                                .toString(),
                            inputFormat: Format.apiDateFormat2,
                            outputFormat: Format.apiDateFormat3));
                  } else if (selectedData == context.l10n.last_month) {
                    initData(
                        formatDate(
                            date: getLastMonthStartDate(DateTime.now())
                                .toString(),
                            inputFormat: Format.apiDateFormat2,
                            outputFormat: Format.apiDateFormat3),
                         formatDate(
                            date: getLastMonthEndDate(DateTime.now())
                                .toString(),
                            inputFormat: Format.apiDateFormat2,
                            outputFormat: Format.apiDateFormat3));
                  }
                },
                child: SelectWeekMonth(
                    title: filterList[index], selectedData: selectedData),
              );
            },
            itemCount: filterList.length,
          ).pSymmetric(v: 8, h: 10),
        ),
        Container(
          color: BrLottoPosColor.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SelectDate(
                title: context.l10n.from,
                date: context.watch<SelectDateBloc>().fromDate,
                onTap: () {
                  context.read<SelectDateBloc>().add(
                    PickFromDate(context: context),
                  );
                },
              ),
              SelectDate(
                title: context.l10n.to,
                date: context.watch<SelectDateBloc>().toDate,
                onTap: () {
                  context.read<SelectDateBloc>().add(
                    PickToDate(context: context),
                  );
                },
              ),
              Forward(
                onTap: () {
                  setState(() {
                    selectedData = "custom";
                  });

                  initData(
                      formatDate(
                        date: context.read<SelectDateBloc>().fromDate,
                        inputFormat: Format.dateFormat9,
                        outputFormat: Format.apiDateFormat3,
                      ),
                      formatDate(
                        date: context.read<SelectDateBloc>().toDate,
                        inputFormat: Format.dateFormat9,
                        outputFormat: Format.apiDateFormat3,
                      ));
                },
              ),
            ],
          ).pSymmetric(v: 8, h: 10),
        ),
        BlocConsumer<PaymentReportBloc, PaymentReportState>(
            listener: (context, state) {
              if (state is PaymentReportError) {
                ShowToast.showToast(context, state.errorMessage,
                    type: ToastType.ERROR);
              }
            }, builder: (context, state) {
          if (state is PaymentReportLoading) {
            return Container(
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            ).p(10);
          } else if (state is PaymentReportSuccess) {
            PaymentReportResponse ledgerReportApiResponse =
                state.ledgerReportApiResponse;
            List<Transaction>? transList =
                ledgerReportApiResponse.responseData!.data?[0].transaction;

            return Expanded(
                child: Column(
                  children: [
                    transList != null && transList!.isNotEmpty
                        ? Expanded(
                        child: ListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            itemCount: transList.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        height: 70,
                                        width:
                                        MediaQuery.of(context).size.width *
                                            0.25,
                                        alignment: Alignment.center,
                                        color: const Color(0xff7492c2),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                                getDate(
                                                    transList[0].createdAt),
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    fontFamily: noirFont,
                                                    fontWeight:
                                                    FontWeight.w500,
                                                    color: BrLottoPosColor
                                                        .white))
                                                .pOnly(bottom: 2),
                                            Text(
                                              getTime(
                                                  transList[index].createdAt),
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: noirFont,
                                                  fontWeight: FontWeight.w500,
                                                  color: BrLottoPosColor.white),
                                            ),
                                          ],
                                        ).pOnly(left: 15, right: 15),
                                      ),
                                      SizedBox(
                                        width:
                                        MediaQuery.of(context).size.width *
                                            0.45,
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              transList[index].txnType ?? "",
                                              maxLines: 2,
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: noirFont,
                                                  fontStyle: FontStyle.normal,
                                                  color: BrLottoPosColor
                                                      .brownish_grey),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                                "#${transList[index].txnId}" ??
                                                    "",
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    fontFamily: noirFont,
                                                    fontWeight:
                                                    FontWeight.w500,
                                                    color: BrLottoPosColor
                                                        .black))
                                                .pOnly(top: 10)
                                          ],
                                        ),
                                      ).pOnly(left: 5, right: 5),
                                      Container(
                                        width:
                                        MediaQuery.of(context).size.width *
                                            0.25,
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              "${getDefaultCurrency(getLanguage())} ${transList[index].balancePostTxn ?? ""}",
                                                style: const TextStyle(
                                                    color: BrLottoPosColor
                                                        .light_navy,
                                                    fontFamily: noirFont,
                                                    fontSize: 12,
                                                    fontWeight:
                                                    FontWeight.w500))
                                                .pOnly(bottom: 5),
                                            FittedBox(
                                              child: Text(
                                                  "${getDefaultCurrency(getLanguage())}  ${transList[index].txnValue ?? ""}",
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: BrLottoPosColor
                                                          .black_four
                                                          .withOpacity(0.6),
                                                      fontFamily: noirFont,
                                                      fontWeight:
                                                      FontWeight.w500)),
                                            ),
                                          ],
                                        ).pOnly(right: 15),
                                      )
                                    ],
                                  ),
                                  Container(
                                      child: const Divider(
                                        height: 1,
                                        color: BrLottoPosColor.gray,
                                      ))
                                ],
                              );
                            }))
                        : Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            context.l10n.no_data_available,
                            style: TextStyle(
                                color:
                                BrLottoPosColor.black_four.withOpacity(0.5)),
                          ).p(10),
                        )),
                  ],
                ));
          } else if (state is PaymentReportError) {
            return Container();
          }
          return Container();
        })
      ],
    );
    return BrLottoScaffold(
      showAppBar: true,
      appBarTitle: widget.title ?? context.l10n.payment_report,
      body: body,
    );
  }

  String getDate(String? createdAt) {
    String fromDate = formatDate(
      date: createdAt.toString(),
      inputFormat: Format.apiDateFormat,
      outputFormat: Format.dateFormat,
    );
    List<String> splitag = fromDate.split(",");
    String? splitag1 = splitag[0];
    return splitag1;
  }

  String getTime(String? createdAt) {
    String fromDate = formatDate(
      date: createdAt.toString(),
      inputFormat: Format.apiDateFormat,
      outputFormat: Format.dateFormat,
    );
    List<String> splitag = fromDate.split(",");
    String? splitag2 = splitag[1];
    return splitag2;
  }

  initData(String fromDate, String toDate) {
    BlocProvider.of<SelectDateBloc>(context).add(SetDate(fromDate: fromDate, toDate: toDate));
    BlocProvider.of<PaymentReportBloc>(context).add(GetPaymentReportApiData(
      context: context,
      fromDate: fromDate,
      toDate: toDate,
    ));
  }
}