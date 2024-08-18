import 'package:br_lotto/utility/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../br_lotto_pos_color.dart';

class SelectWeekMonth extends StatefulWidget {
  final String title;
  final String selectedData;

  const SelectWeekMonth({
    Key? key,
    required this.title,
    required this.selectedData,
  }) : super(key: key);

  @override
  State<SelectWeekMonth> createState() => _SelectWeekMonthDateState();
}

class _SelectWeekMonthDateState extends State<SelectWeekMonth> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.title == widget.selectedData ?
        BrLottoPosColor.br_lotto_green
        :BrLottoPosColor. white,
        borderRadius: const BorderRadius.all(
          Radius.circular(20),
        ),
        border: Border.all(
          color: BrLottoPosColor.br_lotto_green,
        ),
      ),
      child: Center(
        child: FittedBox(
          child: Text(
            widget.title,
            style:   TextStyle(
                color: widget.title == widget.selectedData ?
                BrLottoPosColor.white
                    :BrLottoPosColor.  br_lotto_green,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.normal,
                fontSize: 14.0),
          ).p(8),
        ),
      ),
    ).pOnly(left: 10);
  }
}
