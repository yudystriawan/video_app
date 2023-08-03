import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<T?> showAppBottomSheet<T>(
  BuildContext context, {
  Widget? child,
  double? maxHeight,
}) {
  return showModalBottomSheet<T?>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    constraints: BoxConstraints(
      maxHeight: maxHeight ??
          MediaQuery.of(context).size.height -
              MediaQueryData.fromView(View.of(context)).padding.top -
              kToolbarHeight,
    ),
    builder: (context) {
      return Container(
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
