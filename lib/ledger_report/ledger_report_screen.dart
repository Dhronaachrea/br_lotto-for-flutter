import 'package:br_lotto/home/widget/br_lotto_scaffold.dart';
import 'package:br_lotto/l10n/l10n.dart';
import 'package:br_lotto/utility/widgets/selectdate/select_week_month.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:velocity_x/velocity_x.dart';

import '../utility/app_constant.dart';
import '../utility/br_lotto_pos_color.dart';
import '../utility/date_format.dart';
import '../utility/rounded_container.dart';
import '../utility/utils.dart';
import '../utility/widgets/br_lotto_pos_scaffold.dart';
import '../utility/widgets/selectdate/bloc/select_date_bloc.dart';
import '../utility/widgets/selectdate/forward.dart';
import '../utility/widgets/selectdate/select_date.dart';
import '../utility/widgets/show_snackbar.dart';
import 'bloc/ledger_report_bloc.dart';
import 'bloc/ledger_report_event.dart';
import 'bloc/ledger_report_state.dart';
import 'models/response/ledgerReportApiResponse.dart';
import 'dart:math' as math;

class LedgerReportScreen extends StatefulWidget {
  final String? title;
  const LedgerReportScreen({Key? key, required this.title}) : super(key: key);

  @override
  _LedgerReportState createState() => _LedgerReportState();
}

class _LedgerReportState extends State<LedgerReportScreen> {

  var selectedData = "";

  @override
  void initState() {
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
                    ),
                  );
                },
              ),
            ],
          ).pSymmetric(v: 16, h: 10),
        ),
        BlocConsumer<LedgerReportBloc, LedgerReportState>(
            listener: (context, state) {
          if (state is LedgerReportError) {
            ShowToast.showToast(context, state.errorMessage,
                type: ToastType.ERROR);
          }
        }, builder: (context, state) {
          if (state is LedgerReportLoading) {
            return Container(
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            ).p(10);
          } else if (state is LedgerReportSuccess) {
            LedgerReportApiResponse ledgerReportApiResponse =
                state.ledgerReportApiResponse;
            List<Transaction>? transList =
                ledgerReportApiResponse.responseData!.data!.transaction;
            String? closingBalance = state.ledgerReportApiResponse.responseData!
                .data!.balance!.closingBalance;
            String? openingBalance = state.ledgerReportApiResponse.responseData!
                .data!.balance!.openingBalance;
            return Expanded(
                child: Column(
              children: [
                Container(
                  color: BrLottoPosColor.pale_grey_four,
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
                                  color: BrLottoPosColor.brownish_grey_three),
                            ).p(10),
                            Text( "${getDefaultCurrency(getLanguage())} ${openingBalance ?? ""}",
                                    style: const TextStyle(
                                        fontFamily: noirFont,
                                        fontWeight: FontWeight.w500,
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
                                  color: BrLottoPosColor.brownish_grey_three),
                            ).p(10),
                            Text("${getDefaultCurrency(getLanguage())} ${closingBalance ?? ""}",
                                    style: const TextStyle(
                                        fontFamily: noirFont,
                                        fontWeight: FontWeight.w500,
                                        color: BrLottoPosColor.navy_blue))
                                .pOnly(bottom: 10)
                          ],
                        ),
                      ),
                    ],
                  ).pOnly(left: 25, right: 25),
                ),
                transList!.isNotEmpty
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
                                                    getDate(transList[index]
                                                        .createdAt),
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
                                                0.5,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              transList[index].particular!,
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
                                                    transList[index]
                                                                .serviceDisplayName !=
                                                            null
                                                        ? transList[index]
                                                            .serviceDisplayName!
                                                        : '',
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
                                                0.2,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            FittedBox(
                                              child: Text("${getDefaultCurrency(getLanguage())} ${transList[index].amount!}",
                                                      style: TextStyle(
                                                          color: transList[index]
                                                                      .transactionMode ==
                                                                  'Dr.'
                                                              ? BrLottoPosColor
                                                                  .tomato
                                                              : BrLottoPosColor
                                                                  .shamrock_green,
                                                          fontFamily: noirFont,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w500))
                                                  .pOnly(bottom: 5),
                                            ),
                                            FittedBox(
                                              child: Text(
                                                "${getDefaultCurrency(getLanguage())} ${transList[index].availableBalance!}",
                                                  style: TextStyle(
                                                      fontSize: 14,
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
          } else if (state is LedgerReportError) {
            return Container();
          }
          return Column(
            children: [
              Container(
                color: BrLottoPosColor.white,
                // constraints: BoxConstraints(
                //   minHeight: context.screenHeight / 7,
                // ),
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
                        // context.read<DepWithBloc>().add(
                        //       GetDepWith(
                        //         context: context,
                        //         fromDate: context.watch<SelectDateBloc>().fromDate,
                        //         toDate: context.watch<SelectDateBloc>().toDate,
                        //       ),
                        //     );
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
                          ),
                        );
                      },
                    ),
                  ],
                ).pSymmetric(v: 16, h: 10),
              ),
            ],
          );
        })
      ],
    );
    return BrLottoScaffold(
      showAppBar: true,
      appBarTitle: widget.title ?? context.l10n.ledger_report,
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
    BlocProvider.of<LedgerReportBloc>(context).add(GetLedgerReportApiData(
      context: context,
      fromDate: fromDate,
      toDate: toDate
    ));
  }
}
