import 'dart:async';

import 'package:br_lotto/utility/br_lotto_pos_color.dart';
import 'package:br_lotto/utility/utils.dart';
import 'package:flutter/material.dart';

enum ButtonType {
  solid,
  line_art,
}

class TertiaryButton extends StatefulWidget {
  final String? text;
  final VoidCallback onPressed;
  final bool? enabled;
  final Widget? child;
  final double? borderRadius;
  final double? width;
  final EdgeInsets? margin;
  final double? height;
  final ButtonType? type;
  final Color? color;
  final Color? textColor;
  final double? fontSize;

  const TertiaryButton({
    Key? key,
    required this.onPressed,
    this.text,
    this.enabled = true,
    this.child,
    this.borderRadius,
    this.width,
    this.margin,
    this.height,
    this.type = ButtonType.solid,
    this.color,
    this.textColor,
    this.fontSize,
  }) : super(key: key);

  @override
  State<TertiaryButton> createState() => _TertiaryButtonState();
}

class _TertiaryButtonState extends State<TertiaryButton> {
  bool didPressOnce = false;
  @override
  Widget build(BuildContext context) {
    var enabledStyle = ElevatedButton.styleFrom(
      backgroundColor: widget.color ?? BrLottoPosColor.tangerine,
      foregroundColor: widget.textColor ?? Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(widget.borderRadius ?? 8),
      ),
    );
    var disabledStyle = ElevatedButton.styleFrom(
      backgroundColor: widget.color?.withOpacity(0.5) ?? const Color(0xfffecc58),
      foregroundColor: widget.textColor ?? Colors.white,
      shadowColor: Colors.transparent,
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(widget.borderRadius ?? 8),
      ),
    );
    var lineArtStyle = ElevatedButton.styleFrom(
      backgroundColor: Colors.transparent,
      foregroundColor: widget.textColor ?? BrLottoPosColor.tangerine, // textColor
      shadowColor: Colors.transparent,
      elevation: 0,
      disabledBackgroundColor: widget.textColor ?? Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(widget.borderRadius ?? 8),
      ),
      side: BorderSide(
          width: 2, color: widget.textColor ?? BrLottoPosColor.tangerine),
    );

    return Container(
      margin: widget.margin ?? const EdgeInsets.symmetric(vertical: 8),
      width: widget.width,
      height: widget.height,
      child: ElevatedButton(
        onPressed: widget.enabled == true
            ? didPressOnce == false
            ? () {
          setState(() => didPressOnce = true);
          widget.onPressed();
          Timer(buttonClickThreshold, () {
            if (!mounted) return;
            setState(() => didPressOnce = false);
          });
        }
            : () {}
            : () {},
        style: widget.type == ButtonType.solid
            ? (widget.enabled == true ? enabledStyle : disabledStyle)
            : lineArtStyle,
        child: widget.text != null
            ? FittedBox(
          fit: BoxFit.fitHeight,
          child: Center(
            child: Text(
              widget.text!,
              style: TextStyle(
                fontSize: widget.fontSize ?? 18,
                fontWeight: FontWeight.w500,
                color: (widget.type == ButtonType.line_art)
                    ? widget.textColor ?? BrLottoPosColor.tangerine
                    : null,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        )
            : widget.child,
      ),
    );
  }
}
