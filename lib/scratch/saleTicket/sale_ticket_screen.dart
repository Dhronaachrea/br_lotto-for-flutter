import 'dart:async';
import 'dart:developer';

import 'package:br_lotto/home/widget/br_lotto_scaffold.dart';
import 'package:br_lotto/l10n/l10n.dart';
import 'package:br_lotto/scratch/packOrder/bloc/pack_bloc.dart';
import 'package:br_lotto/scratch/pack_activation/model/game_list_response.dart';
import 'package:br_lotto/utility/app_constant.dart';
import 'package:br_lotto/utility/br_lotto_pos_color.dart';
import 'package:br_lotto/utility/widgets/alert_type.dart';
import 'package:br_lotto/utility/widgets/wls_pos_text_field_underline.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:scan/scan.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:br_lotto/home/models/response/UserMenuApiResponse.dart';
import 'package:br_lotto/scratch/saleTicket/bloc/sale_ticket_bloc.dart';
import 'package:br_lotto/scratch/saleTicket/bloc/sale_ticket_event.dart';
import 'package:br_lotto/scratch/saleTicket/bloc/sale_ticket_state.dart';
import 'package:br_lotto/utility/utils.dart';
import 'package:br_lotto/utility/widgets/alert_dialog.dart';
import 'package:br_lotto/utility/widgets/shake_animation.dart';

import '../../utility/widgets/scanner_error.dart';
import '../packOrder/bloc/pack_event.dart';
import '../packOrder/bloc/pack_state.dart';
import 'model/response/sale_ticket_response.dart';

class SaleTicketScreen extends StatefulWidget {
  MenuBeanList? scratchList;

  SaleTicketScreen({Key? key, required this.scratchList}) : super(key: key);

  @override
  State<SaleTicketScreen> createState() => _SaleTicketScreenState();
}

class _SaleTicketScreenState extends State<SaleTicketScreen> {

  TextEditingController barCodeController = TextEditingController();
  ShakeController barCodeShakeController = ShakeController();
  bool isGenerateOtpButtonPressed = false;
  final _loginForm = GlobalKey<FormState>();
  var autoValidate = AutovalidateMode.disabled;
  double mAnimatedButtonSize = 280.0;
  bool mButtonTextVisibility = true;
  ButtonShrinkStatus mButtonShrinkStatus = ButtonShrinkStatus.notStarted;

  //final ScanController _scanController = ScanController();
  final MobileScannerController _scanController =
  MobileScannerController(autoStart: true);
  var isLoading = false;


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BrLottoScaffold(
      resizeToAvoidBottomInset: false,
      showAppBar: true,
      // centerTitle: false,
      appBarTitle: widget.scratchList?.caption ?? context.l10n.sale_ticket,
      body: BlocListener<SaleTicketBloc, SaleTicketState>(
        listener: (context, state) {
          if (state is SaleTicketLoading) {
            setState(() {
              isLoading = true;
            });
          }
          if (state is SaleTicketSuccess) {
            SaleTicketResponse response = state.response;
            setState(() {
              isLoading = false;
            });
            Alert.show(
              type: AlertType.success,
              isDarkThemeOn: false,
              buttonClick: () {
                //_scanController.start();
                Navigator.of(context).pop();
              },
              title: context.l10n.success,
              subtitle: ((response.responseCode) == 1000)
                  ? context.l10n.book_is_marked_as_sold
                  : state.response.responseMessage!,
              otherData: response.saleTicketDetails != null
                  ? Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //gameName
                  Opacity(
                    opacity: 0.5,
                    child: Text(context.l10n.name,
                        style: const TextStyle(
                            color: BrLottoPosColor.brownish_grey_three,
                            fontWeight: FontWeight.w500,
                            fontFamily: "",
                            fontStyle: FontStyle.normal,
                            fontSize: 14.0),
                        textAlign: TextAlign.left),
                  ),
                  const HeightBox(2.0),
                  Text(state.response.saleTicketDetails![0].gameName!,
                      style: const TextStyle(
                          color: BrLottoPosColor.brownish_grey_three,
                          fontWeight: FontWeight.w500,
                          fontFamily: "",
                          fontStyle: FontStyle.normal,
                          fontSize: 14.0),
                      textAlign: TextAlign.left),
                  const HeightBox(5),
                  //Ticket Price
                  Opacity(
                    opacity: 0.5,
                    child: Text(context.l10n.ticket_price,
                        style: const TextStyle(
                            color: BrLottoPosColor.brownish_grey_three,
                            fontWeight: FontWeight.w500,
                            fontFamily: "",
                            fontStyle: FontStyle.normal,
                            fontSize: 14.0),
                        textAlign: TextAlign.left),
                  ),
                  const HeightBox(2),
                  Text(
                      response.saleTicketDetails![0].ticketPrice
                          .toString(),
                      style: const TextStyle(
                          color: BrLottoPosColor.brownish_grey_three,
                          fontWeight: FontWeight.w500,
                          fontFamily: "",
                          fontStyle: FontStyle.normal,
                          fontSize: 14.0),
                      textAlign: TextAlign.left),
                  const HeightBox(5),
                  //Ticket number
                  response.saleTicketDetails![0].ticketNumbers != null &&
                      response.saleTicketDetails![0].ticketNumbers!
                          .isNotEmpty
                      ? Opacity(
                    opacity: 0.5,
                    child: Text(context.l10n.ticket_number,
                        style: const TextStyle(
                            color:
                            BrLottoPosColor.brownish_grey_three,
                            fontWeight: FontWeight.w500,
                            fontFamily: "",
                            fontStyle: FontStyle.normal,
                            fontSize: 14.0),
                        textAlign: TextAlign.left),
                  )
                      : Container(),
                  const HeightBox(2),
                  Text(
                      state.response.saleTicketDetails![0]
                          .ticketNumbers![0],
                      style: const TextStyle(
                          color: BrLottoPosColor.brownish_grey_three,
                          fontWeight: FontWeight.w500,
                          fontFamily: "",
                          fontStyle: FontStyle.normal,
                          fontSize: 14.0),
                      textAlign: TextAlign.left),
                  const HeightBox(5),
                ],
              )
                  : Container(),
              buttonText: context.l10n.ok.toUpperCase(),
              context: context,
            );
          }
          if (state is SaleTicketError) {
            setState(() {
              isLoading = false;
              mAnimatedButtonSize = 280.0;
              mButtonTextVisibility = true;
              mButtonShrinkStatus = ButtonShrinkStatus.over;
              barCodeController.clear();
            });
            // Navigator.of(context).pop();
            Alert.show(
              type: AlertType.error,
              isDarkThemeOn: false,
              buttonClick: () {
                _scanController.start();
              },
              title: context.l10n.error,
              subtitle: state.errorMessage,
              buttonText: context.l10n.ok.toUpperCase(),
              context: context,
            );
          }
        },
        child: BlocListener<PackBloc, PackState>(
          listener: (context, state) {
            if (state is PackLoading) {
              setState(() {
                isLoading = true;
              });
            } else if (state is GameListSuccess) {
              GameListResponse response = state.response;
              String trimmedTicketNumber = barCodeController.text.trim();
              String ticketNumber = trimmedTicketNumber;
              String? formattedTicketNum;
              if (response.games != null && response.games!.isNotEmpty) {
                List<Games>? games = response.games
                    ?.where((element) =>
                ((element.gameNumber.toString()) ==
                    (trimmedTicketNumber.substring(0, 3))))
                    .toList();
                if (games != null && games.isNotEmpty) {
                  Games game = games[0];
                  int gameNumberDigits = game.gameNumber
                      .toString()
                      .length;
                  int packAndBookNumberDigit =
                      game.packNumberDigits + game.bookNumberDigits;
                  formattedTicketNum =
                  "${ticketNumber.substring(0, gameNumberDigits)}-${ticketNumber
                      .substring(gameNumberDigits, (gameNumberDigits +
                      packAndBookNumberDigit))}"
                      // "-${ticketNumber.substring(
                      // (gameNumberDigits + packAndBookNumberDigit),
                      // ticketNumber.length)}"
                      "";
                }
              }

              BlocProvider.of<SaleTicketBloc>(context).add(SaleTicketApi(
                  context: context,
                  scratchList: widget.scratchList,
                  barCodeText: formattedTicketNum ?? ticketNumber));
            } else if (state is PackError) {
              setState(() {
                isLoading = false;
                mAnimatedButtonSize = 280.0;
                mButtonTextVisibility = true;
                mButtonShrinkStatus = ButtonShrinkStatus.over;
                barCodeController.clear();
              });
              Alert.show(
                type: AlertType.error,
                isDarkThemeOn: false,
                buttonClick: () {
                  _scanController.start();
                },
                title: 'Error!',
                subtitle: state.errorMessage,
                buttonText: 'ok'.toUpperCase(),
                context: context,
              );
            }
          },
          child: SingleChildScrollView(
            child: Form(
              key: _loginForm,
              autovalidateMode: autoValidate,
              child: Column(
                children: <Widget>[
                  barCodeTextField(),
                  SizedBox(
                    height: 400,
                    child: MobileScanner(
                      errorBuilder: (context, error, child) {
                        return ScannerError(
                          context: context,
                          error: error,
                        );
                      },
                      controller: _scanController,
                      onDetect: (capture) {
                        try {
                          final List<Barcode> barcodes = capture.barcodes;
                          String? data = barcodes[0].rawValue;
                          if (data != null) {
                            setState(() {
                              barCodeController.text = data;
                            });
                          }
                        } catch (e) {
                          print("Something went wrong with bar code: $e");
                        }
                      },
                    ),

                    // ScanView(
                    //   controller: _scanController,
                    //   scanAreaScale: .7,
                    //   scanLineColor: BrLottoPosColor.tomato,
                    //   onCapture: (data) {
                    //     setState(() {
                    //       barCodeController.text = data;
                    //     });
                    //     // BlocProvider.of<QrScanBloc>(context).add(GetQrScanDataApi(context: context));
                    //   },
                    // ),
                  ),
                  _submitButton()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  barCodeTextField() {
    return ShakeWidget(
        controller: barCodeShakeController,
        child: WlsPosTextFieldUnderline(
          maxLength: 10,
          inputType: TextInputType.number,
          hintText: context.l10n.book_number ?? "Book Number",
          inputFormatters: [
            // FilteringTextInputFormatter.allow(RegExp('[0-9-]+')),
            maskFormatter
          ],
          controller: barCodeController,
          underLineType: false,
          validator: (value) {
            if (validateInput(TotalTextFields.userName).isNotEmpty) {
              if (isGenerateOtpButtonPressed) {
                barCodeShakeController.shake();
              }
              return validateInput(TotalTextFields.userName);
            } else {
              return null;
            }
          },
        ).p20());
  }

  String validateInput(TotalTextFields textField) {
    switch (textField) {
      case TotalTextFields.userName:
        var mobText = barCodeController.text.trim();
        if (mobText.isEmpty) {
          return context.l10n.please_enter_book_number;
        }
        break;
      case TotalTextFields.password:
      // TODO: Handle this case.
        break;
    }
    return "";
  }

  _submitButton() {
    return InkWell(
      onTap: () {
        setState(() {
          isGenerateOtpButtonPressed = true;
        });
        Timer(const Duration(milliseconds: 500), () {
          setState(() {
            isGenerateOtpButtonPressed = false;
          });
        });
        if (_loginForm.currentState!.validate()) {
          var userName = barCodeController.text.trim();
          setState(() {
            mAnimatedButtonSize = 50.0;
            mButtonTextVisibility = false;
            mButtonShrinkStatus = ButtonShrinkStatus.notStarted;
          });
          if (barCodeController.text.trim().contains('-')) {
            BlocProvider.of<SaleTicketBloc>(context).add(SaleTicketApi(
                context: context,
                scratchList: widget.scratchList,
                barCodeText: barCodeController.text));
          } else {
            BlocProvider.of<PackBloc>(context).add(
                GameListApi(context: context, scratchList: widget.scratchList));
          }
        } else {
          setState(() {
            autoValidate = AutovalidateMode.onUserInteraction;
          });
        }
      },
      child: Container(
          decoration: BoxDecoration(
              color: BrLottoPosColor.medium_green,
              borderRadius: BorderRadius.circular(buttonBorder)),
          child: AnimatedContainer(
            width: mAnimatedButtonSize,
            height: 50,
            onEnd: () {
              setState(() {
                if (mButtonShrinkStatus != ButtonShrinkStatus.over) {
                  mButtonShrinkStatus = ButtonShrinkStatus.started;
                } else {
                  mButtonShrinkStatus = ButtonShrinkStatus.notStarted;
                }
              });
            },
            curve: Curves.easeIn,
            duration: const Duration(milliseconds: 200),
            child: SizedBox(
                width: mAnimatedButtonSize,
                height: 50,
                child: mButtonShrinkStatus == ButtonShrinkStatus.started
                    ? const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(
                      color: BrLottoPosColor.white_two),
                )
                    : Center(
                    child: Visibility(
                      visible: mButtonTextVisibility,
                      child: Text(
                        context.l10n.proceed,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: BrLottoPosColor.white,
                        ),
                      ),
                    ))),
          )).pOnly(top: 30),
    );
  }
}
