import 'package:ai_translate/main.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.radius,
    this.borderColor,
    this.backgroundColor,
    this.isDisable = false,
    this.contentPadding,
  });

  final Function() onPressed;
  final Widget child;
  final BorderRadiusGeometry? radius;
  final Color? borderColor;
  final Color? backgroundColor;
  final EdgeInsets? contentPadding;
  final bool isDisable;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: isDisable ? null : onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: isDisable ? appTheme.background700Color : backgroundColor ?? appTheme.appColor,
        minimumSize: Size.zero,
        padding: contentPadding ?? EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: radius ?? BorderRadius.circular(4),
          side: BorderSide(color: isDisable ? appTheme.background700Color : borderColor ?? appTheme.appColor),
        ),
      ),
      child: child,
    );
  }
}
