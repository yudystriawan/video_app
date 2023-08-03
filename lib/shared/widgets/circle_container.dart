import 'package:flutter/material.dart';

class CircleContainer extends StatelessWidget {
  const CircleContainer({
    Key? key,
    required this.size,
    this.child,
    this.color,
    this.border,
  }) : super(key: key);

  final double size;
  final Widget? child;
  final Color? color;
  final BoxBorder? border;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color ?? Colors.grey.shade200,
        border: border,
      ),
      child: SizedBox(
        width: size,
        height: size,
        child: child,
      ),
    );
  }
}
