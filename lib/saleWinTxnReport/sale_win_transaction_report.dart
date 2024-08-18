import 'package:br_lotto/home/widget/br_lotto_scaffold.dart';
import 'package:br_lotto/l10n/l10n.dart';
import 'package:br_lotto/utility/app_constant.dart';
import 'package:br_lotto/utility/widgets/selectdate/select_week_month.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:velocity_x/velocity_x.dart';

import '../utility/br_lotto_pos_color.dart';
import '../utility/date_format.dart';
import '../utility/rounded_container.dart';
import '../utility/utils.dart';
import '../utility/widgets/br_lotto_pos_scaffold.dart';
import '../utility/widgets/selectdate/bloc/select_date_bloc.dart';
import '../utility/widgets/selectdate/forward.dart';
import '../utility/widgets/selectdate/select_date.dart';
import '../utility/widgets/show_snackbar.dart';
import 'bloc/sale_win_bloc.dart';
import 'bloc/sale_win_event.dart';
import 'bloc/sale_win_state.dart';
import 'model/get_sale_report_response.dart';
import 'model/get_service_list_response.dart';

class SaleWinTransactionReport extends StatefulWidget {
  final String? title;
  const SaleWinTransactionReport({Key? key,required this.title}) : super(key: key);

  @override
  State<SaleWinTransactionReport> createState() =>
      _SaleWinTransactionReportState();
}

bool _saleListLoading = true;
bool _saleWinTransactionLoading = true;
List<Data> _data = [];

class _SaleWinTransactionReportState extends State<SaleWinTransactionReport> {
  String _selectedItem = "";
  String serviceCode = "";

  final List<String> _picGroup = [];

  late GetSaleReportResponse transactionResponse = GetSaleReportResponse();
  late List<TransactionData> mTransactionList = [];

  String mErrorString = "";

  var selectedData = "";
  var fromDate = "";
  var toDate = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      BlocProvider.of<SaleWinBloc>(context)
          .add(SaleList(context: context, url: ""));
    });
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
    var body = BlocListener<SaleWinBloc, SaleWinState>(
        listener: (context, state) {
          if (state is SaleListLoading) {
            setState(() {
              _saleListLoading = true;
            });
          } else if (state is SaleListError) {
            setState(() {
              _saleListLoading = false;
            });
            ShowToast.showToast(context, state.errorMessage.toString(),
                type: ToastType.ERROR);
          } else if (state is SaleListSuccess) {
            setState(() {
              _saleListLoading = false;
              _data = state.response.responseData!.data!;

              for (var element in _data) {
                _picGroup.add(element.serviceDisplayName!);
              }

              _selectedItem = _data[0].serviceDisplayName!;

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
            });
          } else if (state is SaleWinTaxListLoading) {
            setState(() {
              _saleWinTransactionLoading = true;
            });
          } else if (state is SaleWinTaxListError) {
            ShowToast.showToast(context, state.errorMessage,
                type: ToastType.ERROR);
            mTransactionList = [];
            mErrorString = state.errorMessage;
            setState(() {
              _saleWinTransactionLoading = false;
            });
          } else if (state is SaleWinTaxListSuccess) {
            setState(() {
              mTransactionList = [];
              _saleWinTransactionLoading = false;
              transactionResponse = state.response;
              mTransactionList =
                  transactionResponse.responseData!.data!.transactionData!;
            });
          }
        },
        child: _data.isNotEmpty
            ? Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                      color: Colors.grey,
                      width: 1,
                    )),
                    margin: const EdgeInsets.all(10),
                    child: SizedBox(
                      height: 48,
                      child: DropdownButtonFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            filled: true,
                          ),
                          isExpanded: true,
                          isDense: true,
                          value: _selectedItem,
                          selectedItemBuilder: (BuildContext context) {
                            return _picGroup.map<Widget>((String item) {
                              return DropdownMenuItem(
                                  value: item, child: Text(item));
                            }).toList();
                          },
                          items: _picGroup.map((item) {
                            if (item == _selectedItem) {
                              return DropdownMenuItem(
                                value: item,
                                child: Container(
                                    height: 48.0,
                                    width: double.infinity,
                                    color: BrLottoPosColor.light_dark_white,
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        item,
                                      ),
                                    )),
                              );
                            } else {
                              return DropdownMenuItem(
                                value: item,
                                child: Text(item),
                              );
                            }
                          }).toList(),
                          validator: (value) =>
                              value?.isEmpty ?? true ? 'Cannot Empty' : null,
                          onChanged: (item) => {_selectedItem = item!}),
                    ),
                  ).pSymmetric(v: 5, h: 5),
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
                                  fromDate = formatDate(
                                      date: findFirstDateOfTheWeek(DateTime.now())
                                          .toString(),
                                      inputFormat: Format.apiDateFormat2,
                                      outputFormat: Format.apiDateFormat3),
                                  toDate = formatDate(
                                      date: findLastDateOfTheWeek(DateTime.now())
                                          .toString(),
                                      inputFormat: Format.apiDateFormat2,
                                      outputFormat: Format.apiDateFormat3));
                            } else if (selectedData == context.l10n.last_week) {
                              initData(
                                  fromDate = formatDate(
                                      date: findFirstDateOfPreviousWeek(DateTime.now())
                                          .toString(),
                                      inputFormat: Format.apiDateFormat2,
                                      outputFormat: Format.apiDateFormat3),
                                  toDate = formatDate(
                                      date: findLastDateOfPreviousWeek(DateTime.now())
                                          .toString(),
                                      inputFormat: Format.apiDateFormat2,
                                      outputFormat: Format.apiDateFormat3));
                            } else if (selectedData == context.l10n.last_month) {
                              initData(
                                  fromDate = formatDate(
                                      date: getLastMonthStartDate(DateTime.now())
                                          .toString(),
                                      inputFormat: Format.apiDateFormat2,
                                      outputFormat: Format.apiDateFormat3),
                                  toDate = formatDate(
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
                  Row(
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
                  ),
                  !_saleWinTransactionLoading
                      ? Expanded(
                          child: Column(
                          children: [
                            mTransactionList.isNotEmpty
                                ? Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            color: BrLottoPosColor.white_six,
                                            border: Border.all(
                                                color: BrLottoPosColor.black
                                                    .withOpacity(0.1))),
                                        margin: const EdgeInsets.only(
                                            top: 10, bottom: 0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                children: [
                                                  Text(
                                                    textAlign: TextAlign.center,
                                                    context.l10n.total_sale,
                                                    style: const TextStyle(
                                                        fontFamily: noirFont,
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        color: BrLottoPosColor
                                                            .brownish_grey_three),
                                                  ),
                                                  Container(
                                                    margin: const EdgeInsets
                                                        .fromLTRB(2, 10, 2,0),
                                                    child: Text(
                                                        "${getDefaultCurrency(getLanguage())} ${transactionResponse
                                                            .responseData
                                                            ?.data
                                                            ?.total
                                                            ?.sumOfSale
                                                            ?.toString() ??
                                                            ""}",
                                                      style: const TextStyle(
                                                          fontFamily: noirFont,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: BrLottoPosColor
                                                              .navy_blue,
                                                      fontSize: 12),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              child: Column(
                                                children: [
                                                  Text(
                                                    textAlign: TextAlign.center,
                                                    context.l10n.total_winning,
                                                    style: const TextStyle(
                                                        fontFamily: noirFont,
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        color: BrLottoPosColor
                                                            .brownish_grey_three),
                                                  ),
                                                  Container(
                                                    margin: const EdgeInsets
                                                        .fromLTRB(2, 10, 2, 0),
                                                    child: Text(
                                                        "${getDefaultCurrency(getLanguage())} ${transactionResponse
                                                            .responseData
                                                            ?.data
                                                            ?.total
                                                            ?.sumOfWinning
                                                            ?.toString() ??
                                                            ""}",
                                                        style: const TextStyle(
                                                            fontFamily:
                                                                noirFont,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color:
                                                                BrLottoPosColor
                                                                    .navy_blue)),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              child: Column(children: [
                                                Text(
                                                  textAlign: TextAlign.center,
                                                  context.l10n.net_amount,
                                                  style: const TextStyle(
                                                      fontFamily: noirFont,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontStyle:
                                                          FontStyle.normal,
                                                      color: BrLottoPosColor
                                                          .brownish_grey_three),
                                                ),
                                                Container(
                                                  margin:
                                                      const EdgeInsets.fromLTRB(
                                                          2, 10, 2, 0),
                                                  child: Text(
                                                      "${getDefaultCurrency(getLanguage())} ${transactionResponse
                                                          .responseData
                                                          ?.data
                                                          ?.total
                                                          ?.netSale
                                                          ?.toString() ??
                                                          ""}",
                                                      style: TextStyle(
                                                        color: double.parse(transactionResponse
                                                                        .responseData
                                                                        ?.data
                                                                        ?.total
                                                                        ?.rawNetSale ??
                                                                    "0.0") >
                                                                0.0
                                                            ? BrLottoPosColor
                                                                .shamrock_green
                                                            : BrLottoPosColor
                                                                .tomato,
                                                        fontFamily: noirFont,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      )),
                                                )
                                              ]),
                                            ),
                                            Expanded(
                                              child: Column(
                                                children: [
                                                  Text(
                                                    textAlign: TextAlign.center,
                                                    context.l10n.total_comm,
                                                    style: const TextStyle(
                                                        fontFamily: noirFont,
                                                        fontStyle:
                                                            FontStyle.normal,
                                                        color: BrLottoPosColor
                                                            .brownish_grey_three),
                                                  ),
                                                  Container(
                                                    margin: const EdgeInsets
                                                        .fromLTRB(2, 10, 2, 0),
                                                    child: Text(
                                                    "${getDefaultCurrency(getLanguage())} ${ double.parse(transactionResponse
                                                        .responseData
                                                        ?.data
                                                        ?.total
                                                        ?.rawNetCommission!
                                                        .toString() ??
                                                        "0.0")
                                                        .toString() ??
                                                        ""}",
                                                      style: const TextStyle(
                                                          fontFamily: noirFont,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: BrLottoPosColor
                                                              .navy_blue),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ).pOnly(
                                            left: 15,
                                            right: 15,
                                            top: 10,
                                            bottom: 10),
                                      ),
                                      IntrinsicHeight(
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.stretch,
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
                                                  "${context.l10n.amount} (${getDefaultCurrency(getLanguage())})",
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
                                                  "${context.l10n.commission} (${getDefaultCurrency(getLanguage())})",
                                                  textAlign: TextAlign.center,
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
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                : Container(),
                            if (mTransactionList.isNotEmpty ?? false)
                              Expanded(
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      padding: EdgeInsets.zero,
                                      itemCount: mTransactionList.length,
                                      itemBuilder: (context, index) {
                                        return Container(
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
                                                            TextAlign.start,
                                                        "${getDate(mTransactionList[index].createdAt)} ${getTime(mTransactionList[index].createdAt)} (#${mTransactionList[index].txnId})",
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
                                                    Expanded(
                                                      child: Text(
                                                        textAlign:
                                                            TextAlign.end,
                                                        "${mTransactionList[index].txnTypeCode ?? ""} : ${mTransactionList[index].gameName ?? ""}",
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
                                                        mTransactionList[index]
                                                                .txnValue ??
                                                            "",
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            fontFamily:
                                                                noirFont,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: (mTransactionList[index]
                                                                            .txnTypeCode ??
                                                                        "") ==
                                                                    "Sale"
                                                                ? BrLottoPosColor
                                                                    .tomato
                                                                : BrLottoPosColor
                                                                    .shamrock_green),
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
                                                        mTransactionList[index]
                                                                .orgCommValue ??
                                                            "",
                                                        style: const TextStyle(
                                                            fontSize: 18,
                                                            fontFamily:
                                                                noirFont,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color:
                                                                BrLottoPosColor
                                                                    .light_navy),
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
                                                        mTransactionList[index]
                                                                .orgNetAmount ??
                                                            "",
                                                        style: const TextStyle(
                                                            fontSize: 18,
                                                            fontFamily:
                                                                noirFont,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: BrLottoPosColor
                                                                .brownish_grey_seven),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        );
                                      }))
                            else
                              Expanded(
                                  child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  mErrorString.toString(),
                                  style: TextStyle(
                                      color: BrLottoPosColor.black_four
                                          .withOpacity(0.5)),
                                ).p(10),
                              )),
                          ],
                        ))
                      : Expanded(
                          child: Container(
                          alignment: Alignment.center,
                          child: Center(child: CircularProgressIndicator()),
                        ))
                ],
              )
            : _saleListLoading
                ? Container(
                alignment: Alignment.center,
                child: Center(child: CircularProgressIndicator()),
                  )
                : Container(
                alignment: Alignment.center,
                child: Text(
                  context.l10n.no_data_available,
                  style: TextStyle(
                      color: BrLottoPosColor.black_four.withOpacity(0.5)),
                ).p(10),
                  ));

    return BrLottoScaffold(
      showAppBar: true,
      appBarTitle: widget.title ?? context.l10n.sale_win_txn_report,
      body: body,
    );
  }

  initData(String fromDate, String toDate) {
    for (var element in _data) {
      if (element.serviceDisplayName == _selectedItem) {
        serviceCode = element.serviceCode!;
      }
    }
    BlocProvider.of<SelectDateBloc>(context).add(SetDate(fromDate: fromDate, toDate: toDate));
    BlocProvider.of<SaleWinBloc>(context).add(SaleWinTxnReport(
      context: context,
      serviceCode: serviceCode,
      startDate: fromDate,
      endDate: toDate,
    ));
  }

  String getDate(String? createdAt) {
    String fromDate = formatDate(
      date: createdAt!,
      inputFormat: Format.apiDateFormat,
      outputFormat: Format.dateFormat,
    );
    List<String> splitag = fromDate.split(",");
    String? splitag1 = splitag[0];
    return splitag1;
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
}
