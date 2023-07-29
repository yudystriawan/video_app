import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppIcon extends StatelessWidget {
  const AppIcon({
    Key? key,
    required this.icon,
    this.onTap,
    this.size,
  }) : super(key: key);

  final Widget icon;
  final VoidCallback? onTap;
  final double? size;

  @override
  Widget build(BuildContext context) {
    final size = this.size ?? 24.w;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(4.r),
          onTap: onTap,
          child: SizedBox(
            width: size,
            height: size,
            child: icon,
          ),
        ),
      ),
    );
  }
}
