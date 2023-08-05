import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<T?> showAppBottomSheet<T>(
  BuildContext context, {
  Widget? child,
  double? maxHeight,
}) {
  final padding = MediaQueryData.fromView(View.of(context)).padding;
  return showModalBottomSheet<T?>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    constraints: BoxConstraints(
      maxHeight: maxHeight ??
          MediaQuery.of(context).size.height - padding.top.w - kToolbarHeight.w,
    ),
    builder: (context) {
      return Container(
        padding: EdgeInsetsDirectional.only(
          top: 16.w,
          start: 12.w,
          end: 12.w,
          bottom: 8.w + padding.bottom.w,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.r),
            topRight: Radius.circular(16.r),
          ),
          color: Colors.white,
        ),
        child: child,
      );
    },
  );
}
