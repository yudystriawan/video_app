import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_app/shared/widgets/bottom_sheet.dart';
import 'package:video_app/shared/widgets/circle_container.dart';
import 'package:video_app/shared/widgets/icon.dart';

Future<String?> showAddVideoBottomSheet(BuildContext context) {
  return showAppBottomSheet<String?>(
    context,
    maxHeight: 370.w,
    child: Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                'Create',
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(
              width: 12.w,
            ),
            AppIcon(
              icon: const Icon(Icons.close),
              size: 18.w,
              onTap: () => context.router.pop(),
            ),
          ],
        ),
        SizedBox(
          height: 16.w,
        ),
        AddVideoItemWidget(
          icon: const Icon(Icons.shop_two_outlined),
          label: 'Create a Short',
          onTap: () => context.router.pop('Create a Short'),
        ),
        SizedBox(
          height: 24.w,
        ),
        AddVideoItemWidget(
          icon: const Icon(Icons.upload_sharp),
          label: 'Upload a video',
          onTap: () => context.router.pop('Upload a video'),
        ),
        SizedBox(
          height: 24.w,
        ),
        AddVideoItemWidget(
          icon: const Icon(Icons.live_tv),
          label: 'Go live',
          onTap: () => context.router.pop('Go live'),
        ),
        SizedBox(
          height: 24.w,
        ),
        AddVideoItemWidget(
          icon: const Icon(Icons.edit_square),
          label: 'Create a post',
          onTap: () => context.router.pop('Create a post'),
        ),
      ],
    ),
  );
}

class AddVideoItemWidget extends StatelessWidget {
  const AddVideoItemWidget({
    Key? key,
    this.onTap,
    required this.label,
    required this.icon,
  }) : super(key: key);

  final VoidCallback? onTap;
  final String label;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(48.r),
        child: Row(
          children: [
            CircleContainer(
              size: 48.w,
              child: icon,
            ),
            SizedBox(
              width: 10.w,
            ),
            Expanded(
              child: Text(
                label,
                style: TextStyle(fontSize: 16.sp),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
