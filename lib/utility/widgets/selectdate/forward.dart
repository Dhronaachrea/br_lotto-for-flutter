import 'package:flutter/material.dart';

import '../../br_lotto_pos_color.dart';

class Forward extends StatefulWidget {
  final VoidCallback onTap;

  const Forward({Key? key, required this.onTap})
      : super(key: key);

  @override
  State<Forward> createState() => _ForwardState();
}

class _ForwardState extends State<Forward> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        width: 45,
        height: 45,
        decoration: const BoxDecoration(
          color: BrLottoPosColor.medium_green,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.arrow_forward_ios,
          color: BrLottoPosColor.white,
        ),
      ),
    );
  }
}