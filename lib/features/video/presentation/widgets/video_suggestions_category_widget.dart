import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_app/shared/widgets/elevated_button.dart';

class VideoSuggestionsCategoryWidget extends StatelessWidget {
  const VideoSuggestionsCategoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 48.w,
      padding: EdgeInsets.symmetric(vertical: 8.w),
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        itemCount: _items.length,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(
            width: 8.w,
          );
        },
        itemBuilder: (BuildContext context, int index) {
          final item = _items[index];
          return AppElevatedButton(
            radius: 8.r,
            child: Text(item),
          );
        },
      ),
    );
  }
}

final _items = [
  'All',
  'Animal',
  'Cartoon',
  'Anime',
  'Movies',
  'Funny',
];
