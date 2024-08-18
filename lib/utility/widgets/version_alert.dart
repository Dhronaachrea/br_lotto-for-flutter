import 'package:br_lotto/l10n/l10n.dart';
import 'package:br_lotto/utility/widgets/tertiary_button.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import '../br_lotto_pos_color.dart';

enum VersionAlertType {
  mandatory,
  optional,
}

class VersionAlert {
  static show({
    required BuildContext context,
    required VersionAlertType type,
    required String message,
    String? description,
    VoidCallback? onUpdate,
    VoidCallback? onCancel,
  }) {
    bool isLoading = false;
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (ctx, setState) {
            return Center(
              child: Material(
                color: Colors.transparent,
                child: Wrap(
                  children: [
                    Stack(
                        children:[
                          Container(
                            margin: const EdgeInsets.all(18),
                            child: Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(18),
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(colors: [
                                      Colors.transparent,
                                      Colors.transparent,
                                    ]),

                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.all(18),
                                    decoration: BoxDecoration(
                                      color: BrLottoPosColor.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      children: [
                                        const HeightBox(5),
                                        Image.asset('assets/images/login_logo.png',width: 70, height: 70,),
                                        const HeightBox(10),
                                        // const Text(
                                        //   "Br Lotto",
                                        //   textAlign: TextAlign.center,
                                        //   style: TextStyle(
                                        //     color: BrLottoPosColor.navy_blue,
                                        //     fontSize: 20,
                                        //     fontWeight: FontWeight.bold,
                                        //   ),
                                        // ),
                                        const HeightBox(8),
                                        Text(
                                          message,
                                          style: const TextStyle(
                                            color: BrLottoPosColor.shamrock_green,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        description != null
                                            ? Text(
                                          description,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          textAlign: TextAlign.center,
                                        ).py8()
                                            : Container(),
                                        const HeightBox(20),
                                        type == VersionAlertType.optional
                                            ? isLoading
                                            ? const SizedBox(height: 20,).pOnly(left: 30,right: 30)
                                            : Row(children: [
                                          Expanded(
                                            child: TertiaryButton(
                                              textColor: BrLottoPosColor.game_color_red,
                                              type: ButtonType.line_art,
                                              onPressed: onCancel != null
                                                  ? () {
                                                Navigator.of(ctx).pop();
                                                onCancel();
                                              }
                                                  : () {
                                                Navigator.of(ctx).pop();
                                              },
                                              text: (context.l10n.no).toString(),
                                              fontSize: 18,
                                            ),
                                          ),
                                          const WidthBox(10),
                                          Expanded(
                                            child: TertiaryButton(
                                              color: BrLottoPosColor.butter_scotch,
                                              onPressed: onUpdate != null
                                                  ? () {
                                                // Navigator.of(ctx).pop();
                                                setState((){
                                                  isLoading = false;
                                                });
                                                onUpdate();
                                              }
                                                  : () {
                                                Navigator.of(ctx).pop();
                                              },
                                              text: (context.l10n.update).toString(),
                                              fontSize: 18,
                                            ),
                                          ),
                                        ],).pOnly(left: 30,right: 30)
                                            : isLoading
                                            ? SizedBox(height: 20,).pOnly(left: 30,right: 30)
                                            : TertiaryButton(
                                          color: BrLottoPosColor.app_blue,
                                          width: context.screenWidth,
                                          onPressed: onUpdate != null
                                              ? () {
                                            // Navigator.of(ctx).pop();
                                            setState((){
                                              isLoading = false;
                                            });
                                            onUpdate();
                                          }
                                              : () {
                                            Navigator.of(ctx).pop();
                                          },
                                          text: (context.l10n.update).toString(),
                                        ).pOnly(left: 30,right: 30),

                                        /*isLoading
                                            ? LinearProgressIndicator(
                                                color: LongaLottoPosColor.navy_blue,
                                              )
                                            : Container()*/
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ]
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
