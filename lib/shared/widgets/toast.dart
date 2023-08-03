import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void showToast(
  BuildContext context, {
  required Widget title,
  Widget? leading,
  Widget? trailing,
}) {
  final content = Row(
    children: [
      if (leading != null) ...[leading, SizedBox(width: 12.w)],
      Expanded(child: title),
      if (trailing != null) trailing,
    ],
  );
  ScaffoldMessenger.of(context).showSnackBar(_createSnackbar(content));
}

SnackBar _createSnackbar(Widget content) {
  return SnackBar(
    content: content,
    behavior: SnackBarBehavior.floating,
    duration: const Duration(milliseconds: 1500),
    padding: EdgeInsets.all(12.w),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.r),
    ),
  );
}
