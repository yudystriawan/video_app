import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_app/shared/widgets/bottom_sheet.dart';

Future showAddVideoBottomSheet(BuildContext context) {
  return showAppBottomSheet(
    context,
    maxHeight: 370.w,
    child: Column(
      children: [
        Row(
          children: [
            const Icon(Icons.shop_two_outlined),
            SizedBox(
              width: 10.w,
            ),
            const Expanded(child: Text('Create a Short')),
          ],
        ),
      ],
    ),
  );
}
