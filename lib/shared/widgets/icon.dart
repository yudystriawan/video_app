import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppIcon extends StatelessWidget {
  const AppIcon({
    Key? key,
    required this.icon,
    this.onTap,
    this.size,
    this.color,
  }) : super(key: key);

  final Widget icon;
  final VoidCallback? onTap;
  final double? size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final size = this.size ?? 24.w;

    Widget icon = this.icon;
    if (color != null) {
      if (icon is Icon) {
        icon = Icon(
          icon.icon,
          color: color,
        );
      }
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12.r),
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
