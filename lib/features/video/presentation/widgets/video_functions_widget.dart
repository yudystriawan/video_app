import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../shared/widgets/elevated_button.dart';
import '../../../../shared/widgets/icon.dart';

class VideoFunctionsWidget extends StatelessWidget {
  const VideoFunctionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.w,
      padding: EdgeInsets.symmetric(vertical: 8.w),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Row(
          children: [
            AppElevatedButton(
              child: Row(
                children: [
                  AppIcon(
                    icon: const Icon(Icons.thumb_up_alt_outlined),
                    size: 16.w,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 8.w,
                  ),
                  const Text(
                    '999',
                    style: TextStyle(color: Colors.white),
                  ),
                  VerticalDivider(
                    color: Colors.white,
                    indent: 8.w,
                    endIndent: 8.w,
                  ),
                  AppIcon(
                    icon: const Icon(Icons.thumb_down_alt_outlined),
                    size: 16.w,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 12.w,
            ),
            AppElevatedButton(
              child: Row(
                children: [
                  Icon(
                    Icons.share,
                    color: Colors.white,
                    size: 16.w,
                  ),
                  SizedBox(
                    width: 4.w,
                  ),
                  const Text(
                    'Share',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 12.w,
            ),
            AppElevatedButton(
              child: Row(
                children: [
                  Icon(
                    Icons.bookmark_add_outlined,
                    color: Colors.white,
                    size: 16.w,
                  ),
                  SizedBox(
                    width: 4.w,
                  ),
                  const Text(
                    'Save',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 12.w,
            ),
            AppElevatedButton(
              child: Row(
                children: [
                  Icon(
                    Icons.download_outlined,
                    color: Colors.white,
                    size: 16.w,
                  ),
                  SizedBox(
                    width: 4.w,
                  ),
                  const Text(
                    'Download',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
