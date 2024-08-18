import 'package:br_lotto/utility/br_lotto_pos_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class TextShimmer extends StatefulWidget {
  Color color;
  String text;
  double? size;
  TextShimmer({Key? key, required this.color, required this.text, this.size}) : super(key: key);

  @override
  State<TextShimmer> createState() => _TextShimmerState();
}

class _TextShimmerState extends State<TextShimmer> {
  @override
  Widget build(BuildContext context) {
    Widget title = Text(
      widget.text,
      style: TextStyle(
        fontSize: widget.size ?? 18,
        color: BrLottoPosColor.white,
      )
    );

    title = title
        .animate(onPlay: (controller) => controller.repeat())
        .shimmer(duration:800.ms, color: widget.color)
        .animate() // this wraps the previous Animate in another Animate
        .fadeIn(duration: 300.ms, curve: Curves.elasticInOut);

    return title;
  }
}
