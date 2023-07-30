import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppElevatedButton extends StatelessWidget {
  const AppElevatedButton({
    Key? key,
    this.onTap,
    required this.child,
  }) : super(key: key);

  final VoidCallback? onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    Widget text = child;
    if (text is Text) {
      text = Text(
        text.data ?? '-',
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.25.sp,
          color: Colors.white,
        ),
      );
    }

    return Container(
      height: 32.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        color: Colors.black87,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16.r),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Center(child: text),
          ),
        ),
      ),
    );
  }
}
