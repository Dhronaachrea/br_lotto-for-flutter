import 'dart:convert';
import 'dart:developer';

import 'package:br_lotto/home/drawer/br_lotto_drawer.dart';
import 'package:br_lotto/l10n/l10n.dart';
import 'package:br_lotto/utility/br_lotto_pos_screens.dart';
import 'package:br_lotto/utility/user_info.dart';
import 'package:br_lotto/utility/widgets/shimmer_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:br_lotto/home/bloc/home_state.dart';
import 'package:br_lotto/home/models/homeDataListBean.dart';
import 'package:br_lotto/home/widget/br_lotto_scaffold.dart';
import 'package:br_lotto/utility/app_constant.dart';
import 'package:br_lotto/utility/auth_bloc/auth_bloc.dart';
import 'package:br_lotto/utility/br_lotto_pos_color.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:marqueer/marqueer.dart';
import 'package:shimmer/shimmer.dart';
import 'package:velocity_x/velocity_x.dart';
import '../login/models/response/GetLoginDataResponse.dart';
import '../utility/shared_pref.dart';
import '../utility/widgets/show_snackbar.dart';
import 'bloc/home_bloc.dart';
import 'bloc/home_event.dart';
import 'models/response/UserMenuApiResponse.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
//SingleTickerProviderStateMixin,
class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  bool _mIsDrawerVisible = false;
  bool _mAppBarBalanceChipVisible = false;
  List<List<ModuleBeanLst>?> homeModuleList = [];
  List<HomeDataListBean> homeDataModuleList   = [];
  List<List<ModuleBeanLst>?> drawerModuleList = [];
  List<MenuBeanList>? scratchList = [];
  double animationWidth = 1.0;
  double animationHeight = 0.05;
  BorderRadiusGeometry _borderRadius = BorderRadius.circular(0);
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
  );
  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: Offset.zero,
    end: const Offset(0.0, 1.5),
  ).animate(CurvedAnimation(
    parent: _controller,
    curve: Curves.fastOutSlowIn,
  ));
  // String saleBlockDate = "29/07/2023";
  late var dateDifference;
  bool isResetStripAnimation = false;
  GetLoginDataResponse? userInfo;
  int? dateDiffInMin;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //checkSessionWasExpired(context);
    });
    userInfo = GetLoginDataResponse.fromJson(jsonDecode(UserInfo.getUserInfo));
    if (userInfo?.responseData?.data?.saleBlockDate != null) {
      final saleDate = DateFormat('dd/MM/yyyy').parse(userInfo?.responseData?.data?.saleBlockDate ?? "");
      log("saleDate: $saleDate");
      final currentDate = DateTime.now();
      log("currentDate: $currentDate");
      dateDifference = saleDate.difference(currentDate).inDays;
      log("dateDifference: $dateDifference");
      dateDiffInMin = saleDate.difference(currentDate).inMinutes;
      log("dateDiffInMin: $dateDiffInMin");
    }

    // for testing using dummy data
    /*final saleDate = DateFormat('dd/MM/yyyy').parse(saleBlockDate);
    final currentDate = DateTime.now();
    dateDifference = saleDate.difference(currentDate).inDays;
    log("dateDifference: $dateDifference");
    dateDiffInMin = saleDate.difference(currentDate).inMinutes;
    log("dateDiffInMin: $dateDiffInMin"); */

    BlocProvider.of<HomeBloc>(context).add(GetConfigData(context: context));
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: BrLottoScaffold(
        showAppBar: true,
        showDrawerIcon: _mIsDrawerVisible,
        mAppBarBalanceChipVisible: _mAppBarBalanceChipVisible,
        extendBodyBehindAppBar: true,
        drawerEnableOpenDragGesture: _mIsDrawerVisible,
        isHomeScreen: true,
        drawer: BrLottoDrawer(drawerModuleList: drawerModuleList, mCallBack: () {
          setState((){
            _controller.reset();
            _borderRadius = BorderRadius.circular(0);
            animationWidth = 1.0;
            animationHeight = 0.05;
          });
        },),
        body: BlocListener<HomeBloc, HomeState>(
          listener: (context, state) {
            if (state is UserMenuListLoading) {
              setState(() {
                homeDataModuleList.clear();
                _mIsDrawerVisible = false;
              });
            }
            else if (state is UserMenuListSuccess) {
              setState(() {
                for (var moduleCodeVar in homeModuleCodesList) {
                  if (state.response.responseData?.moduleBeanLst?.where((element) => (element.moduleCode == moduleCodeVar)) != null) {
                    if(state.response.responseData?.moduleBeanLst?.where((element) => (element.moduleCode == moduleCodeVar)).toList().isNotEmpty == true) {
                      homeModuleList.add(state
                          .response.responseData?.moduleBeanLst
                          ?.where(
                              (element) => (element.moduleCode == moduleCodeVar))
                          .toList());
                    }
                  }
                }
                if(homeModuleList.isNotEmpty){
                  scratchList = homeModuleList[0]?[0].menuBeanList;
                }
                for (var moduleCodeVar in drawerModuleCodesList) {
                  if (state.response.responseData?.moduleBeanLst?.where(
                          (element) =>
                      (element.moduleCode == moduleCodeVar)) !=
                      null) {
                    drawerModuleList.add(state
                        .response.responseData?.moduleBeanLst
                        ?.where((element) =>
                    (element.moduleCode == moduleCodeVar)==true)
                        .toList());
                  }
                }

                if (drawerModuleList.isNotEmpty) {
                  _mIsDrawerVisible = true;
                } else {
                  _mIsDrawerVisible = false;
                }
              });
            }
            else if (state is UserMenuListError) {
              setState(() {
                _mIsDrawerVisible = false;
              });
              ShowToast.showToast(context, state.errorMessage.toString(), type: ToastType.ERROR);
              Future.delayed(const Duration(seconds: 2), () {
                UserInfo.logout();
                Navigator.of(context).pushNamedAndRemoveUntil(
                    BrLottoPosScreen.loginScreen, (Route<dynamic> route) => false);
              });
            }
            else if (state is UserConfigSuccess) {
              if (state.response.responseData?.data?[0].cURRENCYLIST !=
                  null) {
                SharedPrefUtils.setCurrencyListConfig =
                    state.response.responseData?.data?[0].cURRENCYLIST! ?? "";

              }
              SharedPrefUtils.setAliasName =
                  state.response.responseData?.data?[0].SCAN_N_PLAY_ALIAS_NAME ?? "";
              BlocProvider.of<AuthBloc>(context).add(AppStarted());
              setState(() {
                _mAppBarBalanceChipVisible = true;
              });
              if(state.response.responseData?.statusCode == 0) {
                BlocProvider.of<HomeBloc>(context).add(GetUserMenuListApiData(context: context));
              }
            } else if (state is UserConfigError) {
              ShowToast.showToast(context, state.errorMessage.toString(), type: ToastType.ERROR);

            }

            else if (state is GetLoginDataSuccess) {
              setState(() {

              });
            } else if ( state is GetLoginDataError) {
              ShowToast.showToast(context, state.errorMessage.toString(), type: ToastType.ERROR);
            }


          },
          child: Stack(
            children: [
              Image.asset("assets/images/login_header.png"),
              RefreshIndicator(
                triggerMode: RefreshIndicatorTriggerMode.anywhere,
                color: BrLottoPosColor.app_blue,
                displacement: 60,
                edgeOffset: 1,
                strokeWidth: 2,
                onRefresh: () {
                  setState(() {
                    _mIsDrawerVisible = false;
                    homeDataModuleList.clear();
                    homeModuleList.clear();
                    drawerModuleList.clear();
                  });
                  return Future.delayed(
                    const Duration(seconds: 1),
                        () {

                        BlocProvider.of<HomeBloc>(context)
                            .add(GetLoginDataApi(context: context));

                        BlocProvider.of<HomeBloc>(context)
                          .add(GetUserMenuListApiData(context: context));

                    },
                  );
                },
                child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 0.8,
                      crossAxisCount: 2,
                    ),
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: _mIsDrawerVisible ? scratchList?.length : 10,
                    itemBuilder: (BuildContext context, int index) {
                      return _mIsDrawerVisible
                          ? InkWell(
                        onTap: () {
                          moveToNextScreen(scratchList![index]);
                    /*      if ((scratchList![index].menuCode == "SCRATCH_WIN_CLAIM")) {
                            if ( dateDiffInMin == null || dateDiffInMin! > 0) {
                              moveToNextScreen(scratchList![index]);
                            }
                          } else {
                            moveToNextScreen(scratchList![index]);
                          }*/
                        },
                        customBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: BrLottoPosColor.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: BrLottoPosColor.warm_grey_six,
                                blurRadius: 2.0,
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                  "assets/scratch/${scratchList?[index].menuCode}.svg",
                                  width: 50,
                                  height: 50,
                                  // colorFilter: const ColorFilter.mode(Colors.red, BlendMode.srcIn),
                                  semanticsLabel: 'A red up arrow'
                              ).p8(),
                              // Image.asset(
                              //   width: 100,
                              //   height: 100,
                              //   "assets/scratch/${scratchList?[index].caption}.png",
                              //   // errorBuilder: (context, object, stackTrace) {
                              //   //   return Image.asset(
                              //   //       width: 100,
                              //   //       height: 100,
                              //   //       "assets/icons/icon_confirmation.png");
                              //   // },
                              //   // homeModuleCodesList.contains(homeModuleList[index]?[0].moduleCode)
                              //   //     ? "assets/icons/${homeModuleList[index]?[0].moduleCode}.png"
                              //   // imageUrls[index]
                              // ).p8(),
                              // Text(homeModuleList[index]?[0].displayName ?? "NA", style: const TextStyle(color: WlsPosColor.black, fontWeight: FontWeight.bold))
                              Container(
                                width: 40,
                                height: 1,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: BrLottoPosColor.brownish_grey,
                                    width: 1,
                                  ),
                                ),
                              ).pSymmetric(v: 4),
                              Text(scratchList?[index].caption == "Ticket Validation & Claim"? "Ticket Validation" : scratchList?[index].caption ?? "NA",
                                style:  const TextStyle(
                                  color:  BrLottoPosColor.brownish_grey_three,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "",
                                  fontStyle:  FontStyle.normal,
                                  fontSize: 15.0,
                                ),
                                textAlign: TextAlign.center,
                              ).p(8),
                            ],
                          ),
                        ),
                      ).p(6)
                          : Shimmer.fromColors(
                        baseColor: Colors.grey[400]!,
                        highlightColor: Colors.grey[300]!,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey[400]!,
                                blurRadius: 1.0,
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                    color: Colors.grey[400]!,
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(10),
                                    )),
                              ).pOnly(bottom: 10),
                              Container(
                                width: 80,
                                height: 10,
                                decoration: BoxDecoration(
                                    color: Colors.grey[400]!,
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(10),
                                    )),
                              ),
                            ],
                          ),
                        ).p(6),
                      );
                    }).p(10),
              ),
              (UserInfo.getSaleBlockDate != "")
                ? SlideTransition(
                position: _offsetAnimation,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 800),
                    width: MediaQuery.of(context).size.width * animationWidth, // 1 --> 0.079
                    height: MediaQuery.of(context).size.height * animationHeight, // 0.05 -- > 0.04
                    decoration: BoxDecoration(
                        color: dateDifference > 0 ? Colors.lightBlueAccent : BrLottoPosColor.game_color_red,
                        borderRadius: _borderRadius,
                    ),
                    curve: Curves.fastOutSlowIn,
                    onEnd: () {
                      // _controller.repeat(reverse: false);
                      setState(() {
                        if (!isResetStripAnimation) {
                          isResetStripAnimation = true;
                          _controller.forward();
                        } else {
                          isResetStripAnimation = false;
                        }
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Center(
                            child: Marqueer(
                              pps: 50,
                              direction: MarqueerDirection.rtl,
                              restartAfterInteractionDuration: const Duration(seconds: 1),
                              restartAfterInteraction: false,
                              child: Center(
                                  child: (dateDifference <= 0 )
                                      ? TextShimmer(
                                      //text:'      Bill No. - ${userInfo?.responseData?.data?.billNumber ?? ""} (${userInfo?.responseData?.data?.billAmount ?? "0"}) is overdue for payment, Sale will impacted by ${userInfo?.responseData?.data?.saleBlockDate ?? ""}. Please pay immediately.',

                                      text:'      ${context.l10n.bill_no} ${userInfo?.responseData?.data?.billNumber ?? ""} (${userInfo?.responseData?.data?.billAmount ?? "0"}) ${context.l10n.is_overdue_for_payment}, ${context.l10n.sale_will_impacted_by} ${userInfo?.responseData?.data?.saleBlockDate ?? ""}. ${context.l10n.please_pay_immediately}.',
                                          color: BrLottoPosColor.red,
                                          size: 15
                                        )
                                      : Text(
                                    //      "      Bill No. - ${userInfo?.responseData?.data?.billNumber ?? ""} (${userInfo?.responseData?.data?.billAmount ?? "0"}) has been generated and payment due date is ${userInfo?.responseData?.data?.saleBlockDate ?? ""}.",
                                            "       ${context.l10n.bill_no} ${userInfo?.responseData?.data?.billNumber ?? ""} (${userInfo?.responseData?.data?.billAmount ?? "0"}) ${context.l10n.has_been_generated_and_payment_due_date_is} ${userInfo?.responseData?.data?.saleBlockDate ?? ""}.",
                                            style: const TextStyle(
                                              fontSize: 15,
                                              color: BrLottoPosColor.white,
                                            )
                                        )
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState((){
                              _borderRadius = BorderRadius.circular(20);
                              animationWidth = 0.079;
                              animationHeight = 0.04;
                              //UserInfo.setSaleBlockDate("");
                            });
                          },
                          child: (dateDifference <= 0 )
                              ? const SizedBox(
                                  width: 30,
                                  height: 30,
                                  child: Icon(
                                    Icons.cancel,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                )
                              : Stack(
                            children: [
                              Positioned(
                                top:0,
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Center(
                                  child: Container(
                                    width: 10,
                                    height: 10,
                                    decoration: BoxDecoration(color: Colors.red,
                                        borderRadius: BorderRadius.circular(20)
                                    )
                                  ),
                                ),
                              ),
                              const Center(
                                child:  Icon(
                                  Icons.cancel,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ],
                          ).p(10),
                        )
                      ],
                    ),
                  ),
                ),
              )
                : Container()
            ],
          ).pOnly(top: 80),
        ),
      ),
    );
  }

  void moveToNextScreen(MenuBeanList? menuBeanList) {
    print("Screen Open--------------->${menuBeanList?.menuCode}");
    String screenName;
    switch (menuBeanList?.menuCode) {
      case "SCRATCH_SALE":
        screenName = BrLottoPosScreen.saleTicketScreen;
        break;
      case "SCRATCH_WIN_CLAIM":
        screenName = BrLottoPosScreen.ticketValidationAndClaimScreen;
        break;
      case "SCRATCH_ORDER_BOOK":
        screenName = BrLottoPosScreen.packOrderScreen;
        break;
      case "SCRATCH_RECEIVE_BOOK":
        screenName = BrLottoPosScreen.packReceiveScreen;
        break;
      case "M_SCRATCH_INV_REPORT":
        screenName = BrLottoPosScreen.inventoryReportScreen;
        break;
      case "SCRATCH_ACTIVATE_BOOK":
        screenName = BrLottoPosScreen.packActivationScreen;
        break;
      case "SCRATCH_RETURN_BOOK":
        screenName = BrLottoPosScreen.packReturnScreen;
        break;
      case "M_SCRATCH_INV_SUMMARY_REPORT":
        screenName = BrLottoPosScreen.inventoryFlowReportScreen;
        break;
      default:
        screenName = BrLottoPosScreen.qrScanScreen;
    }
    Navigator.pushNamed(context, screenName, arguments: menuBeanList).then((value) =>
      setState((){
        _controller.reset();
        _borderRadius = BorderRadius.circular(0);
        animationWidth = 1.0;
        animationHeight = 0.05;
      })
    );
  }

  /*void checkSessionWasExpired(BuildContext context) {
    print("UserInfo.getSelectedPanelData: ${UserInfo.getSelectedPanelData}");
    if (UserInfo.getSelectedPanelData.isNotEmpty && UserInfo.getSelectedGameObject.isNotEmpty) {
      SavedPanelDataConfirmationDialog().show(context: context, title: "Your picked data are waiting !", subTitle: "You may not purchase those picked data, It's time to purchase it", buttonText: "Preview", isCloseButton: true, buttonClick: (bool isPreviewSelected) {
        if (isPreviewSelected) {
          var jsonPanelData = jsonDecode(UserInfo.getSelectedPanelData) as Map<String, dynamic>;
          print("jsonPanelData: $jsonPanelData");
          List<PanelBean> panelData = createPanelData(jsonPanelData["panelData"]);
          GameRespVOs gameRespObject = GameRespVOs.fromJson(jsonDecode(UserInfo.getSelectedGameObject));
          Navigator.push(context,
              MaterialPageRoute(
                builder: (_) =>  MultiBlocProvider(
                    providers: [
                      BlocProvider<LotteryBloc>(
                        create: (BuildContext context) => LotteryBloc(),
                      )
                    ],
                    child: PreviewGameScreen(gameSelectedDetails: panelData, gameObjectsList: gameRespObject, onComingToPreviousScreen: (String onComingToPreviousScreen) {
                      switch(onComingToPreviousScreen) {
                        case "isAllPreviewDataDeleted" : {
                          break;
                        }

                        case "isBuyPerformed" : {
                          SharedPrefUtils.removeValue(PrefType.appPref.value);
                          break;
                        }
                      }
                    }, selectedGamesData: (List<PanelBean> selectedAllGameData) {

                    })),
                //child: LotteryScreen()),
              )
          );
        } else {
          SharedPrefUtils.removeValue(PrefType.appPref.value);
        }
      });
    }

  }*/

  /*List<PanelBean> createPanelData(List<dynamic> panelSavedDataList) {
    List<PanelBean> savedPanelBeanList = [];
    for (int i=0; i< panelSavedDataList.length; i++) {
      PanelBean model = PanelBean();

      model.gameName                          = panelSavedDataList[i]["gameName"];
      model.amount                            = panelSavedDataList[i]["amount"];
      model.winMode                           = panelSavedDataList[i]["winMode"];
      model.betName                           = panelSavedDataList[i]["betName"];
      model.pickName                          = panelSavedDataList[i]["pickName"];
      model.betCode                           = panelSavedDataList[i]["betCode"];
      model.pickCode                          = panelSavedDataList[i]["pickCode"];
      model.pickConfig                        = panelSavedDataList[i]["PickConfig"];
      model.isPowerBallPlus                   = panelSavedDataList[i]["isPowerBallPlus"];
      model.selectBetAmount                   = panelSavedDataList[i]["selectBetAmount"];
      model.unitPrice                         = panelSavedDataList[i]["unitPrice"];
      model.numberOfDraws                     = panelSavedDataList[i]["numberOfDraws"];
      model.numberOfLines                     = panelSavedDataList[i]["numberOfLines"];
      model.isMainBet                         = panelSavedDataList[i]["isMainBet"];
      model.betAmountMultiple                 = panelSavedDataList[i]["betAmountMultiple"];
      model.isQuickPick                       = panelSavedDataList[i]["isQuickPick"];
      model.isQpPreGenerated                  = panelSavedDataList[i]["isQpPreGenerated"];

      List<Map<String, List<String>>> listOfSelectedNumber = [];
      if (panelSavedDataList[i]["listSelectedNumber"] != null) {
        Map<String, dynamic> mapOfSelectedNumbers = panelSavedDataList[i]["listSelectedNumber"][0]; // For Eg. {0: [40, 29, 26, 03, 31], 1: [03]}
        Map<String, List<String>> selectedNumbers = {};
        for(var i=0;i<mapOfSelectedNumbers.length; i++) {
          List<String> numberList = List<String>.from(mapOfSelectedNumbers.values.toList()[i] as List);
          selectedNumbers[mapOfSelectedNumbers.keys.toList()[i]] = numberList;
        }

        listOfSelectedNumber.add(selectedNumbers);
        print("listOfSelectedNumber --> $listOfSelectedNumber");
      }

      List<Map<String, List<BankerBean>>> listSelectedNumberUpperLowerLine = [];
      if (panelSavedDataList[i]["listSelectedNumberUpperLowerLine"] != null) {
        Map<String, dynamic> mapOfBankerSelectedNumbers = panelSavedDataList[i]["listSelectedNumberUpperLowerLine"][0]; // For Eg. {0: [40, 29, 26, 03, 31], 1: [03]}
        Map<String, List<BankerBean>> bankersSelectedNumber = {};
        for(var i=0;i<mapOfBankerSelectedNumbers.length; i++) {
          List<BankerBean> bankerBeanList = [];
          for (var bankerDetails in mapOfBankerSelectedNumbers.values.toList()[i]) {
            bankerBeanList.add(BankerBean(number: bankerDetails["number"], color: bankerDetails["number"], index: int.parse(bankerDetails["number"]), isSelectedInUpperLine: bankerDetails["isSelected"]));
          }
          bankersSelectedNumber[mapOfBankerSelectedNumbers.keys.toList()[i]] = bankerBeanList;
        }

        listSelectedNumberUpperLowerLine.add(bankersSelectedNumber);
        print("listSelectedNumberUpperLowerLine |>--> $listSelectedNumberUpperLowerLine");
      }

      model.listSelectedNumber                = listOfSelectedNumber.isEmpty ? null : listOfSelectedNumber;
      model.listSelectedNumberUpperLowerLine  = listSelectedNumberUpperLowerLine.isEmpty ? null : listSelectedNumberUpperLowerLine;
      model.pickedValue                       = panelSavedDataList[i]["pickedValue"];
      model.colorCode                         = panelSavedDataList[i]["colorCode"];
      model.totalNumber                       = panelSavedDataList[i]["totalNumber"];
      model.sideBetHeader                     = panelSavedDataList[i]["sideBetHeader"];

      savedPanelBeanList.add(model);
    }
    print("---------> all panelSavedData: $savedPanelBeanList");
    print("---------> all panelSavedData: json --> ${jsonEncode(savedPanelBeanList)}");

    return savedPanelBeanList;
  }*/

}
