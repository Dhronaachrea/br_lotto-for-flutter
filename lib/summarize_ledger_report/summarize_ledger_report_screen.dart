import 'package:br_lotto/home/widget/br_lotto_scaffold.dart';
import 'package:br_lotto/l10n/l10n.dart';
import 'package:br_lotto/summarize_ledger_report/scratch_retail_option.dart';
import 'package:br_lotto/utility/widgets/selectdate/select_week_month.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:velocity_x/velocity_x.dart';
import '../utility/app_constant.dart';
import '../utility/br_lotto_pos_color.dart';
import '../utility/date_format.dart';
import '../utility/utils.dart';
import '../utility/widgets/selectdate/bloc/select_date_bloc.dart';
import '../utility/widgets/selectdate/forward.dart';
import '../utility/widgets/selectdate/select_date.dart';
import '../utility/widgets/show_snackbar.dart';
import 'bloc/summarize_ledger_bloc.dart';
import 'bloc/summarize_ledger_event.dart';
import 'bloc/summarize_ledger_state.dart';

class SummarizeLedgerReportScreen extends StatefulWidget {
  final String? title;
  const SummarizeLedgerReportScreen({Key? key, required this.title}) : super(key: key);

  @override
  State<SummarizeLedgerReportScreen> createState() =>
      _SummarizeLedgerReportScreenState();
}

class _SummarizeLedgerReportScreenState
    extends State<SummarizeLedgerReportScreen> {
  int selectedIndex = 0;
  String? closingBalance = "";
  String? openingBalance = "";
  var selectedData = "";
  var fromDate = "";
  var toDate = "";

  ReportType reportType = ReportType.scratch;

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
                          date:
                              getLastMonthStartDate(DateTime.now()).toString(),
                          inputFormat: Format.apiDateFormat2,
                          outputFormat: Format.apiDateFormat3),
                      formatDate(
                          date: getLastMonthEndDate(DateTime.now()).toString(),
                          inputFormat: Format.apiDateFormat2,
                          outputFormat: Format.apiDateFormat3),
                    );
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
                        outputFormat: Format.apiDateFormat3),
                    formatDate(
                        date: context.read<SelectDateBloc>().toDate,
                        inputFormat: Format.dateFormat9,
                        outputFormat: Format.apiDateFormat3),
                  );
                },
              ),
            ],
          ).pSymmetric(v: 16, h: 10),
        ),
        Expanded(
          child: BlocConsumer<SummarizeLedgerBloc, SummarizeLedgerState>(
              listener: (context, state) {
            if (state is SummarizeLedgerDateWiseError) {
              ShowToast.showToast(context, state.errorMessage,
                  type: ToastType.ERROR);
            }
          }, builder: (context, state) {
            if (state is SummarizeLedgerLoading) {
              return Column(
                children: [
                  Container(
                    color: BrLottoPosColor.white_six,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                context.l10n.opening_balance,
                                style: const TextStyle(
                                    fontFamily: noirFont,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 12,
                                    color: BrLottoPosColor.brownish_grey_three),
                              ).p(5),
                              Text("${getDefaultCurrency(getLanguage())} ${openingBalance ?? ""}",
                                  style: const TextStyle(
                                      fontFamily: noirFont,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13,
                                      color: BrLottoPosColor.navy_blue))
                                  .pOnly(bottom: 10)
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                context.l10n.closing_balance,
                                style: const TextStyle(
                                    fontFamily: noirFont,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 12,
                                    color: BrLottoPosColor.brownish_grey_three),
                              ).p(5),
                              Text("${getDefaultCurrency(getLanguage())} ${closingBalance ?? ""}",
                                  style: const TextStyle(
                                      fontFamily: noirFont,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13,
                                      color: BrLottoPosColor.navy_blue))
                                  .pOnly(bottom: 10)
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Text(
                                context.l10n.gross,
                                style: const TextStyle(
                                    fontFamily: noirFont,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 12,
                                    color: BrLottoPosColor.brownish_grey_three),
                              ).p(5),
                              FlutterSwitch(
                                activeColor: Colors.green,
                                width: 60,
                                height: 32,
                                value: selectedIndex == 0 ? true : false,
                                borderRadius: 30.0,
                                onToggle: (val) {
                                  setState(() {
                                    selectedIndex = val ? 0 : 1;
                                    if (selectedData == context.l10n.this_week) {
                                      initData(
                                          formatDate(
                                              date: findFirstDateOfTheWeek(
                                                  DateTime.now())
                                                  .toString(),
                                              inputFormat: Format.apiDateFormat2,
                                              outputFormat:
                                              Format.apiDateFormat3),
                                          formatDate(
                                              date: findLastDateOfTheWeek(
                                                  DateTime.now())
                                                  .toString(),
                                              inputFormat: Format.apiDateFormat2,
                                              outputFormat:
                                              Format.apiDateFormat3));
                                    } else if (selectedData ==
                                        context.l10n.last_week) {
                                      initData(
                                          formatDate(
                                              date: findFirstDateOfPreviousWeek(
                                                  DateTime.now())
                                                  .toString(),
                                              inputFormat: Format.apiDateFormat2,
                                              outputFormat:
                                              Format.apiDateFormat3),
                                          formatDate(
                                              date: findLastDateOfPreviousWeek(
                                                  DateTime.now())
                                                  .toString(),
                                              inputFormat: Format.apiDateFormat2,
                                              outputFormat:
                                              Format.apiDateFormat3));
                                    } else if (selectedData ==
                                        context.l10n.last_month) {
                                      initData(
                                        formatDate(
                                            date: getLastMonthStartDate(
                                                DateTime.now())
                                                .toString(),
                                            inputFormat: Format.apiDateFormat2,
                                            outputFormat: Format.apiDateFormat3),
                                        formatDate(
                                            date: getLastMonthEndDate(
                                                DateTime.now())
                                                .toString(),
                                            inputFormat: Format.apiDateFormat2,
                                            outputFormat: Format.apiDateFormat3),
                                      );
                                    } else {
                                      initData(
                                        formatDate(
                                            date: context
                                                .read<SelectDateBloc>()
                                                .fromDate,
                                            inputFormat: Format.dateFormat9,
                                            outputFormat: Format.apiDateFormat3),
                                        formatDate(
                                            date: context
                                                .read<SelectDateBloc>()
                                                .toDate,
                                            inputFormat: Format.dateFormat9,
                                            outputFormat: Format.apiDateFormat3),
                                      );
                                    }
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ).pOnly(left: 5, right: 5, top: 5, bottom: 5),
                  ),
                  ScratchRetailOption(
                    onScratchTap: () {
                      setState(() {
                        reportType = ReportType.scratch;
                      });
                    },
                    onRetailTap: () {
                      setState(() {
                        reportType = ReportType.retail;
                      });
                    },
                    reportType: reportType,
                  ),
                  const Center(child: CircularProgressIndicator()),
                ],
              );
            } else if (state is SummarizeLedgerDateWiseSuccess) {
              openingBalance = state
                      .response.responseData?.data?.rawOpeningBalance
                      .toString() ??
                  "";

              closingBalance = state
                      .response.responseData?.data?.rawClosingBalance
                      .toString() ??
                  "";

              var ledgerData = state.response.responseData!.data!.ledgerData;
              var scratchLedgerData = ledgerData
                  ?.where(
                      (element) => element.txnData![0].serviceName == "Scratch")
                  .toList();
              var retailPaymentLedgerData = ledgerData
                  ?.where((element) =>
                      element.txnData![0].serviceName == "Retail Payments")
                  .toList();
              var filteredLedgerData = reportType == ReportType.scratch
                  ? scratchLedgerData
                  : retailPaymentLedgerData;

              return Column(
                children: [
                  Container(
                    color: BrLottoPosColor.white_six,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                context.l10n.opening_balance,
                                style: const TextStyle(
                                    fontFamily: noirFont,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 12,
                                    color: BrLottoPosColor.brownish_grey_three),
                              ).p(5),
                              Text("${getDefaultCurrency(getLanguage())} ${openingBalance ?? ""}",
                                  style: const TextStyle(
                                      fontFamily: noirFont,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13,
                                      color: BrLottoPosColor.navy_blue))
                                  .pOnly(bottom: 10)
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                context.l10n.closing_balance,
                                style: const TextStyle(
                                    fontFamily: noirFont,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 12,
                                    color: BrLottoPosColor.brownish_grey_three),
                              ).p(5),
                              Text("${getDefaultCurrency(getLanguage())} ${closingBalance ?? ""}",
                                  style: const TextStyle(
                                      fontFamily: noirFont,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13,
                                      color: BrLottoPosColor.navy_blue))
                                  .pOnly(bottom: 10)
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Text(
                                context.l10n.gross,
                                style: const TextStyle(
                                    fontFamily: noirFont,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 12,
                                    color: BrLottoPosColor.brownish_grey_three),
                              ).p(5),
                              FlutterSwitch(
                                activeColor: Colors.green,
                                width: 60,
                                height: 32,
                                value: selectedIndex == 0 ? true : false,
                                borderRadius: 30.0,
                                onToggle: (val) {
                                  setState(() {
                                    selectedIndex = val ? 0 : 1;
                                    if (selectedData == context.l10n.this_week) {
                                      initData(
                                          formatDate(
                                              date: findFirstDateOfTheWeek(
                                                  DateTime.now())
                                                  .toString(),
                                              inputFormat: Format.apiDateFormat2,
                                              outputFormat:
                                              Format.apiDateFormat3),
                                          formatDate(
                                              date: findLastDateOfTheWeek(
                                                  DateTime.now())
                                                  .toString(),
                                              inputFormat: Format.apiDateFormat2,
                                              outputFormat:
                                              Format.apiDateFormat3));
                                    } else if (selectedData ==
                                        context.l10n.last_week) {
                                      initData(
                                          formatDate(
                                              date: findFirstDateOfPreviousWeek(
                                                  DateTime.now())
                                                  .toString(),
                                              inputFormat: Format.apiDateFormat2,
                                              outputFormat:
                                              Format.apiDateFormat3),
                                          formatDate(
                                              date: findLastDateOfPreviousWeek(
                                                  DateTime.now())
                                                  .toString(),
                                              inputFormat: Format.apiDateFormat2,
                                              outputFormat:
                                              Format.apiDateFormat3));
                                    } else if (selectedData ==
                                        context.l10n.last_month) {
                                      initData(
                                        formatDate(
                                            date: getLastMonthStartDate(
                                                DateTime.now())
                                                .toString(),
                                            inputFormat: Format.apiDateFormat2,
                                            outputFormat: Format.apiDateFormat3),
                                        formatDate(
                                            date: getLastMonthEndDate(
                                                DateTime.now())
                                                .toString(),
                                            inputFormat: Format.apiDateFormat2,
                                            outputFormat: Format.apiDateFormat3),
                                      );
                                    } else {
                                      initData(
                                        formatDate(
                                            date: context
                                                .read<SelectDateBloc>()
                                                .fromDate,
                                            inputFormat: Format.dateFormat9,
                                            outputFormat: Format.apiDateFormat3),
                                        formatDate(
                                            date: context
                                                .read<SelectDateBloc>()
                                                .toDate,
                                            inputFormat: Format.dateFormat9,
                                            outputFormat: Format.apiDateFormat3),
                                      );
                                    }
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ).pOnly(left: 5, right: 5, top: 5, bottom: 5),
                  ),
                  ScratchRetailOption(
                    onScratchTap: () {
                      setState(() {
                        reportType = ReportType.scratch;
                      });
                    },
                    onRetailTap: () {
                      setState(() {
                        reportType = ReportType.retail;
                      });
                    },
                    reportType: reportType,
                  ),
                  Expanded(
                      child: filteredLedgerData != null &&
                              filteredLedgerData.isNotEmpty
                          ? ListView.separated(
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              itemCount: filteredLedgerData.length,
                              separatorBuilder:
                                  (BuildContext context, int index) =>
                                      const Divider(height: 0),
                              itemBuilder: (context, index) {

                                return Column(
                                  children: [
                                    index == 0 ? Column(
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Container(
                                                padding: const EdgeInsets.only(
                                                    top: 8, bottom: 8),
                                                color: const Color(0xff7492c2),
                                                child: Text(
                                                  textAlign: TextAlign.center,
                                                  "${filteredLedgerData[index].txnData![0].key1Name ?? ""} (${getDefaultCurrency(getLanguage())})",
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      fontFamily: noirFont,
                                                      fontWeight: FontWeight.w500,
                                                      color:
                                                      BrLottoPosColor.white),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                padding: const EdgeInsets.only(
                                                    top: 8, bottom: 8),
                                                color: const Color(0xff456eae),
                                                child: Text(
                                                  textAlign: TextAlign.center,
                                                  "${filteredLedgerData[index].txnData![0].key2Name ?? ""} (${getDefaultCurrency(getLanguage())})",
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      fontFamily: noirFont,
                                                      fontWeight: FontWeight.w500,
                                                      color:
                                                      BrLottoPosColor.white),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                padding: const EdgeInsets.only(
                                                    top: 8, bottom: 8),
                                                color: const Color(0xff7492c2),
                                                child: FittedBox(
                                                  child: Text(
                                                    textAlign: TextAlign.center,
                                                    "${context.l10n.net_amount_label} (${getDefaultCurrency(getLanguage())})",
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        fontFamily: noirFont,
                                                        fontWeight: FontWeight.w500,
                                                        color:
                                                        BrLottoPosColor.white),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ): Container(),
                                    Container(
                                      decoration: const BoxDecoration(
                                          color: BrLottoPosColor
                                              .pale_grey_three,
                                          boxShadow: [
                                            BoxShadow(blurRadius: 1)
                                          ]),
                                      child: Column(
                                        children: [
                                          Container(
                                            padding:
                                            const EdgeInsets.all(10),
                                            color: const Color(0xffa2b7d7),
                                            child: Row(
                                              mainAxisSize:
                                              MainAxisSize.max,
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                   Expanded(
                                                    child: Text(
                                                      textAlign:
                                                      TextAlign.center,
                                                      "${getDate(filteredLedgerData[index]
                                                          .date)} ",
                                                      style: const TextStyle(
                                                          fontSize: 14,
                                                          fontFamily:
                                                          noirFont,
                                                          fontWeight:
                                                          FontWeight.w500,
                                                          color:
                                                          BrLottoPosColor
                                                              .light_navy),
                                                    ).pOnly(
                                                        left: 10, right: 10),
                                                  ),
                                              ],
                                            ),
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  padding:
                                                  const EdgeInsets.only(
                                                      top: 8,
                                                      bottom: 8),
                                                  child: Text(
                                                    textAlign:
                                                    TextAlign.center,
                                                    filteredLedgerData[index]
                                                        .txnData![0].key1
                                                         ??
                                                        "",
                                                    style: const TextStyle(
                                                        fontSize: 12,
                                                        fontFamily:
                                                        noirFont,
                                                        fontWeight:
                                                        FontWeight.w500,
                                                        color:  BrLottoPosColor
                                                            .brownish_grey_three),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  padding:
                                                  const EdgeInsets.only(
                                                      top: 15,
                                                      bottom: 15),
                                                  color: const Color(
                                                      0xffd1dbeb),
                                                  child: Text(
                                                    textAlign:
                                                    TextAlign.center,
                                                    filteredLedgerData[index]
                                                        .txnData![0].key2 ??
                                                        "",
                                                    style: const TextStyle(
                                                        fontSize: 12,
                                                        fontFamily:
                                                        noirFont,
                                                        fontWeight:
                                                        FontWeight.w500,
                                                        color:
                                                        BrLottoPosColor
                                                            .brownish_grey_three),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  padding:
                                                  const EdgeInsets.only(
                                                      top: 8,
                                                      bottom: 8),
                                                  child: Text(
                                                    textAlign:
                                                    TextAlign.center,
                                                    filteredLedgerData[index]
                                                        .txnData![0].netAmount??
                                                        "",
                                                    style: const TextStyle(
                                                        fontSize: 12,
                                                        fontFamily:
                                                        noirFont,
                                                        fontWeight:
                                                        FontWeight.w500,
                                                        color: BrLottoPosColor
                                                            .brownish_grey_three),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                ]
                                );

                                // return Container(
                                //   decoration: BoxDecoration(
                                //       border: Border.all(
                                //     width: 0.1,
                                //   )),
                                //   padding:
                                //       const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                //   width: double.infinity,
                                //   child: Column(
                                //     crossAxisAlignment:
                                //         CrossAxisAlignment.start,
                                //     children: [
                                //       Text(
                                //         "${context.l10n.date} : ${filteredLedgerData[index].date}",
                                //         style: const TextStyle(
                                //           color:
                                //               BrLottoPosColor.brownish_grey_six,
                                //           fontSize: 18,
                                //         ),
                                //       ),
                                //       Text(
                                //         filteredLedgerData[index]
                                //                 .txnData![0]
                                //                 .serviceName ??
                                //             "",
                                //         style: const TextStyle(
                                //             color: BrLottoPosColor
                                //                 .brownish_grey_six,
                                //             fontSize: 18,
                                //             fontWeight: FontWeight.bold),
                                //       ),
                                //       Container(
                                //         margin: const EdgeInsets.fromLTRB(
                                //             0, 20, 0, 0),
                                //         child: Column(
                                //           children: [
                                //             Row(
                                //               mainAxisAlignment:
                                //                   MainAxisAlignment
                                //                       .spaceBetween,
                                //               children: [
                                //                 Text(
                                //                   filteredLedgerData[index]
                                //                           .txnData![0]
                                //                           .key1Name ??
                                //                       "",
                                //                   style: const TextStyle(
                                //                       color: BrLottoPosColor
                                //                           .brownish_grey_six,
                                //                       fontSize: 18),
                                //                 ),
                                //                 Text(
                                //                   filteredLedgerData[index]
                                //                           .txnData![0]
                                //                           .key1 ??
                                //                       "",
                                //                   style: const TextStyle(
                                //                       color: BrLottoPosColor
                                //                           .brownish_grey_six,
                                //                       fontSize: 18),
                                //                 ),
                                //               ],
                                //             ),
                                //             Row(
                                //               mainAxisAlignment:
                                //                   MainAxisAlignment
                                //                       .spaceBetween,
                                //               children: [
                                //                 Text(
                                //                   filteredLedgerData[index]
                                //                           .txnData![0]
                                //                           .key2Name ??
                                //                       "",
                                //                   style: const TextStyle(
                                //                       color: BrLottoPosColor
                                //                           .brownish_grey_six,
                                //                       fontSize: 18),
                                //                 ),
                                //                 Text(
                                //                   filteredLedgerData[index]
                                //                           .txnData![0]
                                //                           .key2 ??
                                //                       "",
                                //                   style: const TextStyle(
                                //                       color: BrLottoPosColor
                                //                           .brownish_grey_six,
                                //                       fontSize: 18),
                                //                 ),
                                //               ],
                                //             ),
                                //             Row(
                                //               mainAxisAlignment:
                                //                   MainAxisAlignment
                                //                       .spaceBetween,
                                //               children: [
                                //                 Text(
                                //                   context.l10n.net_amount,
                                //                   style: const TextStyle(
                                //                       color: BrLottoPosColor
                                //                           .brownish_grey_six,
                                //                       fontSize: 18),
                                //                 ),
                                //                 Text(
                                //                   double.parse(filteredLedgerData[
                                //                                       index]
                                //                                   .txnData![0]
                                //                                   .rawNetAmount ??
                                //                               "")
                                //                           .toString() ??
                                //                       "",
                                //                   style: const TextStyle(
                                //                       color: BrLottoPosColor
                                //                           .brownish_grey_six,
                                //                       fontSize: 18),
                                //                 ),
                                //               ],
                                //             ),
                                //           ],
                                //         ),
                                //       )
                                //     ],
                                //   ),
                                // );
                              })
                          : Container(
                              alignment: Alignment.center,
                              child: Text(
                                context.l10n.no_data_available,
                                style: TextStyle(
                                    color: BrLottoPosColor.black_four
                                        .withOpacity(0.5)),
                              ).p(10),
                            )),
                ],
              );
            } else if (state is SummarizeLedgerDefaultSuccess) {
              openingBalance = state
                      .response.responseData?.data?.rawOpeningBalance
                      .toString() ??
                  "";

              closingBalance = state
                      .response.responseData?.data?.rawClosingBalance
                      .toString() ??
                  "";

              var ledgerData = state.response.responseData!.data!.ledgerData;
              var scratchLedgerData = ledgerData
                  ?.where((element) => element.serviceName == "Scratch")
                  .toList();
              var retailPaymentLedgerData = ledgerData
                  ?.where((element) => element.serviceName == "Retail Payments")
                  .toList();
              var filteredLedgerData = reportType == ReportType.scratch
                  ? scratchLedgerData
                  : retailPaymentLedgerData;

              return Column(
                children: [
                  Container(
                    color: BrLottoPosColor.white_six,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                context.l10n.opening_balance,
                                style: const TextStyle(
                                    fontFamily: noirFont,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 12,
                                    color: BrLottoPosColor.brownish_grey_three),
                              ).p(5),
                              Text("${getDefaultCurrency(getLanguage())} ${openingBalance ?? ""}",
                                  style: const TextStyle(
                                      fontFamily: noirFont,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13,
                                      color: BrLottoPosColor.navy_blue))
                                  .pOnly(bottom: 10)
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                context.l10n.closing_balance,
                                style: const TextStyle(
                                    fontFamily: noirFont,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 12,
                                    color: BrLottoPosColor.brownish_grey_three),
                              ).p(5),
                              Text("${getDefaultCurrency(getLanguage())} ${closingBalance ?? ""}",
                                  style: const TextStyle(
                                      fontFamily: noirFont,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13,
                                      color: BrLottoPosColor.navy_blue))
                                  .pOnly(bottom: 10)
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Text(
                                context.l10n.gross,
                                style: const TextStyle(
                                    fontFamily: noirFont,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 12,
                                    color: BrLottoPosColor.brownish_grey_three),
                              ).p(5),
                              FlutterSwitch(
                                activeColor: Colors.green,
                                width: 60,
                                height: 32,
                                value: selectedIndex == 0 ? true : false,
                                borderRadius: 30.0,
                                onToggle: (val) {
                                  setState(() {
                                    selectedIndex = val ? 0 : 1;
                                    if (selectedData == context.l10n.this_week) {
                                      initData(
                                          formatDate(
                                              date: findFirstDateOfTheWeek(
                                                  DateTime.now())
                                                  .toString(),
                                              inputFormat: Format.apiDateFormat2,
                                              outputFormat:
                                              Format.apiDateFormat3),
                                          formatDate(
                                              date: findLastDateOfTheWeek(
                                                  DateTime.now())
                                                  .toString(),
                                              inputFormat: Format.apiDateFormat2,
                                              outputFormat:
                                              Format.apiDateFormat3));
                                    } else if (selectedData ==
                                        context.l10n.last_week) {
                                      initData(
                                          formatDate(
                                              date: findFirstDateOfPreviousWeek(
                                                  DateTime.now())
                                                  .toString(),
                                              inputFormat: Format.apiDateFormat2,
                                              outputFormat:
                                              Format.apiDateFormat3),
                                          formatDate(
                                              date: findLastDateOfPreviousWeek(
                                                  DateTime.now())
                                                  .toString(),
                                              inputFormat: Format.apiDateFormat2,
                                              outputFormat:
                                              Format.apiDateFormat3));
                                    } else if (selectedData ==
                                        context.l10n.last_month) {
                                      initData(
                                        formatDate(
                                            date: getLastMonthStartDate(
                                                DateTime.now())
                                                .toString(),
                                            inputFormat: Format.apiDateFormat2,
                                            outputFormat: Format.apiDateFormat3),
                                        formatDate(
                                            date: getLastMonthEndDate(
                                                DateTime.now())
                                                .toString(),
                                            inputFormat: Format.apiDateFormat2,
                                            outputFormat: Format.apiDateFormat3),
                                      );
                                    } else {
                                      initData(
                                        formatDate(
                                            date: context
                                                .read<SelectDateBloc>()
                                                .fromDate,
                                            inputFormat: Format.dateFormat9,
                                            outputFormat: Format.apiDateFormat3),
                                        formatDate(
                                            date: context
                                                .read<SelectDateBloc>()
                                                .toDate,
                                            inputFormat: Format.dateFormat9,
                                            outputFormat: Format.apiDateFormat3),
                                      );
                                    }
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ).pOnly(left: 5, right: 5, top: 5, bottom: 5),
                  ),
                  ScratchRetailOption(
                    onScratchTap: () {
                      setState(() {
                        reportType = ReportType.scratch;
                      });
                    },
                    onRetailTap: () {
                      setState(() {
                        reportType = ReportType.retail;
                      });
                    },
                    reportType: reportType,
                  ),
                  Expanded(
                      child: filteredLedgerData != null &&
                              filteredLedgerData.isNotEmpty
                          ? ListView.separated(
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              itemCount: filteredLedgerData.length,
                              separatorBuilder:
                                  (BuildContext context, int index) =>
                                      const Divider(height: 0),
                              itemBuilder: (context, index) {
                                return Column(
                                    children: [
                                      index == 0 ?  Column(
                                        children: [
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  padding: const EdgeInsets.only(
                                                      top: 8, bottom: 8),
                                                  color: const Color(0xff7492c2),
                                                  child: Text(
                                                    textAlign: TextAlign.center,
                                                    "${filteredLedgerData[index].key1Name ?? ""} (${getDefaultCurrency(getLanguage())})",
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        fontFamily: noirFont,
                                                        fontWeight: FontWeight.w500,
                                                        color:
                                                        BrLottoPosColor.white),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  padding: const EdgeInsets.only(
                                                      top: 8, bottom: 8),
                                                  color: const Color(0xff456eae),
                                                  child: Text(
                                                    textAlign: TextAlign.center,
                                                    "${filteredLedgerData[index].key2Name ?? ""} (${getDefaultCurrency(getLanguage())})",
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        fontFamily: noirFont,
                                                        fontWeight: FontWeight.w500,
                                                        color:
                                                        BrLottoPosColor.white),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  padding: const EdgeInsets.only(
                                                      top: 8, bottom: 8),
                                                  color: const Color(0xff7492c2),
                                                  child: FittedBox(
                                                    child: Text(
                                                      textAlign: TextAlign.center,
                                                      "${context.l10n.net_amount_label} (${getDefaultCurrency(getLanguage())})",
                                                      style: const TextStyle(
                                                          fontSize: 14,
                                                          fontFamily: noirFont,
                                                          fontWeight: FontWeight.w500,
                                                          color:
                                                          BrLottoPosColor.white),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ): Container(),
                                      Container(
                                        decoration: const BoxDecoration(
                                            color: BrLottoPosColor
                                                .pale_grey_three,
                                            boxShadow: [
                                              BoxShadow(blurRadius: 1)
                                            ]),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    padding:
                                                    const EdgeInsets.only(
                                                        top: 8,
                                                        bottom: 8),
                                                    child: Text(
                                                      textAlign:
                                                      TextAlign.center,
                                                      filteredLedgerData[index].key1
                                                          ??
                                                          "",
                                                      style: const TextStyle(
                                                          fontSize: 12,
                                                          fontFamily:
                                                          noirFont,
                                                          fontWeight:
                                                          FontWeight.w500,
                                                          color:  BrLottoPosColor
                                                              .brownish_grey_three),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    padding:
                                                    const EdgeInsets.only(
                                                        top: 15,
                                                        bottom: 15),
                                                    color: const Color(
                                                        0xffd1dbeb),
                                                    child: Text(
                                                      textAlign:
                                                      TextAlign.center,
                                                      filteredLedgerData[index].key2 ??
                                                          "",
                                                      style: const TextStyle(
                                                          fontSize: 12,
                                                          fontFamily:
                                                          noirFont,
                                                          fontWeight:
                                                          FontWeight.w500,
                                                          color:
                                                          BrLottoPosColor
                                                              .brownish_grey_three),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Container(
                                                    padding:
                                                    const EdgeInsets.only(
                                                        top: 8,
                                                        bottom: 8),
                                                    child: Text(
                                                      textAlign:
                                                      TextAlign.center,
                                                      filteredLedgerData[index].netAmount??
                                                          "",
                                                      style: const TextStyle(
                                                          fontSize: 12,
                                                          fontFamily:
                                                          noirFont,
                                                          fontWeight:
                                                          FontWeight.w500,
                                                          color: BrLottoPosColor
                                                              .brownish_grey_three),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      )
                                    ]
                                );

                                // return Container(
                                //   decoration: BoxDecoration(
                                //       border: Border.all(
                                //     width: 0.1,
                                //   )),
                                //   padding:
                                //       const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                //   width: double.infinity,
                                //   child: Column(
                                //     crossAxisAlignment:
                                //         CrossAxisAlignment.start,
                                //     children: [
                                //       Text(
                                //         filteredLedgerData[index].serviceName ??
                                //             "",
                                //         style: const TextStyle(
                                //             color: BrLottoPosColor
                                //                 .brownish_grey_six,
                                //             fontSize: 18,
                                //             fontWeight: FontWeight.bold),
                                //       ),
                                //       Container(
                                //         margin: const EdgeInsets.fromLTRB(
                                //             0, 20, 0, 0),
                                //         child: Column(
                                //           children: [
                                //             Row(
                                //               mainAxisAlignment:
                                //                   MainAxisAlignment
                                //                       .spaceBetween,
                                //               children: [
                                //                 Text(
                                //                   filteredLedgerData[index]
                                //                           .key1Name ??
                                //                       "",
                                //                   style: const TextStyle(
                                //                       color: BrLottoPosColor
                                //                           .brownish_grey_six,
                                //                       fontSize: 18),
                                //                 ),
                                //                 Text(
                                //                   filteredLedgerData[index]
                                //                           .key1 ??
                                //                       "",
                                //                   style: const TextStyle(
                                //                       color: BrLottoPosColor
                                //                           .brownish_grey_six,
                                //                       fontSize: 18),
                                //                 ),
                                //               ],
                                //             ),
                                //             Row(
                                //               mainAxisAlignment:
                                //                   MainAxisAlignment
                                //                       .spaceBetween,
                                //               children: [
                                //                 Text(
                                //                   filteredLedgerData[index]
                                //                           .key2Name ??
                                //                       "",
                                //                   style: const TextStyle(
                                //                       color: BrLottoPosColor
                                //                           .brownish_grey_six,
                                //                       fontSize: 18),
                                //                 ),
                                //                 Text(
                                //                   filteredLedgerData[index]
                                //                           .key2 ??
                                //                       "",
                                //                   style: const TextStyle(
                                //                       color: BrLottoPosColor
                                //                           .brownish_grey_six,
                                //                       fontSize: 18),
                                //                 ),
                                //               ],
                                //             ),
                                //             Row(
                                //               mainAxisAlignment:
                                //                   MainAxisAlignment
                                //                       .spaceBetween,
                                //               children: [
                                //                 Text(
                                //                   context.l10n.net_amount,
                                //                   style: const TextStyle(
                                //                       color: BrLottoPosColor
                                //                           .brownish_grey_six,
                                //                       fontSize: 18),
                                //                 ),
                                //                 Text(
                                //                   filteredLedgerData[index]
                                //                           .netAmount ??
                                //                       "",
                                //                   style: const TextStyle(
                                //                       color: BrLottoPosColor
                                //                           .brownish_grey_six,
                                //                       fontSize: 18),
                                //                 ),
                                //               ],
                                //             ),
                                //           ],
                                //         ),
                                //       )
                                //     ],
                                //   ),
                                // );
                              })
                          : Container(
                              alignment: Alignment.center,
                              child: Text(
                                context.l10n.no_data_available,
                                style: TextStyle(
                                    color: BrLottoPosColor.black_four
                                        .withOpacity(0.5)),
                              ).p(10),
                            )),
                ],
              );
            } else if (state is SummarizeLedgerDateWiseError) {
              String responseMessage = state.errorMessage;
              return Column(
                children: [
                  Container(
                    color: BrLottoPosColor.white_six,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                context.l10n.opening_balance,
                                style: const TextStyle(
                                    fontFamily: noirFont,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 12,
                                    color: BrLottoPosColor.brownish_grey_three),
                              ).p(5),
                              Text("${getDefaultCurrency(getLanguage())} ${openingBalance ?? ""}",
                                  style: const TextStyle(
                                      fontFamily: noirFont,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13,
                                      color: BrLottoPosColor.navy_blue))
                                  .pOnly(bottom: 10)
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                context.l10n.closing_balance,
                                style: const TextStyle(
                                    fontFamily: noirFont,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 12,
                                    color: BrLottoPosColor.brownish_grey_three),
                              ).p(5),
                              Text("${getDefaultCurrency(getLanguage())} ${closingBalance ?? ""}",
                                  style: const TextStyle(
                                      fontFamily: noirFont,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13,
                                      color: BrLottoPosColor.navy_blue))
                                  .pOnly(bottom: 10)
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Text(
                                context.l10n.gross,
                                style: const TextStyle(
                                    fontFamily: noirFont,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 12,
                                    color: BrLottoPosColor.brownish_grey_three),
                              ).p(5),
                              FlutterSwitch(
                                activeColor: Colors.green,
                                width: 60,
                                height: 32,
                                value: selectedIndex == 0 ? true : false,
                                borderRadius: 30.0,
                                onToggle: (val) {
                                  setState(() {
                                    selectedIndex = val ? 0 : 1;
                                    if (selectedData == context.l10n.this_week) {
                                      initData(
                                          formatDate(
                                              date: findFirstDateOfTheWeek(
                                                  DateTime.now())
                                                  .toString(),
                                              inputFormat: Format.apiDateFormat2,
                                              outputFormat:
                                              Format.apiDateFormat3),
                                          formatDate(
                                              date: findLastDateOfTheWeek(
                                                  DateTime.now())
                                                  .toString(),
                                              inputFormat: Format.apiDateFormat2,
                                              outputFormat:
                                              Format.apiDateFormat3));
                                    } else if (selectedData ==
                                        context.l10n.last_week) {
                                      initData(
                                          formatDate(
                                              date: findFirstDateOfPreviousWeek(
                                                  DateTime.now())
                                                  .toString(),
                                              inputFormat: Format.apiDateFormat2,
                                              outputFormat:
                                              Format.apiDateFormat3),
                                          formatDate(
                                              date: findLastDateOfPreviousWeek(
                                                  DateTime.now())
                                                  .toString(),
                                              inputFormat: Format.apiDateFormat2,
                                              outputFormat:
                                              Format.apiDateFormat3));
                                    } else if (selectedData ==
                                        context.l10n.last_month) {
                                      initData(
                                        formatDate(
                                            date: getLastMonthStartDate(
                                                DateTime.now())
                                                .toString(),
                                            inputFormat: Format.apiDateFormat2,
                                            outputFormat: Format.apiDateFormat3),
                                        formatDate(
                                            date: getLastMonthEndDate(
                                                DateTime.now())
                                                .toString(),
                                            inputFormat: Format.apiDateFormat2,
                                            outputFormat: Format.apiDateFormat3),
                                      );
                                    } else {
                                      initData(
                                        formatDate(
                                            date: context
                                                .read<SelectDateBloc>()
                                                .fromDate,
                                            inputFormat: Format.dateFormat9,
                                            outputFormat: Format.apiDateFormat3),
                                        formatDate(
                                            date: context
                                                .read<SelectDateBloc>()
                                                .toDate,
                                            inputFormat: Format.dateFormat9,
                                            outputFormat: Format.apiDateFormat3),
                                      );
                                    }
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ).pOnly(left: 5, right: 5, top: 5, bottom: 5),
                  ),
                  ScratchRetailOption(
                    onScratchTap: () {
                      setState(() {
                        reportType = ReportType.scratch;
                      });
                    },
                    onRetailTap: () {
                      setState(() {
                        reportType = ReportType.retail;
                      });
                    },
                    reportType: reportType,
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      responseMessage,
                      style: TextStyle(
                          color: BrLottoPosColor.black_four.withOpacity(0.5)),
                    ).p(10),
                  ),
                ],
              );
            }
            return Container();
          }),
        )
      ],
    );
    return BrLottoScaffold(
      showAppBar: true,
      appBarTitle: widget.title ?? context.l10n.summarize_ledger_report,
      body: body,
    );
  }

  @override
  void initState() {
    super.initState();
    initData(
      formatDate(
        date: findFirstDateOfTheWeek(DateTime.now()).toString(),
        inputFormat: Format.apiDateFormat2,
        outputFormat: Format.apiDateFormat3,
      ),
      formatDate(
        date: findLastDateOfTheWeek(DateTime.now()).toString(),
        inputFormat: Format.apiDateFormat2,
        outputFormat: Format.apiDateFormat3,
      ),
    );
  }

  void initData(String fromDate, String toDate) {
    BlocProvider.of<SelectDateBloc>(context)
        .add(SetDate(fromDate: fromDate, toDate: toDate));
    BlocProvider.of<SummarizeLedgerBloc>(context).add(SummarizeLedgerModel(
      url: "",
      type: selectedIndex == 0 ? "default" : "datewise",
      context: context,
      startDate: fromDate,
      endDate: toDate,
    ));
  }
  String getDate(String? createdAt) {
    String fromDate = formatDate(
      date: createdAt!,
      inputFormat: "yyyy/MM/dd",
      outputFormat: "MMM dd, yyyy",
    );

    return fromDate;
  }

  String getTime(String? createdAt) {
    String fromDate = formatDate(
      date: createdAt!,
      inputFormat: Format.apiDateFormat,
      outputFormat: Format.dateFormat,
    );
    List<String> splitag = fromDate.split(",");
    String? splitag2 = splitag[1];
    return splitag2;
  }
// scratchOrRetailUi(
//     {required VoidCallback onScratchTap, required VoidCallback onRetailTap}) {
//   double scratchOrRetailHeight = 40;
//   return SizedBox(
//     height: scratchOrRetailHeight,
//     child: Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         InkWell(
//           onTap: onScratchTap,
//           child: Container(
//             width: context.screenWidth / 2.5,
//             height: scratchOrRetailHeight,
//             decoration: BoxDecoration(
//               color: reportType == ReportType.scratch
//                   ? BrLottoPosColor.medium_green
//                   : BrLottoPosColor.white,
//               border:
//               Border.all(color: BrLottoPosColor.medium_green, width: 4),
//               borderRadius: const BorderRadius.only(
//                 topLeft: Radius.circular(30),
//                 bottomLeft: Radius.circular(30),
//               ),
//             ),
//             child: Text(context.l10n.scratch.toUpperCase(),
//                 style: TextStyle(
//                     color: reportType == ReportType.scratch
//                         ? BrLottoPosColor.white
//                         : BrLottoPosColor.medium_green,
//                     fontWeight: FontWeight.w500,
//                     fontFamily: "",
//                     fontStyle: FontStyle.normal,
//                     fontSize: 12.0),
//                 textAlign: TextAlign.center)
//                 .p(8),
//           ),
//         ),
//         InkWell(
//           onTap: () {
//             setState(() {
//               reportType = ReportType.retail;
//             });
//           },
//           child: Container(
//             width: context.screenWidth / 2.5,
//             height: scratchOrRetailHeight,
//             decoration: BoxDecoration(
//               color: reportType == ReportType.retail
//                   ? BrLottoPosColor.medium_green
//                   : BrLottoPosColor.white,
//               border:
//               Border.all(color: BrLottoPosColor.medium_green, width: 4),
//               borderRadius: const BorderRadius.only(
//                 topRight: Radius.circular(30),
//                 bottomRight: Radius.circular(30),
//               ),
//             ),
//             child: FittedBox(
//               child: Text(context.l10n.retail_payment.toUpperCase(),
//               child: Text(context.l10n.retail_payment.toUpperCase(),
//                   style: TextStyle(
//                       color: reportType == ReportType.retail
//                           ? BrLottoPosColor.white
//                           : BrLottoPosColor.medium_green,
//                       fontWeight: FontWeight.w500,
//                       fontFamily: "",
//                       fontStyle: FontStyle.normal,
//                       fontSize: 12.0),
//                   textAlign: TextAlign.center)
//                   .p(8),
//             ),
//           ),
//         ),
//       ],
//     ),
//   );
// }
//}
}
