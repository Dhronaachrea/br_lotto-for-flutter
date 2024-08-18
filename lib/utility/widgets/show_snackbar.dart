import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

import '../br_lotto_pos_color.dart';

class ShowToast {
  static showToast(BuildContext context,String msg, {ToastType? type}) {
    return Flushbar(
      messageText: Text(
        msg,
        style: const TextStyle(fontSize: 14.0, color: Colors.white),
        textAlign: TextAlign.center,
      ),
      duration: const Duration(seconds: 2),
      backgroundColor: type?.color ?? Colors.red,
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.FLOATING,
      borderRadius: const BorderRadius.all(Radius.circular(10.0)),
      maxWidth: context.screenWidth - 40,
      margin: const EdgeInsets.only(bottom: 20),
    ).show(context);
  }
}

enum ToastType {
  SUCCESS,
  ERROR,
  WARNING,
  INFO,
}

extension ToastExtention on ToastType {
  Color get color {
    switch (this) {
      case ToastType.SUCCESS:
        return BrLottoPosColor.shamrock_green;
      case ToastType.ERROR:
        return BrLottoPosColor.reddish_pink;
      case ToastType.INFO:
        return BrLottoPosColor.app_blue;
      default:
        return BrLottoPosColor.reddish_pink;
    }
  }
}
