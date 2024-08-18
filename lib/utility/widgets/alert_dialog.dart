import 'package:br_lotto/l10n/l10n.dart';
import 'package:br_lotto/utility/widgets/gradient_line.dart';
import 'package:br_lotto/utility/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

import '../br_lotto_pos_color.dart';
import 'alert_type.dart';

class Alert {
  static show({
    required BuildContext context,
    required String title,
    required String subtitle,
    required String buttonText,
    bool? isBackPressedAllowed,
    VoidCallback? buttonClick,
    VoidCallback? closeButtonClick,
    bool isDarkThemeOn = true,
    bool? isCloseButton = false,
    AlertType? type = AlertType.error,
    Widget? otherData,
  }) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext ctx) {
        AlertType alertType = type ?? AlertType.error;
        return WillPopScope(
          onWillPop: () async {
            return isBackPressedAllowed ?? true;
          },
          child: Dialog(
            insetPadding:
                const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
            backgroundColor: BrLottoPosColor.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                isCloseButton ?? false ? _gradientLine() : Container(),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const HeightBox(10),
                    alertIcon(isDarkThemeOn, alertType),
                    const HeightBox(10),
                    alertTitle(title, isDarkThemeOn, alertType),
                    const HeightBox(10),
                    alertSubtitle(subtitle, isDarkThemeOn),
                    const HeightBox(20),
                    otherData ?? Container(),
                    buttons(isCloseButton ?? false, buttonClick, buttonText,
                        ctx, isDarkThemeOn, closeButtonClick),
                    const HeightBox(10),
                  ],
                ).pSymmetric(v: 20, h: 50),
              ],
            ),
          ),
        );
      },
    );
  }

  static alertIcon(bool isDarkThemeOn, AlertType type) {
    switch(type){
      case AlertType.error:
        return Image.asset(
          "assets/icons/icon_error.png",
          width: 60,
          height: 60,
        );
      case AlertType.success:
        return Image.asset(
          "assets/icons/success.png",
          width: 60,
          height: 60,
        );
      default:
        return Image.asset(
          "assets/icons/icon_confirmation.png",
          width: 60,
          height: 60,
        );
    }
    // return Image.asset(
    //   "assets/icons/icon_confirmation.png",
    //   width: 60,
    //   height: 60,
    // );
    return Image.asset(
      _getImagePath(isDarkThemeOn, type),
      width: 60,
      height: 60,
    );
  }

  static alertTitle(String title, bool isDarkThemeOn, AlertType type) {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 28,
        color: _getTextColor(isDarkThemeOn, type),
        fontWeight: FontWeight.w700,
      ),
    );
  }

  static alertSubtitle(String subtitle, bool isDarkThemeOn) {
    return Text(
      subtitle,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: isDarkThemeOn ? BrLottoPosColor.white : BrLottoPosColor.black,
        fontSize: 16.0,
      ),
    );
  }

  static confirmButton(VoidCallback? buttonClick, String buttonText,
      BuildContext ctx, bool isDarkThemeOn) {
    return PrimaryButton(
      width: double.infinity,
      height: 52,
      fillDisableColor:
          isDarkThemeOn ? BrLottoPosColor.white : BrLottoPosColor.marigold,
      onPressed: buttonClick != null
          ? () {
              Navigator.of(ctx).pop();
              buttonClick();
            }
          : () {
              Navigator.of(ctx).pop();
            },
      text: buttonText,
      isDarkThemeOn: isDarkThemeOn,
    );
  }

  static buttons(bool isCloseButton, VoidCallback? buttonClick,
      String buttonText, BuildContext ctx, bool isDarkThemeOn, VoidCallback? closeButtonClick,) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        isCloseButton
            ? Expanded(
                child: closeButton(ctx, isDarkThemeOn, closeButtonClick),
              )
            : const SizedBox(),
        isCloseButton ? const WidthBox(20) : const SizedBox(),
        Expanded(
          child: confirmButton(buttonClick, buttonText, ctx, isDarkThemeOn),
        ),
      ],
    );
  }

  static closeButton(BuildContext ctx, bool isDarkThemeOn, VoidCallback? closeButtonClick) {
    return PrimaryButton(
      width: double.infinity / 2,
      height: 52,
      fillDisableColor: BrLottoPosColor.white,
      fillEnableColor: BrLottoPosColor.white,
      textColor: BrLottoPosColor.tomato,
      onPressed: closeButtonClick != null ? () {
        Navigator.of(ctx).pop();
        closeButtonClick();
      } : () {
      Navigator.of(ctx).pop();
    },
      borderColor: BrLottoPosColor.tomato,
      text: ctx.l10n.cancel,
      isCancelBtn: true,
      isDarkThemeOn: isDarkThemeOn,
    );
  }

  static _gradientLine() {
    return const GradientLine(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10),
      ),
    );
  }

  static _getTextColor(bool isDarkThemeOn, AlertType type) {
    Color color;
    switch (type) {
      case AlertType.success:
        color = BrLottoPosColor.shamrock_green;
        break;
      case AlertType.error:
        color = BrLottoPosColor.reddish_pink;
        break;
      case AlertType.warning:
        color = BrLottoPosColor.marigold;
        break;
      case AlertType.confirmation:
        color =
            isDarkThemeOn ? BrLottoPosColor.butter_scotch : BrLottoPosColor.marigold;
        break;
      default:
        color = BrLottoPosColor.reddish_pink;
    }
    return color;
  }

  static String _getImagePath(bool isDarkThemeOn, AlertType type) {
    String imagePath;
    switch (type) {
      case AlertType.success:
        imagePath = 'assets/icons/icon_success.png';
        break;
      case AlertType.error:
        imagePath = 'assets/icons/icon_error.png';
        break;
      case AlertType.warning:
        //ToDo need to change the image for warning
        imagePath = 'assets/icons/icon_success.png';
        break;
      case AlertType.confirmation:
        imagePath = 'assets/icons/icon_confirmation.png';
        break;
      default:
        imagePath = 'assets/icons/icon_error.png';
    }
    return imagePath;
  }

// to be used in sports pool game to select other price
  static customShow({
    required BuildContext context,
    required String buttonText,
    bool? isBackPressedAllowed,
    bool isDarkThemeOn = true,
    bool? isCloseButton = false,
    required Widget child,
  }) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext ctx) {
        return WillPopScope(
          onWillPop: () async {
            return isBackPressedAllowed ?? true;
          },
          child: StatefulBuilder(
            builder: (context, setState) {
              return Dialog(
                insetPadding: const EdgeInsets.symmetric(
                    horizontal: 32.0, vertical: 24.0),
                backgroundColor: BrLottoPosColor.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    isCloseButton ?? false ? _gradientLine() : Container(),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const HeightBox(10),
                        child,
                        const HeightBox(10),
                        PrimaryButton(
                          width: double.infinity,
                          height: 52,
                          fillDisableColor: isDarkThemeOn
                              ? BrLottoPosColor.white
                              : BrLottoPosColor.marigold,
                          onPressed:() {
                                  Navigator.of(ctx).pop();
                                },
                          text: buttonText,
                          isDarkThemeOn: isDarkThemeOn,
                        ),
                        const HeightBox(10),
                      ],
                    ).pSymmetric(v: 20, h: 50),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
