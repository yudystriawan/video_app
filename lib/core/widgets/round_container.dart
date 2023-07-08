import 'package:flutter/material.dart';

class RoundContainer extends StatelessWidget {
  const RoundContainer({
    Key? key,
    required this.child,
    this.onTap,
    this.color,
    this.padding,
  }) : super(key: key);

  final Widget child;
  final VoidCallback? onTap;
  final Color? color;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color ?? Colors.white38,
        ),
        padding: padding ?? const EdgeInsets.all(4),
        child: child,
      ),
    );
  }
}
