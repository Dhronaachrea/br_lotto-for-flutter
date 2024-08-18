import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:br_lotto/home/models/response/UserMenuApiResponse.dart';
import 'package:br_lotto/l10n/l10n.dart';
import 'package:br_lotto/login/bloc/login_bloc.dart';
import 'package:br_lotto/login/bloc/login_event.dart';
import 'package:br_lotto/login/bloc/login_state.dart';
import 'package:br_lotto/login/models/response/GetLoginDataResponse.dart';
import 'package:br_lotto/utility/app_constant.dart';
import 'package:br_lotto/utility/auth_bloc/auth_bloc.dart';
import 'package:br_lotto/utility/br_lotto_pos_color.dart';
import 'package:br_lotto/utility/br_lotto_pos_screens.dart';
import 'package:br_lotto/utility/user_info.dart';
import 'package:br_lotto/utility/utils.dart';
import 'package:flutter_svg/svg.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../main.dart';

class BrLottoDrawer extends StatefulWidget {
  List<List<ModuleBeanLst>?> drawerModuleList;
  Function mCallBack;

  BrLottoDrawer({Key? key, required this.drawerModuleList, required this.mCallBack}) : super(key: key);

  @override
  State<BrLottoDrawer> createState() => _BrLottoDrawerState();
}

class _BrLottoDrawerState extends State<BrLottoDrawer>
    with TickerProviderStateMixin {
  late final AnimationController _refreshBtnAnimationController;
  late final AnimationController _refreshTextAnimationController;
  late final Animation<double> refreshBtnAnimation;
  late final Animation<double> refreshTextAnimation;
  BuildContext? dialogContext;
  bool isBalanceRefreshing = false;
  //bool isEnLang                             = true;
  late PackageInfo packageInfo;

  @override
  void dispose() {
    _refreshBtnAnimationController.dispose();
    _refreshTextAnimationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _refreshBtnAnimationController = AnimationController(
        duration: const Duration(milliseconds: 800), vsync: this);
    refreshBtnAnimation =
        Tween<double>(begin: 2, end: 1).animate(_refreshBtnAnimationController)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              _refreshBtnAnimationController.reset();
            } else if (status == AnimationStatus.dismissed) {
              _refreshBtnAnimationController.forward();
            }
          });

    _refreshTextAnimationController = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    refreshTextAnimation =
        Tween<double>(begin: 2, end: 1).animate(_refreshTextAnimationController)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              print("_refreshTextAnimationController");
            }
          });
  }

  @override
  Widget build(BuildContext context) {
    String selectedLang = BrLottoRetailApp.of(context).locale.languageCode;
    return WillPopScope(
      onWillPop: () async {
        return !isBalanceRefreshing;
      },
      child: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is GetLoginDataSuccess) {
            if (state.response != null) {
              //var dummyResponse = """{"responseCode":0,"responseMessage":"Success","responseData":{"message":"Success","statusCode":0,"data":{"lastName":"williams","userStatus":"ACTIVE","walletType":"PREPAID","mobileNumber":"8505957513","isHead":"YES","orgId":2,"accessSelfDomainOnly":"YES","balance":"70,00 ","qrCode":null,"orgCode":"ORGRET101test1111231","parentAgtOrgId":0,"parentMagtOrgId":0,"creditLimit":"0,00 ","userBalance":"-266 000,00 ","distributableLimit":"0,00 ","orgTypeCode":"RET","mobileCode":"+91","orgName":"ret_test_1011111231","userId":672,"isAffiliate":"NO","domainId":1,"walletMode":"COMMISSION","orgStatus":"ACTIVE","firstName":"ret","regionBinding":"REGION","rawUserBalance":-266000.0,"parentSagtOrgId":0,"username":"monuret"}}}""";
              //BlocProvider.of<AuthBloc>(context).add(UpdateUserInfo(loginDataResponse: GetLoginDataResponse.fromJson(jsonDecode(dummyResponse))));
              _refreshTextAnimationController.forward();
              print("UPDATED SUCCESSFULLY");
              BlocProvider.of<AuthBloc>(context)
                  .add(UpdateUserInfo(loginDataResponse: state.response!));
            }
          }
        },
        child: AbsorbPointer(
          absorbing: isBalanceRefreshing,
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is UserInfoUpdated) {
                setState(() {
                  isBalanceRefreshing = false;
                });
                _refreshBtnAnimationController.stop();
                Navigator.of(context).pop();
              }
            },
            builder: (context, state) {
              return SafeArea(
                bottom: false,
                left: false,
                right: false,
                child: Drawer(
                  width: context.screenWidth * 0.8,
                  child: Column(
                    children: [
                      SizedBox(
                        height: context.screenHeight * 0.22,
                        child: Stack(children: [
                          Container(
                            width: context.screenWidth * 0.8,
                            color: BrLottoPosColor.light_navy_blue,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 15.0,left: 15,right: 10,bottom:5 ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(top: 10),
                                    child: Image.asset(
                                        "assets/icons/icon_drawer_user.png",
                                        width: 70,
                                        height: 70),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: SizedBox(
                                      width:
                                          ((context.screenWidth * 0.8) - 120),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            UserInfo.userName,
                                            style: const TextStyle(
                                              color: BrLottoPosColor.white,
                                              fontSize: 20,
                                              fontFamily: noirFont,
                                              fontWeight: FontWeight.w500,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            maxLines: 1,
                                          ),
                                          _spacer(),
                                          Text(
                                            "${context.l10n.user_id_colon} ${UserInfo.userId}",
                                            style: const TextStyle(
                                              color: BrLottoPosColor.white,
                                              fontSize: 14,
                                              overflow: TextOverflow.ellipsis,
                                              fontFamily: noirFont,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            maxLines: 2,
                                          ),
                                          _spacer(),
                                          Builder(
                                            builder: (context) {
                                              return Text(
                                                "${context.l10n.organisation} : ${UserInfo.organisation}",
                                                style: const TextStyle(
                                                  color: BrLottoPosColor.white,
                                                  fontSize: 12,
                                                  fontFamily: noirFont,
                                                  fontWeight: FontWeight.w500,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                maxLines: 2,
                                              );
                                            }
                                          ),
                                          _spacer(),
                                          Center(
                                              child: Row(
                                            children: <Widget>[
                                              Container(
                                                  child: Flexible(
                                                child: RichText(
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  strutStyle: const StrutStyle(
                                                      fontSize: 16),
                                                  text: TextSpan(
                                                    style: const TextStyle(
                                                        fontFamily: noirFont,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: BrLottoPosColor
                                                            .golden_rod),
                                                    text:
                                                        "${context.l10n.balance_colon} ${getDefaultCurrency(getLanguage())}${UserInfo.totalBalance}",
                                                  ),
                                                ),
                                              )),
                                              InkWell(
                                                onTap: () {
                                                  print(
                                                      "---------------------");
                                                  _refreshBtnAnimationController
                                                      .forward();
                                                  showDialog(context);
                                                  setState(() {
                                                    isBalanceRefreshing = true;
                                                  });
                                                  BlocProvider.of<LoginBloc>(
                                                          context)
                                                      .add(GetLoginDataApi(
                                                          context: context));
                                                },
                                                customBorder:
                                                    RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                ),
                                                child: Ink(
                                                  child: RotationTransition(
                                                      turns:
                                                          refreshBtnAnimation,
                                                      child: SvgPicture.asset(
                                                        "assets/icons/icon_refresh.svg",
                                                        width: 25,
                                                        height: 25,
                                                        fit: BoxFit.contain,
                                                      )),
                                                ),
                                              ),
                                            ],
                                          )),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ]),
                      ),
                      const SizedBox(height: 15),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(
                              left: 10, right: 10, top: 0, bottom: 0),
                          child: ListView.separated(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.drawerModuleList[index]?[0]
                                                  .displayName !=
                                              null
                                          ? widget.drawerModuleList[index]![0]
                                              .displayName!
                                              .toString()
                                          : "",
                                      style: const TextStyle(
                                          color: BrLottoPosColor.black,
                                          fontFamily: bauhousFont,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15),
                                    ),
                                    SizedBox(
                                      width: context.screenWidth,
                                      height: ((widget
                                              .drawerModuleList[index]?[0]
                                              .menuBeanList
                                              ?.length)! *
                                          42),
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: ListView.builder(
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemBuilder: (context, index1) {
                                            return Material(
                                              child: InkWell(
                                                onTap: () {
                                                  _onClick(code : widget
                                                      .drawerModuleList[index]![
                                                          0]
                                                      .menuBeanList![index1]
                                                      .menuCode!,
                                                    title : widget
                                                      .drawerModuleList[
                                                  index]![0]
                                                      .menuBeanList![
                                                  index1]
                                                      .caption);
                                                },
                                                child: Container(
                                                  color: Colors.transparent,
                                                  child: Row(children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Image.asset(
                                                        "assets/icons/${_getImage(widget.drawerModuleList[index]![0].menuBeanList![index1].menuCode!)}",
                                                        width: 25,
                                                        height: 25,
                                                        fit: BoxFit.contain,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        widget
                                                                    .drawerModuleList[
                                                                        index]?[0]
                                                                    .menuBeanList?[
                                                                        0]
                                                                    .caption !=
                                                                null
                                                            ? widget
                                                                .drawerModuleList[
                                                                    index]![0]
                                                                .menuBeanList![
                                                                    index1]
                                                                .caption!
                                                            : "",
                                                        style: const TextStyle(
                                                            color: BrLottoPosColor
                                                                .gray,
                                                            fontSize: 14,
                                                            fontFamily: noirFont,
                                                            fontWeight: FontWeight
                                                                .normal),
                                                      ),
                                                    )
                                                  ]),
                                                ),
                                              ),
                                            );
                                          },
                                          itemCount: widget
                                              .drawerModuleList[index]?[0]
                                              .menuBeanList
                                              ?.length,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                              separatorBuilder: (context, index) {
                                return const Divider(
                                  color: BrLottoPosColor.black,
                                );
                              },
                              itemCount: widget.drawerModuleList.length),
                        ),
                      ),
                      SizedBox(
                        width: context.screenWidth * 0.8,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                          child: Column(
                            children: [
                              // Container(
                              //   width: double.infinity,
                              //   padding: const EdgeInsets.all(15),
                              //   margin: const EdgeInsets.all(20),
                              //   decoration:  BoxDecoration(
                              //     color: BrLottoPosColor.white,
                              //     border: Border.all(
                              //       width: 2,
                              //       color: BrLottoPosColor.medium_green,
                              //     ),
                              //     borderRadius: const BorderRadius.all(
                              //       Radius.circular(5),
                              //     ),
                              //
                              //   ),
                              //   child: const Text("LOGOUT",style: TextStyle(
                              //     fontSize: 20,
                              //     color: BrLottoPosColor.medium_green,
                              //     fontFamily: noirFont,
                              //     fontWeight: FontWeight.w500
                              //   ),
                              //    textAlign: TextAlign.center,),
                              // ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                      margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                                      child: FutureBuilder<void>(
                                          future: initPlatform(),
                                          builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                                            switch (snapshot.connectionState) {
                                              case ConnectionState.none:
                                                break;
                                              case ConnectionState.waiting:
                                                break;
                                              case ConnectionState.active:
                                                break;
                                              case ConnectionState.done:
                                                return Text("v ${packageInfo.version}", style: const TextStyle(fontWeight: FontWeight.bold)).p(16);
                                            }

                                            return const Text("");
                                          }),
                                  ).pOnly(left: 20),
                                  Align(
                                      alignment: Alignment.topRight,
                                      child: Container(
                                        width: 100,
                                        height: 25,
                                        decoration: BoxDecoration(
                                            color: BrLottoPosColor.white,
                                            border: Border.all(color: BrLottoPosColor.light_grey, width: 1),
                                            borderRadius: BorderRadius.circular(20)),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: InkWell(
                                                onTap: () {
                                                 setState(() {
                                                   BrLottoRetailApp.of(context)
                                                       .setLocale(const Locale('en', 'UK'));
                                                 });
                                                 Navigator.pushNamedAndRemoveUntil<dynamic>(
                                                   context,
                                                   BrLottoPosScreen.homeScreen,
                                                       (route) => false,//if you want to disable back feature set to false
                                                 );
                                                },
                                                child: Container(
                                                  height: 25,
                                                  decoration: BoxDecoration(
                                                      color: selectedLang == 'en'
                                                          ? BrLottoPosColor.shamrock_green
                                                          : BrLottoPosColor.white,
                                                      borderRadius: const BorderRadius.only(
                                                          topLeft: Radius.circular(20),
                                                          bottomLeft: Radius.circular(20))),
                                                  child: Center(
                                                    child: Text(
                                                      "En",
                                                      style: TextStyle(
                                                          color:  selectedLang == 'en'
                                                              ? BrLottoPosColor.white
                                                              : BrLottoPosColor.game_color_grey,
                                                          fontSize:  selectedLang == 'en' ? 14 : 10,
                                                          fontFamily: noirFont,
                                                          fontWeight: selectedLang == 'en'
                                                              ? FontWeight.w300
                                                              : null),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: 0.5,
                                              color: BrLottoPosColor.light_grey,
                                            ),
                                            Expanded(
                                              child: InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    BrLottoRetailApp.of(context)
                                                        .setLocale(const Locale('fr','FR'));
                                                  });
                                                  Navigator.pushNamedAndRemoveUntil<dynamic>(
                                                    context,
                                                    BrLottoPosScreen.homeScreen,
                                                        (route) => false,//if you want to disable back feature set to false
                                                  );
                                                },
                                                child: Container(
                                                  height: 25,
                                                  decoration: BoxDecoration(
                                                      color:  selectedLang == 'en'
                                                          ? BrLottoPosColor.white
                                                          : BrLottoPosColor.shamrock_green,
                                                      borderRadius: const BorderRadius.only(
                                                          topRight: Radius.circular(20),
                                                          bottomRight: Radius.circular(20))),
                                                  child: Center(
                                                    child: Text(
                                                      "Pt",
                                                      style: TextStyle(
                                                          color:  selectedLang == 'en'
                                                              ? BrLottoPosColor.game_color_grey
                                                              : BrLottoPosColor.white,
                                                          fontSize:  selectedLang == 'en' ? 10 : 14,
                                                          fontFamily: noirFont,
                                                          fontWeight:  selectedLang == 'en'
                                                              ? null
                                                              : FontWeight.w300),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ).pOnly(left: 10, right: 10)
                                  ).pOnly(right: 10),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  _spacer() {
    return const SizedBox(height: 5);
  }

  _getImage(String code) {
    if (code == PAYMENT_REPORT) {
      return "icon_drawer_payment_report.png";
    }
    if (code == OLA_REPORT) {
      return "icon_drawer_deposit_withdraw_report.png";
    }
    if (code == CHANGE_PASSWORD) {
      return "icon_drawer_change_password.png";
    }
    if (code == DEVICE_REGISTRATION) {
      return "icon_drawer_device_register.png";
    }
    if (code == LOGOUT) {
      return "icon_drawer_logout.png";
    }
    if (code == BILL_REPORT) {
      return "icon_drawer_invoice.png";
    }
    if (code == M_LEDGER) {
      return "icon_drawer_ledger_report.png";
    }
    if (code == USER_REGISTRATION) {
      return "icon_drawer_user_registration.png";
    }
    if (code == USER_SEARCH) {
      return "icon_drawer_search_user.png";
    }
    if (code == ACCOUNT_SETTLEMENT) {
      return "icon_drawer_account_settlement.png";
    }
    if (code == SETTLEMENT_REPORT) {
      return "icon_drawer_settlement_report.png";
    }
    if (code == SALE_WINNING_REPORT) {
      return "icon_drawer_sale_winning_report.png";
    }
    if (code == INTRA_ORG_CASH_MGMT) {
      return "icon_drawer_cash_management.png";
    }
    if (code == M_SUMMARIZE_LEDGER) {
      return "ledger.png";
    }
    if (code == COLLECTION_REPORT) {
      return "icon_drawer_ledger_report.png";
    }
    if (code == ALL_RETAILERS) {
      return "icon_drawer_search_user.png";
    }
    if (code == QR_CODE_REGISTRATION) {
      return "icon_qr.png";
    }
    if (code == NATIVE_DISPLAY_QR) {
      return "icon_qr.png";
    }
    if (code == BALANCE_REPORT) {
      return "balance.png";
    }
    if (code == OPERATIONAL_REPORT) {
      return "statistics.png";
    }
    if (code == "M_CHANGE_NETWORk") {
      return "icon_drawer_change_password.png";
    }
  }

  _onClick({required String code, required String? title}) {
    if (code == PAYMENT_REPORT) {
      Navigator.of(context).pop();
      Navigator.pushNamed(context, BrLottoPosScreen.paymentReportScreen, arguments: title).then((value) => widget.mCallBack());
    }
    if (code == OLA_REPORT) {
      Navigator.pop(context);
      Navigator.pushNamed(context, BrLottoPosScreen.depositWithdrawalScreen,arguments: title).then((value) => widget.mCallBack());
      // return "icon_drawer_deposit_withdraw_report.png";
    }
    if (code == CHANGE_PASSWORD) {
      Navigator.of(context).pop();
      Navigator.pushNamed(context, BrLottoPosScreen.changePin,arguments: title).then((value) => widget.mCallBack());
    }
    if (code == DEVICE_REGISTRATION) {
      return "icon_drawer_device_register.png";
    }
    if (code == LOGOUT) {
      UserInfo.logout();
      Navigator.of(context).pushNamedAndRemoveUntil(
          BrLottoPosScreen.loginScreen, (Route<dynamic> route) => false);
    }
    if (code == BILL_REPORT) {
      return "icon_drawer_invoice.png";
    }
    if (code == M_LEDGER) {
      Navigator.of(context).pop();
      Navigator.pushNamed(context, BrLottoPosScreen.ledgerReportScreen,arguments: title).then((value) => widget.mCallBack());
    }
    if (code == USER_REGISTRATION) {
      return "icon_drawer_user_registration.png";
    }
    if (code == USER_SEARCH) {
      return "icon_drawer_search_user.png";
    }
    if (code == ACCOUNT_SETTLEMENT) {
      return "icon_drawer_account_settlement.png";
    }
    if (code == SETTLEMENT_REPORT) {
      return "icon_drawer_settlement_report.png";
    }
    if (code == SALE_WINNING_REPORT) {
      Navigator.of(context).pop();

      Navigator.pushNamed(context, BrLottoPosScreen.saleWinTxn, arguments: title).then((value) => widget.mCallBack());
    }
    if (code == INTRA_ORG_CASH_MGMT) {
      return "icon_drawer_cash_management.png";
    }
    if (code == M_SUMMARIZE_LEDGER) {
      Navigator.of(context).pop();
      Navigator.pushNamed(context, BrLottoPosScreen.summarizeLedgerReport,arguments: title).then((value) => widget.mCallBack());
    }
    if (code == COLLECTION_REPORT) {
      return "icon_drawer_ledger_report.png";
    }
    if (code == ALL_RETAILERS) {
      return "icon_drawer_search_user.png";
    }
    if (code == QR_CODE_REGISTRATION) {
      return "icon_qr.png";
    }
    if (code == NATIVE_DISPLAY_QR) {
      return "icon_qr.png";
    }
    if (code == BALANCE_REPORT) {
      return "balance.png";
    }
    if (code == OPERATIONAL_REPORT) {
      return "statistics.png";
    }
    if (code == "M_CHANGE_NETWORk") {
      final MethodChannel _methodChannel =
          MethodChannel('com.skilrock.br_lotto/notification_panel_swipe');
      try {
        _methodChannel.invokeMethod('disableNotificationSwipe');
      } on PlatformException catch (e) {
        // Handle any platform exceptions
        print('Failed to disable notification panel swipe: ${e.message}');
      }
    }
  }

  showDialog(BuildContext context) {
    return showGeneralDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.transparent,
        pageBuilder: (BuildContext ctx, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return const Dialog(
            elevation: 0.0,
            insetPadding:
                EdgeInsets.symmetric(horizontal: 32.0, vertical: 200.0),
            backgroundColor: Colors.transparent,
            child: HeightBox(20),
          );
        });
  }

  Future<void> initPlatform() async {
    packageInfo = await PackageInfo.fromPlatform();
  }
}
