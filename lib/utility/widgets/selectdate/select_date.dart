import 'package:br_lotto/utility/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../br_lotto_pos_color.dart';

class SelectDate extends StatefulWidget {
  final String title;
  final String date;
  final VoidCallback onTap;

  const SelectDate({
    Key? key,
    required this.title,
    required this.date,
    required this.onTap,
  }) : super(key: key);

  @override
  State<SelectDate> createState() => _SelectDateState();
}

class _SelectDateState extends State<SelectDate> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          color: BrLottoPosColor.white,
          borderRadius: const BorderRadius.all(
            Radius.circular(5),
          ),
          border: Border.all(
            color: BrLottoPosColor.warm_grey_six.withOpacity(0.5),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: TextStyle(
                  color: BrLottoPosColor.black.withOpacity(0.5),
                  fontWeight: FontWeight.w500,
                  fontFamily: noirFont,
                  fontSize: 13.0),
            ),
            const HeightBox(5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.date,
                  style: TextStyle(
                      color: BrLottoPosColor.black.withOpacity(0.5),
                      fontWeight: FontWeight.w500,
                      fontFamily: noirFont,
                      fontStyle: FontStyle.normal,
                      fontSize: 14.0),
                ),
                const WidthBox(10),
                SvgPicture.asset(
                  "assets/icons/calendar_date_picker.svg",
                  width: 15,
                  height: 15,
                ),
              ],
            ),
          ],
        ).pSymmetric(h: 12, v: 5),
      ),
    );
  }
}
