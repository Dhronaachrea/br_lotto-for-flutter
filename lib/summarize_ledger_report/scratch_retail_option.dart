import 'package:br_lotto/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

import '../utility/app_constant.dart';
import '../utility/br_lotto_pos_color.dart';

class ScratchRetailOption extends StatelessWidget {
  final VoidCallback onScratchTap;
  final VoidCallback onRetailTap;
  final ReportType reportType;

  const ScratchRetailOption(
      {Key? key,
      required this.onScratchTap,
      required this.onRetailTap,
      required this.reportType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double scratchOrRetailHeight = 40;
    return SizedBox(
      height: scratchOrRetailHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              onScratchTap();
            },
            child: Container(
              width: context.screenWidth / 2.5,
              height: scratchOrRetailHeight,
              decoration: BoxDecoration(
                color: reportType == ReportType.scratch
                    ? BrLottoPosColor.medium_green
                    : BrLottoPosColor.white,
                border:
                    Border.all(color: BrLottoPosColor.medium_green, width: 2),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  bottomLeft: Radius.circular(30),
                ),
              ),
              child: FittedBox(
                child: Text(context.l10n.scratch.toUpperCase(),
                        style: TextStyle(
                            color: reportType == ReportType.scratch
                                ? BrLottoPosColor.white
                                : BrLottoPosColor.medium_green,
                            fontWeight: FontWeight.w500,
                            fontFamily: "",
                            fontStyle: FontStyle.normal,
                            fontSize: 12.0),
                        textAlign: TextAlign.center)
                    .p(8),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              onRetailTap();
            },
            child: Container(
              width: context.screenWidth / 2.5,
              height: scratchOrRetailHeight,
              decoration: BoxDecoration(
                color: reportType == ReportType.retail
                    ? BrLottoPosColor.medium_green
                    : BrLottoPosColor.white,
                border:
                    Border.all(color: BrLottoPosColor.medium_green, width: 2),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: FittedBox(
                child: Text(context.l10n.retail_payment.toUpperCase(),
                        style: TextStyle(
                            color: reportType == ReportType.retail
                                ? BrLottoPosColor.white
                                : BrLottoPosColor.medium_green,
                            fontWeight: FontWeight.w500,
                            fontFamily: "",
                            fontStyle: FontStyle.normal,
                            fontSize: 12.0),
                        textAlign: TextAlign.center)
                    .p(8),
              ),
            ),
          ),
        ],
      ),
    ).p(8);
  }
}
