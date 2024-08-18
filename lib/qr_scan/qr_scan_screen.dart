import 'dart:async';
import 'package:br_lotto/home/widget/br_lotto_scaffold.dart';
import 'package:br_lotto/l10n/l10n.dart';
import 'package:br_lotto/utility/br_lotto_pos_color.dart';
import 'package:br_lotto/utility/widgets/wls_pos_text_field_underline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scan/scan.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:br_lotto/qr_scan/bloc/models/response/qrScanApiResponse.dart';
import 'package:br_lotto/qr_scan/bloc/qr_scan_bloc.dart';
import 'package:br_lotto/qr_scan/bloc/qr_scan_event.dart';
import 'package:br_lotto/qr_scan/bloc/qr_scan_state.dart';
import 'package:br_lotto/utility/utils.dart';
import 'package:br_lotto/utility/widgets/alert_dialog.dart';
import 'package:br_lotto/utility/widgets/alert_type.dart';
import 'package:br_lotto/utility/widgets/shake_animation.dart';

class QrScanScreen extends StatefulWidget {
  String titleName;

  QrScanScreen({Key? key, required this.titleName}) : super(key: key);

  @override
  _QrScanScreenState createState() => _QrScanScreenState();
}

class _QrScanScreenState extends State<QrScanScreen> {
  var isLoading = false;

  TextEditingController barCodeController = TextEditingController();
  ShakeController barCodeShakeController = ShakeController();
  bool isGenerateOtpButtonPressed = false;
  final _loginForm = GlobalKey<FormState>();
  var autoValidate = AutovalidateMode.disabled;
  double mAnimatedButtonSize = 280.0;
  bool mButtonTextVisibility = true;
  ButtonShrinkStatus mButtonShrinkStatus = ButtonShrinkStatus.notStarted;
  final ScanController _scanController = ScanController();

  @override
  Widget build(BuildContext context) {
    return BrLottoScaffold(
      resizeToAvoidBottomInset: false,
      showAppBar: true,
      //centerTitle: false,
      appBarTitle: widget.titleName,
      body: BlocListener<QrScanBloc, QrScanState>(
        listener: (context, state) {
          if (state is QrScanLoading) {
            setState(() {
              isLoading = true;
            });
          }
          if (state is QrScanSuccess) {
            QrScanApiResponse qrScanApiResponse = state.response;
            setState(() {
              isLoading = false;
            });
            Alert.show(
              isDarkThemeOn: false,
              type: AlertType.success,
              buttonClick: () {
                // _scanController.resume();
                Navigator.of(context).pop();
              },
              title: context.l10n.success,
              subtitle: qrScanApiResponse.responseData.message,
              buttonText: context.l10n.ok.toUpperCase(),
              context: context,
            );
          }
          if (state is QrScanError) {
            setState(() {
              isLoading = false;
              mAnimatedButtonSize = 280.0;
              mButtonTextVisibility = true;
              mButtonShrinkStatus = ButtonShrinkStatus.over;
            });
            // Navigator.of(context).pop();
            Alert.show(
              isDarkThemeOn: false,
              type: AlertType.error,
              buttonClick: () {
                // _scanController.resume();
                Navigator.of(context).pop();
              },
              title: context.l10n.error,
              subtitle: state.errorMessage,
              buttonText: context.l10n.ok.toUpperCase(),
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
                  child: ScanView(
                    controller: _scanController,
                    scanAreaScale: .7,
                    scanLineColor: BrLottoPosColor.tomato,
                    onCapture: (data) {
                      setState(() {
                        barCodeController.text = data;
                      });
                      // BlocProvider.of<QrScanBloc>(context).add(GetQrScanDataApi(context: context));
                    },
                  ),
                ),
                _submitButton()
              ],
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
          maxLength: 16,
          inputType: TextInputType.text,
          hintText: context.l10n.ticket_number,
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
          // isDarkThemeOn: isDarkThemeOn,
        ).p20());
  }

  String validateInput(TotalTextFields textField) {
    switch (textField) {
      case TotalTextFields.userName:
        var mobText = barCodeController.text.trim();
        if (mobText.isEmpty) {
          return context.l10n.please_enter_ticket_number;
        }
        break;
      default:
        return "";
    }
    return '';
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
          BlocProvider.of<QrScanBloc>(context).add(GetWinClaimDataApi(
              context: context, barCodetext: barCodeController.text));
        } else {
          setState(() {
            autoValidate = AutovalidateMode.onUserInteraction;
          });
        }
      },
      child: Container(
          decoration: BoxDecoration(
              color: BrLottoPosColor.icon_green,
              borderRadius: BorderRadius.circular(60)),
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
                      child:  Text(
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
