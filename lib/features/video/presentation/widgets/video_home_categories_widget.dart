import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_app/shared/widgets/elevated_button.dart';

class VideoHomeCategoriesWidget extends StatelessWidget {
  const VideoHomeCategoriesWidget({
    Key? key,
    required this.onDrawerTap,
  }) : super(key: key);

  final VoidCallback onDrawerTap;

  @override
  Widget build(BuildContext context) {
    final radius = 8.r;
    return Container(
      height: 48.w,
      padding: EdgeInsets.symmetric(vertical: 8.w),
      child: ListView.separated(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: _items.length,
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(
            width: 8.w,
          );
        },
        itemBuilder: (BuildContext context, int index) {
          final widget = AppElevatedButton(
            radius: radius,
            child: Text(_items[index]),
          );

          if (index == 0) {
            return Row(
              children: [
                AppElevatedButton(
                  radius: radius,
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  onTap: onDrawerTap,
                  child: const Icon(
                    Icons.explore_outlined,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 16.w),
                widget,
              ],
            );
          }
          return widget;
        },
      ),
    );
  }
}

final _items = [
  'All',
  'Anime',
  'Cartoon',
  'Cars',
  'Music',
  'Technology',
  'Yoga',
  'Comedy'
];
